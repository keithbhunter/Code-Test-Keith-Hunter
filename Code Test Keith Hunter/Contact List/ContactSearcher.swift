//
//  ContactSearcher.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/24/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

struct ContactSearcher {
    
    static func search<S: Sequence>(contacts: S, for query: String) -> [S.Element] where S.Element == Contact {
        guard !query.isEmpty else { return Array(contacts) }
        
        let foldingOptions: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        let revisedQuery = query.folding(options: foldingOptions, locale: nil)
        
        return contacts.filter {
            let first = $0.firstName.folding(options: foldingOptions, locale: nil)
            let last = $0.lastName.folding(options: foldingOptions, locale: nil)
            return first.contains(revisedQuery) || last.contains(revisedQuery)
        }
    }
    
}
