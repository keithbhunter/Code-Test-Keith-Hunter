//
//  Contact.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/21/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

struct Contact {
    
    /// A unique identifier, since different people can have
    /// the same name, birthday, etc.
    let id: Int
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var addresses: [String]
    var phoneNumbers: [PhoneNumber]
    var emailAddresses: [String]
    
}

extension Contact: Hashable {
    
    var hashValue: Int { return id.hashValue }
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}

extension Contact: Codable {}
