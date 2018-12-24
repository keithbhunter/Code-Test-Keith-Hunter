//
//  DataStore.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/21/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

/// A protocol representing the functions needed to keep a list
/// of contacts for the app. This could be implemented using
/// CoreData, a flat file, NSKeyedArchiver, network API or others.
protocol DataStore {
    
    /// Find and return all saved contacts.
    func fetchAllContacts() -> Set<Contact>
    
    /// Saves `contact` as a new contact. If the contact already
    /// exists, the contact will be updated with the new info.
    func save(contact: Contact) throws

    /// Removes `contact` from the data store.
    func delete(contact: Contact) throws
    
    /// Deletes all saved contacts.
    func deleteAll() throws
    
}

extension DataStore {
    
    func prepopulate() throws {
        let names = [
            "Weston Surber",
            "Sabra Howlett",
            "Ellan Delreal",
            "Letisha Soderman",
            "Youlanda Fischbach",
            "Katina Overstreet",
            "Karleen Gressett",
            "Jennine Paquet",
            "Britney Hoffer",
            "Delmar Trickett",
            "Fawn Uhlig",
            "Kenisha Kennell",
            "Pearle Lynde",
            "Kati Bergen",
            "Nellie Behringer",
            "Earle Presswood",
            "Coral Kleckner",
            "Luella Parras",
            "Valeria Meraz",
            "Lasandra Tarkington",
            "Rosamaria Cali",
            "Celesta Wischmeier",
            "Hayley Weymouth",
            "Liana Kral",
            "Lorenza Winfrey",
            "Carter Cella",
            "Hien Roberge",
            "Shanelle Nolen",
            "Modesta Boehman",
            "Micheline Jager",
            "Lulu Lamagna",
            "Delana Alberto",
            "Marlena Demoura",
            "Sanora Tippin",
            "Maria Orzechowski",
            "Catherine Reavis",
            "Cyndy Taggart",
            "Awilda Loya",
            "Denita Farrah",
            "Edelmira Sellars",
            "Mireille Hermanson",
            "Micki Bumpus",
            "Drew Balliet",
            "Claris Hettinger",
            "Dulce Artis",
            "Eunice Angel",
            "Joselyn Kieser",
            "Eleanore Sharma",
            "Almeta Zeledon",
            "Marjory Gummer",
        ]
        
        let contacts = names.map {
            Contact(id: Int.random(in: 0 ... Int.max), firstName: $0.components(separatedBy: " ")[0], lastName: $0.components(separatedBy: " ")[1], dateOfBirth: Date(), addresses: [], phoneNumbers: ["1111111111"], emailAddresses: ["e@mail.com"])
        }
        
        try deleteAll()
        try contacts.forEach { try save(contact: $0) }
    }
    
}
