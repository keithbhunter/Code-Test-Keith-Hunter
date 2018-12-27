//
//  PhoneNumber.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/27/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

/// This phone number is specific to the US locale. This would need
/// a lot more work (broken up into several different objects)
/// in order to make this work globally.
struct PhoneNumber: CustomStringConvertible {
    
    enum ConstructionError: Error {
        case invalid
    }
    
    
    /// 3-digit area code.
    let areaCode: String
    
    /// 3-digit code that comes after the area code.
    let subscriberPrefix: String
    
    /// The last 4 digits of the phone number.
    let subscriberNumber: String
    
    // If more locales were needed for formatting, we would subclass `Formatter`
    // to handle that logic.
    var formattedString: String { return "(\(areaCode)) \(subscriberPrefix)-\(subscriberNumber)"}
    
    var description: String { return formattedString }
    
    
    // MARK: - Init
    
    init(_ number: String) throws {
        // Strip everything that isn't a number.
        let components = number.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let unformatted = components.joined()
        
        guard unformatted.count == 10 else { throw ConstructionError.invalid }
        areaCode = String(unformatted.prefix(3))
        subscriberNumber = String(unformatted.suffix(4))
        
        let subscriberPrefixRange = unformatted.index(unformatted.startIndex, offsetBy: 3) ..< unformatted.index(unformatted.startIndex, offsetBy: 6)
        subscriberPrefix = String(unformatted[subscriberPrefixRange])
    }
    
}

extension PhoneNumber: Hashable {
    
    var hashValue: Int { return (areaCode + subscriberPrefix + subscriberNumber).hashValue }
    
    static func ==(lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}

extension PhoneNumber: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(areaCode + subscriberPrefix + subscriberNumber)
    }
    
}
