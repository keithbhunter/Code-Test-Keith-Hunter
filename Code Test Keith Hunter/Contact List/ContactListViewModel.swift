//
//  ContactListViewModel.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/24/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

final class ContactListViewModel {
    
    var numberOfSections: Int { return sortedKeys.count }
    var sectionIndexTitles: [String] { return sortedKeys }
    
    private var sortedKeys: [String] { return contacts.keys.sorted(by: <) }
    private let contacts: [String : [Contact]]
    
    init<S: Sequence>(contacts: S) where S.Element == Contact {
        self.contacts = Dictionary(grouping: contacts, by: ({ String($0.firstName.first!).uppercased() }))
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard section < sortedKeys.count else { return 0 }
        return contacts[sortedKeys[section]]?.count ?? 0
    }
    
    func title(forSection section: Int) -> String {
        guard section < sortedKeys.count else { return "" }
        return sortedKeys[section]
    }
    
    func contact(at indexPath: IndexPath) -> Contact? {
        guard indexPath.section < sortedKeys.count else { return nil }
        return contacts[sortedKeys[indexPath.section]]?[indexPath.row]
    }
    
}
