//
//  ContactViewModel.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class ContactViewModel {
    
    private enum Section: Int {
        case header
        case phoneNumbers
        case emailAddress
        // NOT TO BE USED! This is just for counting the sections
        case total
        
        var title: String {
            switch self {
            case .phoneNumbers: return NSLocalizedString("Phone Numbers", comment: "")
            case .emailAddress: return NSLocalizedString("Emails", comment: "")
            default: return ""
            }
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let contact: Contact
    var formattedBirthday: String { return ContactViewModel.dateFormatter.string(from: contact.dateOfBirth) }
    var numberOfSections: Int { return Section.total.rawValue }
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let sect = Section(rawValue: section) else { return 0 }
        
        switch sect {
        case .header: return 1
        case .phoneNumbers: return contact.phoneNumbers.count
        case .emailAddress: return contact.emailAddresses.count
        default:
            assertionFailure("Unexpected section \(section)")
            return 0
        }
    }
    
    func title(forSection section: Int) -> String {
        return Section(rawValue: section)?.title ?? ""
    }
    
}

extension ContactViewModel {
    
    func configure(headerCell: ContactHeaderCell) {
        headerCell.firstNameLabel.text = contact.firstName
        headerCell.lastNameLabel.text = contact.lastName
        headerCell.dateOfBirthLabel.text = formattedBirthday
    }
    
    func configure(phoneNumberCell cell: UITableViewCell, at indexPath: IndexPath) {
        guard indexPath.row < contact.phoneNumbers.count else { return }
        precondition(indexPath.section == 1)
        cell.textLabel?.text = contact.phoneNumbers[indexPath.row].formattedString
    }
    
    func configure(emailAddressCell cell: UITableViewCell, at indexPath: IndexPath) {
        guard indexPath.row < contact.emailAddresses.count else { return }
        precondition(indexPath.section == 2)
        cell.textLabel?.text = contact.emailAddresses[indexPath.row]
    }
    
}
