//
//  ContactViewModel.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class ContactViewModel {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let contact: Contact
    var formattedBirthday: String { return ContactViewModel.dateFormatter.string(from: contact.dateOfBirth) }
    
    init(contact: Contact) {
        self.contact = contact
    }
    
}

extension ContactViewModel {
    
    func configure(headerCell: ContactHeaderCell) {
        headerCell.firstNameLabel.text = contact.firstName
        headerCell.lastNameLabel.text = contact.lastName
        headerCell.dateOfBirthLabel.text = formattedBirthday
    }
    
}
