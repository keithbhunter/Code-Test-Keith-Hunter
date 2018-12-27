//
//  ContactViewModelTests.swift
//  Code Test Keith HunterTests
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import Code_Test_Keith_Hunter

class ContactViewModelTests: XCTestCase {

    private lazy var birthday: Date = {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, year: 1989, month: 11, day: 20)
        return calendar.date(from: components)!
    }()
    
    private lazy var contact = Contact(id: 0, firstName: "Taylor", lastName: "Swift", dateOfBirth: birthday, addresses: ["123 Address Rd"], phoneNumbers: [try! PhoneNumber("1112223333")], emailAddresses: ["taylor@swift.com"])
    private lazy var viewModel = ContactViewModel(contact: contact)
    
    func testConfiguringHeaderCell() {
        let cell = ContactHeaderCell()
        viewModel.configure(headerCell: cell)
        
        XCTAssertEqual(cell.firstNameLabel.text, "Taylor")
        XCTAssertEqual(cell.lastNameLabel.text, "Swift")
        XCTAssertEqual(cell.dateOfBirthLabel.text, "Nov 20, 1989")
    }
    
    func testNumberOfSections() {
        XCTAssertEqual(viewModel.numberOfSections, 3, "Header, phone numbers, and emails")
    }
    
    func testNumberOfRowsInSection() {
        XCTAssertEqual(viewModel.numberOfRows(inSection: 0), 1, "Just the header row")
        XCTAssertEqual(viewModel.numberOfRows(inSection: 1), contact.phoneNumbers.count)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 2), contact.emailAddresses.count)
    }
    
    func testTitleForSection() {
        XCTAssertEqual(viewModel.title(forSection: 0), "")
        XCTAssertNotNil(viewModel.title(forSection: 1))
        XCTAssertNotNil(viewModel.title(forSection: 2))
    }
    
    func testConfigurePhoneNumberCell() {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuse")
        viewModel.configure(phoneNumberCell: cell, at: IndexPath(row: 0, section: 1))
        XCTAssertEqual(cell.textLabel?.text, "(111) 222-3333")
    }
    
    func testConfigureEmailAddressCell() {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuse")
        viewModel.configure(emailAddressCell: cell, at: IndexPath(row: 0, section: 2))
        XCTAssertEqual(cell.textLabel?.text, "taylor@swift.com")
    }

}
