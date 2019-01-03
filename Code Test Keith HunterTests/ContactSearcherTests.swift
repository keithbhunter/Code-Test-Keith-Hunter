//
//  ContactSearcherTests.swift
//  Code Test Keith HunterTests
//
//  Created by Keith Hunter on 12/24/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import Code_Test_Keith_Hunter

class ContactSearcherTests: XCTestCase {
    
    private let one = Contact(id: 0, firstName: "John", lastName: "Johnson", dateOfBirth: Date(), addresses: [], phoneNumbers: ["1111111111"], emailAddresses: ["e@mail.com"])
    private let two = Contact(id: 1, firstName: "Jack", lastName: "Jackson", dateOfBirth: Date(), addresses: [], phoneNumbers: ["1111111111"], emailAddresses: ["e@mail.com"])
    private let three = Contact(id: 2, firstName: "Boaty", lastName: "McBoatface", dateOfBirth: Date(), addresses: [], phoneNumbers: ["1111111111"], emailAddresses: ["e@mail.com"])
    private(set) lazy var contacts = [one, two, three]
    
    
    // MARK: - Tests

    func testSearchForFirstName() {
        let results = ContactSearcher.search(contacts: contacts, for: "John")
        XCTAssertEqual(results, [one])
    }
    
    func testSearchForLastName() {
        let results = ContactSearcher.search(contacts: contacts, for: "Johnson")
        XCTAssertEqual(results, [one])
    }
    
    func testSearchForPartialFirstName() {
        let results = ContactSearcher.search(contacts: contacts, for: "J")
        XCTAssertEqual(results, [one, two])
    }
    
    func testSearchForPartialLastName() {
        let results = ContactSearcher.search(contacts: contacts, for: "s")
        XCTAssertEqual(results, [one, two])
    }
    
    func testSearchForCaseInsensitiveNames() {
        let results = ContactSearcher.search(contacts: contacts, for: "john")
        XCTAssertEqual(results, [one])
    }
    
    func testSearchForDiacriticInsensitiveNames() {
        let results = ContactSearcher.search(contacts: contacts, for: "Johñ")
        XCTAssertEqual(results, [one])
    }
    
    func testEmptySearchReturnsAllContacts() {
        let results = ContactSearcher.search(contacts: contacts, for: "")
        XCTAssertEqual(results, [one, two, three])
    }

}
