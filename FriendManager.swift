//
//  FriendManager.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-11-29.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import Foundation
import ContactsUI

struct FriendManager {
    
    lazy var contacts: [CNContact] = {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return results
    }()
    

    mutating func fetchPhoneNumbers() -> [String] {
        
        var result: [String] = []
        let filters = ["-","(",")"," "]
        
        for contact in self.contacts {
            
            for phoneNumber in contact.phoneNumbers {
                if let phoneNumberStruct = phoneNumber.value as? CNPhoneNumber {
                    var phoneNumberString = phoneNumberStruct.stringValue
                    
                    for char in filters {
                        phoneNumberString = phoneNumberString.replacingOccurrences(of: char, with: "")
                    }
                    phoneNumberString = phoneNumberString.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression, range:nil)
                    result.append(phoneNumberString)
                }
            }
        }
        
        return result
    }
    
}
