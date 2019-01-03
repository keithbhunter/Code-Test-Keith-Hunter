//
//  DateOfBirthFormatterTests.swift
//  Code Test Keith HunterTests
//
//  Created by Keith Hunter on 1/2/19.
//  Copyright © 2019 Keith Hunter. All rights reserved.
//

import XCTest
@testable import Code_Test_Keith_Hunter

class DateOfBirthFormatterTests: XCTestCase {

    func testDateOfBirthdayFormatting() {
        XCTAssertNil(DateOfBirthFormatter().format(""))
        XCTAssertEqual(DateOfBirthFormatter().format("1"), "1")
        XCTAssertEqual(DateOfBirthFormatter().format("12"), "12")
        XCTAssertEqual(DateOfBirthFormatter().format("123"), "12/3")
        XCTAssertEqual(DateOfBirthFormatter().format("1234"), "12/34")
        XCTAssertEqual(DateOfBirthFormatter().format("12345"), "12/34/5")
        XCTAssertEqual(DateOfBirthFormatter().format("123456"), "12/34/56")
        XCTAssertEqual(DateOfBirthFormatter().format("1234567"), "12/34/567")
        XCTAssertEqual(DateOfBirthFormatter().format("12345678"), "12/34/5678")
        XCTAssertEqual(DateOfBirthFormatter().format("123456789"), "12/34/5678")
    }

}
