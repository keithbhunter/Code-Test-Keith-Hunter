//
//  FlatFileDataStore.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/21/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

class FlatFileDataStore: DataStore {
    
    /// Singleton instance of flat file data store to use in the app.
    static let shared = FlatFileDataStore()
    
    /// The directory where the flat file is stored.
    private let directory: URL
    
    private var storeURL: URL {
        return directory.appendingPathComponent("contacts.json", isDirectory: false)
    }
    
    
    // MARK: - Init
    
    /// Creates a data store which keeps its data in the directory specified.
    /// Defaults to the documents directory.
    init(directory: URL? = nil) {
        if let dir = directory {
            self.directory = dir
        } else {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            assert(urls.count == 1)
            self.directory = urls.first!
        }
    }
    
    
    // MARK: - DataStore
    
    func fetchAllContacts() -> Set<Contact> {
        return read()
    }
    
    func save(contact: Contact) throws {
        var contacts = read()
        contacts.update(with: contact)
        try write(contacts)
    }
    
    func delete(contact: Contact) throws {
        var contacts = read()
        contacts.remove(contact)
        try write(contacts)
    }
    
    func deleteAll() throws {
        try write([])
    }
    
    
    // MARK: - File I/O
    
    private func write(_ contacts: Set<Contact>) throws {
        let data = try JSONEncoder().encode(contacts)
        try data.write(to: storeURL, options: .completeFileProtection)
    }
    
    private func read() -> Set<Contact> {
        do {
            let data = try Data(contentsOf: storeURL)
            return try JSONDecoder().decode(Set<Contact>.self, from: data)
        } catch {
            print(error)
            return []
        }
    }
    
}
