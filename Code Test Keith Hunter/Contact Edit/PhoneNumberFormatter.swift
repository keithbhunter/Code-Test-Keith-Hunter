//
//  PhoneNumberFormatter.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 1/1/19.
//  Copyright © 2019 Keith Hunter. All rights reserved.
//

import UIKit

// See unit tests for expected behavior.
class PhoneNumberFormatter: Formatter {
    
    func format(_ number: String) -> String? {
        return string(for: number)
    }
    
    func removeFormatting(from formattedNumber: String) -> String {
        let components = formattedNumber.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return components.joined()
    }
    
    
    // MARK: Formatter overrides
    
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? String else { return nil }
        
        let components = number.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let unformatted = components.joined()
        guard !unformatted.isEmpty else { return nil }
        
        var formatted = "("
        
        for i in 0 ..< unformatted.count {
            let index = unformatted.index(unformatted.startIndex, offsetBy: i)
            let isLastIndex = index == unformatted.endIndex
            let nextChar = unformatted[index]
            
            if formatted.count == 4 && !isLastIndex {
                formatted.append(")")
                formatted.append(" ")
            }
            
            if formatted.count == 9 && !isLastIndex {
                formatted.append("-")
            }
            
            if formatted.count == 14 { break }
            formatted.append(nextChar)
        }
        
        return formatted
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let components = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        obj?.pointee = components.joined() as AnyObject
        return true
    }
    
}
