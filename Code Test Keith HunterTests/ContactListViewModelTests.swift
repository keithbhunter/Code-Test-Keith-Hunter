//
//  ContactListViewModelTests.swift
//  Code Test Keith HunterTests
//
//  Created by Keith Hunter on 12/24/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import Code_Test_Keith_Hunter

class ContactListViewModelTests: XCTestCase {
    
    private let contacts = [
        Contact(id: 0, firstName: "Almeta", lastName: "Zeledon", dateOfBirth: Date(), addresses: [], phoneNumbers: [], emailAddresses: []),
        Contact(id: 1, firstName: "Awilda", lastName: "Loya", dateOfBirth: Date(), addresses: [], phoneNumbers: [], emailAddresses: []),
        Contact(id: 2, firstName: "Britney", lastName: "Hoffer", dateOfBirth: Date(), addresses: [], phoneNumbers: [], emailAddresses: []),
        Contact(id: 3, firstName: "Coral", lastName: "Kleckner", dateOfBirth: Date(), addresses: [], phoneNumbers: [], emailAddresses: []),
        Contact(id: 4, firstName: "Celesta", lastName: "Wischmeier", dateOfBirth: Date(), addresses: [], phoneNumbers: [], emailAddresses: []),
        Contact(id: 5, firstName: "Carter", lastName: "Cella", dateOfBirth: Date(), addresses: [], phoneNumbers: [], emailAddresses: []),
        Contact(id: 6, firstName: "Delana", lastName: "Alberto", dateOfBirth: Date(), addresses: [], phoneNumbers: [], emailAddresses: []),
    ]
    
    private lazy var viewModel = ContactListViewModel(contacts: contacts)
    
    func testNumberOfSections() {
        XCTAssertEqual(viewModel.numberOfSections, 4)
    }
    
    func testNumberOfRows() {
        XCTAssertEqual(viewModel.numberOfRows(inSection: 0), 2)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 1), 1)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 2), 3)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 3), 1)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 4), 0)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 15), 0)
    }
    
    func testTitleForSection() {
        XCTAssertEqual(viewModel.title(forSection: 1), "B")
        XCTAssertEqual(viewModel.title(forSection: 15), "")
    }
    
    func testContactsForIndexPath() {
        let expected = Contact(id: 5, firstName: "Carter", lastName: "Cella", dateOfBirth: Date(), addresses: [], phoneNumbers: [], emailAddresses: [])
        let contact = viewModel.contact(at: IndexPath(row: 2, section: 2))
        XCTAssertEqual(expected, contact)
    }
    
    func testSectionIndexTitles() {
        let titles = viewModel.sectionIndexTitles
        let expected = ["A", "B", "C", "D"]
        XCTAssertEqual(expected, titles)
    }
    
}
