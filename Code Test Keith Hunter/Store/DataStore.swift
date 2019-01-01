//
//  DataStore.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/21/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

/// A protocol representing the functions needed to keep a list
/// of contacts for the app. This could be implemented using
/// CoreData, a flat file, NSKeyedArchiver, network API or others.
protocol DataStore {
    
    /// Find and return all saved contacts.
    func fetchAllContacts() -> Set<Contact>
    
    /// Saves `contact` as a new contact. If the contact already
    /// exists, the contact will be updated with the new info.
    func save(contact: Contact) throws

    /// Removes `contact` from the data store.
    func delete(contact: Contact) throws
    
    /// Deletes all saved contacts.
    func deleteAll() throws
    
}

extension DataStore {
    
    func prepopulate() throws {
        try deleteAll()
        try Contact.random().forEach { try save(contact: $0) }
    }
    
}
