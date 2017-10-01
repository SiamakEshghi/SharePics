//
//  ZoomTransitioningDelegate.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-09-21.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit


@objc
protocol ZoomingViewController {
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView?
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView?
}

enum TransitionState {
    case initial
    case final
}

class ZoomTransitioningDelegate: NSObject
{
    var transitionDuration = 0.5
    var operation: UINavigationControllerOperation = .none
    private let zoomScale = CGFloat(15)
    private let backGroundScale = CGFloat(7)
    
    typealias ZoomingViews  = (otherView: UIView, imageView: UIView)
    
    func configureViews(for state: TransitionState, containerView:UIView,backGroundViewController:UIViewController,viewsInBackground:ZoomingViews, viewsInForeground: ZoomingViews,snapshotsViews: ZoomingViews)  {
        switch state {
        case .initial:
            backGroundViewController.view.transform = CGAffineTransform.identity
            backGroundViewController.view.alpha = 1
            snapshotsViews.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, from: viewsInBackground.imageView.superview)
        case .final:
            backGroundViewController.view.transform = CGAffineTransform(scaleX: backGroundScale, y: backGroundScale)
            backGroundViewController.view.alpha = 0
            snapshotsViews.imageView.frame = containerView.convert(viewsInForeground.imageView.frame, from: viewsInForeground.imageView.superview)
        }
    }
    
}

extension ZoomTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromViewConytroller = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containView = transitionContext.containerView
        
        var backgroundViewController = fromViewConytroller
        var forgroundViewController = toViewController
        
        if operation == .pop{
            backgroundViewController = toViewController
            forgroundViewController = fromViewConytroller
        }
        
        let maybeBackgroundImageView = (backgroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)
        let maybeForgroundImageView = (forgroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)
        
        assert(maybeBackgroundImageView != nil,"cannot find imageview in background VC")
        assert(maybeForgroundImageView != nil,"cannot find imageview in forground VC")
        
        let backgroundImagView = maybeBackgroundImageView!
        let forgroundImageview = maybeForgroundImageView!
        
       let imageViewSnapshot = UIImageView(image: backgroundImagView.image)
        imageViewSnapshot.contentMode = .scaleAspectFit
        imageViewSnapshot.layer.masksToBounds = true
        
        backgroundImagView.isHidden = true
        forgroundImageview.isHidden = true
        
        let forgroundviewbackgroundColor = forgroundViewController?.view.backgroundColor
        forgroundViewController?.view.backgroundColor = UIColor.clear
        containView.backgroundColor = UIColor.white
        
        containView.addSubview((backgroundViewController?.view)!)
        containView.addSubview((forgroundViewController?.view)!)
        containView.addSubview(imageViewSnapshot)
        
        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final
        
        if operation == .pop{
            preTransitionState = .final
            postTransitionState = .initial
        }
        configureViews(for: preTransitionState, containerView: containView, backGroundViewController: backgroundViewController!, viewsInBackground: (backgroundImagView,backgroundImagView), viewsInForeground: (forgroundImageview,forgroundImageview), snapshotsViews: (imageViewSnapshot,imageViewSnapshot))
        
        forgroundViewController?.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            
            self.configureViews(for: postTransitionState, containerView: containView, backGroundViewController: backgroundViewController!, viewsInBackground: (backgroundImagView,backgroundImagView), viewsInForeground: (forgroundImageview,forgroundImageview), snapshotsViews: (imageViewSnapshot,imageViewSnapshot))
            
        }) { (finished) in
            backgroundViewController?.view.transform = CGAffineTransform.identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImagView.isHidden = false
            forgroundImageview.isHidden = false
            forgroundViewController?.view.backgroundColor = forgroundviewbackgroundColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

extension ZoomTransitioningDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is ZoomingViewController && toVC is ZoomingViewController {
            self.operation = operation
            return self
        }else{
            return nil
        }
    }
    
    
}
