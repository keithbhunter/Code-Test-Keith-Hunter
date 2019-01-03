//
//  DataStoreTests.swift
//  Code Test Keith HunterTests
//
//  Created by Keith Hunter on 12/21/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import Code_Test_Keith_Hunter

class DataStoreTests: XCTestCase {
    
    private var dataStore: FlatFileDataStore!
    
    let one = Contact(firstName: "John", lastName: "Johnson", dateOfBirth: "11/22/1970", addresses: [], phoneNumbers: ["1111111111"], emailAddresses: ["e@mail.com"])
    let two = Contact(firstName: "Jack", lastName: "Jackson", dateOfBirth: "11/22/1970", addresses: [], phoneNumbers: ["1111111111"], emailAddresses: ["e@mail.com"])
    let three = Contact(firstName: "Boaty", lastName: "McBoatface", dateOfBirth: "11/22/1970", addresses: [], phoneNumbers: ["1111111111"], emailAddresses: ["e@mail.com"])
    
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        do {
            let dir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            dataStore = FlatFileDataStore(directory: dir)
            try dataStore.save(contact: one)
            try dataStore.save(contact: two)
            try dataStore.save(contact: three)
        } catch {
            fatalError("\(error)")
        }
    }
    
    override func tearDown() {
        try! dataStore.deleteAll()
        
        super.tearDown()
    }
    
    
    // MARK: - Tests
    
    func testFetchAllContacts() {
        let contacts = dataStore.fetchAllContacts()
        XCTAssertEqual(contacts, Set([one, two, three]))
    }
    
    func testSaveContact() {
        do {
            let contact = Contact(firstName: "James", lastName: "Jamison", dateOfBirth: "11/22/1970", addresses: [], phoneNumbers: ["4444444444"], emailAddresses: ["e@mail.com"])
            
            try dataStore.save(contact: contact)
            let contacts = dataStore.fetchAllContacts()
            let expected = Set([one, two, three, contact])
            
            XCTAssertEqual(contacts, expected)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateContact() {
        do {
            let contacts = dataStore.fetchAllContacts()
            XCTAssertFalse(contacts.contains { $0.firstName == "Keith" })
            
            var copy = one
            copy.firstName = "Keith"
            try dataStore.save(contact: copy)
            
            let updatedContacts = dataStore.fetchAllContacts()
            XCTAssertTrue(updatedContacts.contains { $0.firstName == "Keith" })
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteContact() {
        do {
            try dataStore.delete(contact: one)
            let contacts = dataStore.fetchAllContacts()
            let expected = Set([two, three])
            XCTAssertEqual(contacts, expected)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testTwoContactsCanHaveSimilarInfo() {
        do {
            // It is feasible that two people could have the same name
            // and birthday; although rare. We need to account for that.
            let similar = Contact(firstName: one.firstName, lastName: one.lastName, dateOfBirth: one.dateOfBirth, addresses: one.addresses, phoneNumbers: one.phoneNumbers, emailAddresses: one.emailAddresses)
            try dataStore.save(contact: similar)
            
            let contacts = dataStore.fetchAllContacts()
            let expected = Set([one, two, three, similar])
            XCTAssertEqual(contacts, expected)
        } catch {
            XCTFail("\(error)")
        }
    }

}
