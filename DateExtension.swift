//
//  DateExtension.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-10-09.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import Foundation

//MARK: - Convert Date to string
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy,HH:mm"
        return dateFormatter.string(from: self)
    }
}
