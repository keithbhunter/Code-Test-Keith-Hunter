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
    
    private lazy var contact = Contact(id: 0, firstName: "Taylor", lastName: "Swift", dateOfBirth: birthday, addresses: ["123 Address Rd"], phoneNumbers: ["1112223333"], emailAddresses: ["taylor@swift.com"])
    private lazy var viewModel = ContactViewModel(contact: contact)
    
    func testConfiguringHeaderCell() {
        let cell = ContactHeaderCell()
        viewModel.configure(headerCell: cell)
        
        XCTAssertEqual(cell.firstNameLabel.text, "Taylor")
        XCTAssertEqual(cell.lastNameLabel.text, "Swift")
        XCTAssertEqual(cell.dateOfBirthLabel.text, "Nov 20, 1989")
    }

}
