//
//  PhoneNumberFormatterTests.swift
//  Code Test Keith HunterTests
//
//  Created by Keith Hunter on 1/1/19.
//  Copyright © 2019 Keith Hunter. All rights reserved.
//

import XCTest
@testable import Code_Test_Keith_Hunter

class NumberInputFormatterTests: XCTestCase {

    func testPhoneNumberFormatting() {
        XCTAssertNil(PhoneNumberFormatter().format(""))
        XCTAssertEqual(PhoneNumberFormatter().format("1"), "(1")
        XCTAssertEqual(PhoneNumberFormatter().format("12"), "(12")
        XCTAssertEqual(PhoneNumberFormatter().format("123"), "(123")
        XCTAssertEqual(PhoneNumberFormatter().format("1234"), "(123) 4")
        XCTAssertEqual(PhoneNumberFormatter().format("12345"), "(123) 45")
        XCTAssertEqual(PhoneNumberFormatter().format("123456"), "(123) 456")
        XCTAssertEqual(PhoneNumberFormatter().format("1234567"), "(123) 456-7")
        XCTAssertEqual(PhoneNumberFormatter().format("12345678"), "(123) 456-78")
        XCTAssertEqual(PhoneNumberFormatter().format("123456789"), "(123) 456-789")
        XCTAssertEqual(PhoneNumberFormatter().format("1234567890"), "(123) 456-7890")
        XCTAssertEqual(PhoneNumberFormatter().format("12345678901"), "(123) 456-7890")
    }
    
    func testRemovingFormatting() {
        XCTAssertEqual(PhoneNumberFormatter().removeFormatting(from: "(123) 456-7890"), "1234567890")
    }

}
