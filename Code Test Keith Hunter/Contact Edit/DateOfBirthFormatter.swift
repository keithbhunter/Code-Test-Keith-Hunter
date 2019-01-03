//
//  DateOfBirthFormatter.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 1/2/19.
//  Copyright © 2019 Keith Hunter. All rights reserved.
//

import Foundation

class DateOfBirthFormatter: Formatter {
    
    func format(_ dateString: String) -> String? {
        return string(for: dateString)
    }
    
    
    // MARK: Formatter overrides
    
    override func string(for obj: Any?) -> String? {
        guard let date = obj as? String else { return nil }
        
        let components = date.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let unformatted = components.joined()
        guard !unformatted.isEmpty else { return nil }
        
        var formatted = ""
        
        for i in 0 ..< unformatted.count {
            let index = unformatted.index(unformatted.startIndex, offsetBy: i)
            let isLastIndex = index == unformatted.endIndex
            let nextChar = unformatted[index]
            
            if (formatted.count == 2 || formatted.count == 5) && !isLastIndex {
                formatted.append("/")
            }
            
            if formatted.count == 10 { break }
            formatted.append(nextChar)
        }
        
        return formatted
    }
    
}
