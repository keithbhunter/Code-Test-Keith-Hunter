//
//  ContactViewModelTests.swift
//  Code Test Keith HunterTests
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import CoreLocation
import XCTest
@testable import Code_Test_Keith_Hunter

class ContactViewModelTests: XCTestCase, ContactViewModelDelegate {

    private lazy var birthday: Date = {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, year: 1989, month: 11, day: 20)
        return calendar.date(from: components)!
    }()
    
    private lazy var contact = Contact(id: 0, firstName: "Taylor", lastName: "Swift", dateOfBirth: birthday, addresses: ["1 Infinite Loop, Cupertino, CA 95014"], phoneNumbers: [try! PhoneNumber("1112223333")], emailAddresses: ["taylor@swift.com"])
    private lazy var viewModel = ContactViewModel(contact: contact)
    
    private var addressCoordinate: CLLocationCoordinate2D?
    private var expectation: XCTestExpectation?
    
    
    // MARK: - Setup
    
    override func tearDown() {
        expectation = nil
        super.tearDown()
    }
    
    
    // MARK: - Tests
    
    func testConfiguringHeaderCell() {
        let cell = ContactHeaderCell()
        viewModel.configure(headerCell: cell)
        
        XCTAssertEqual(cell.firstNameLabel.text, "Taylor")
        XCTAssertEqual(cell.lastNameLabel.text, "Swift")
        XCTAssertEqual(cell.dateOfBirthLabel.text, "Nov 20, 1989")
    }
    
    func testNumberOfSections() {
        XCTAssertEqual(viewModel.numberOfSections, 4, "Header, phone numbers, emails, and addresses")
    }
    
    func testNumberOfRowsInSection() {
        XCTAssertEqual(viewModel.numberOfRows(inSection: 0), 1, "Just the header row")
        XCTAssertEqual(viewModel.numberOfRows(inSection: 1), contact.phoneNumbers.count)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 2), contact.emailAddresses.count)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 3), contact.addresses.count)
    }
    
    func testTitleForSection() {
        XCTAssertEqual(viewModel.title(forSection: 0), "")
        XCTAssertNotNil(viewModel.title(forSection: 1))
        XCTAssertNotNil(viewModel.title(forSection: 2))
        XCTAssertNotNil(viewModel.title(forSection: 3))
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
    
    func testFindsCoordinateOfAddress() {
        expectation = expectation(description: "testFindsCoordinateOfAddress")
        let viewModel = ContactViewModel(contact: contact)
        viewModel.delegate = self
        viewModel.getCoordinateOfAddress()
        
        waitForExpectations(timeout: 3) { error in
            if let err = error {
                XCTFail("\(err)")
            } else {
                let coordinate = CLLocationCoordinate2D(latitude: 37.33, longitude: -122.03)
                XCTAssertEqual(self.addressCoordinate!.latitude, coordinate.latitude, accuracy: 0.01)
                XCTAssertEqual(self.addressCoordinate!.longitude, coordinate.longitude, accuracy: 0.01)
                XCTAssertEqual(viewModel.numberOfRows(inSection: 3), self.contact.addresses.count + 1, "+1 for the map cell")
            }
        }
    }
    
    
    // MARK: - ContactViewModelDelegate
    
    func viewModel(_ viewModel: ContactViewModel, foundAddressCoordinate coordinate: CLLocationCoordinate2D) {
        addressCoordinate = coordinate
        expectation?.fulfill()
    }
    
    func viewModelFailedToFindAddressCoordinate(_ viewModel: ContactViewModel) {
        expectation?.fulfill()
    }

}
