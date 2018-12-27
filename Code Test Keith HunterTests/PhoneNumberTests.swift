//
//  PhoneNumberTests.swift
//  Code Test Keith HunterTests
//
//  Created by Keith Hunter on 12/27/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import Code_Test_Keith_Hunter

class PhoneNumberTests: XCTestCase {
    
    func testPhoneNumberConstruction() {
        let number = try! PhoneNumber("1234567890")
        XCTAssertEqual(number.areaCode, "123")
        XCTAssertEqual(number.subscriberPrefix, "456")
        XCTAssertEqual(number.subscriberNumber, "7890")
    }
    
    func testFormattedPhoneNumberConstruction() {
        let number = try! PhoneNumber("(123) 456-7890")
        XCTAssertEqual(number.areaCode, "123")
        XCTAssertEqual(number.subscriberPrefix, "456")
        XCTAssertEqual(number.subscriberNumber, "7890")
        
        let number2 = try! PhoneNumber("123-456-7890")
        XCTAssertEqual(number2.areaCode, "123")
        XCTAssertEqual(number2.subscriberPrefix, "456")
        XCTAssertEqual(number2.subscriberNumber, "7890")
    }
    
    func testPhoneNumberWithLettersThrowsError() {
        XCTAssertThrowsError(try PhoneNumber("abc1234567"))
    }
    
    func testPhoneNumberFormat() {
        let number = try! PhoneNumber("1234567890")
        XCTAssertEqual(number.formattedString, "(123) 456-7890")
    }
    
}
