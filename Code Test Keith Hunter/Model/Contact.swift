//
//  Contact.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/21/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

struct Contact {
    
    /// A unique identifier, since different people can have
    /// the same name, birthday, etc.
    let id: Int
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var addresses: [String]
    var phoneNumbers: [PhoneNumber]
    var emailAddresses: [String]
    
}

extension Contact: Hashable {
    
    var hashValue: Int { return id.hashValue }
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}

extension Contact: Codable {}

extension Contact {
    
    private static let names = [
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
    
    private static let phoneNumbers = [
        "(850) 333-6985",
        "(426) 505-0844",
        "(345) 591-4456",
        "(346) 664-7859",
        "(398) 903-4304",
        "(617) 993-2730",
        "(820) 535-9122",
        "(634) 764-2762",
        "(331) 775-1836",
        "(289) 578-1163",
        "(476) 344-6610",
        "(947) 949-4788",
        "(396) 787-9083",
        "(260) 388-2160",
        "(779) 202-8884",
        "(218) 744-5724",
        "(454) 907-8699",
        "(281) 290-4059",
        "(971) 748-6874",
        "(732) 467-6983",
        "(571) 522-7711",
        "(968) 960-0600",
        "(886) 635-1474",
        "(411) 985-9037",
        "(261) 712-3066",
        "(624) 235-4829",
        "(879) 498-7217",
        "(250) 402-5716",
        "(345) 478-5811",
        "(830) 304-8641",
        "(756) 982-4876",
        "(895) 738-0617",
        "(940) 768-2372",
        "(356) 896-7109",
        "(846) 318-4154",
        "(641) 944-4601",
        "(205) 338-3330",
        "(273) 932-5299",
        "(880) 510-7034",
        "(284) 876-7478",
        "(958) 276-8992",
        "(520) 875-5604",
        "(513) 707-4762",
        "(394) 380-2290",
        "(284) 894-0315",
        "(307) 390-8548",
        "(631) 537-1038",
        "(260) 434-8896",
        "(310) 425-5110",
        "(595) 768-4838",
    ]
    
    private static let addresses = [
        "884 Pheasant Rd., Ft Mitchell, KY 41017",
        "9797 Jockey Hollow Ave., Hephzibah, GA 30815",
        "93 Logan St., Englewood, NJ 07631",
        "9062 Highland Ave., Unit 8, Fairport, NY 14450",
        "7833 4th St., Wellington, FL 33414",
        "76 East Wentworth St., West Fargo, ND 58078",
        "62 Pennington Lane, Chandler, AZ 85224",
        "659B Old Broad St., Cheshire, CT 06410",
        "7684 Sheffield Street, Oklahoma City, OK 73112",
        "828 Edgemont Court, Whitehall, PA 18052",
        "388 Bayberry Lane, Kings Mountain, NC 28086",
        "8905 St Louis Avenue, Dunedin, FL 34698",
        "822 Whitemarsh St., Littleton, CO 80123",
        "299 Pulaski Road, Sunnyside, NY 11104",
        "9509B Ridge Rd., King Of Prussia, PA 19406",
        "7313 George Ave., Taunton, MA 02780",
        "4 Pin Oak Ave., Rockville, MD 20850",
        "8 S. Winchester St., Martinsville, VA 24112",
        "702 S. Newbridge Rd., Elk Grove Village, IL 60007",
        "778 Glen Ridge Dr., Lincolnton, NC 28092",
        "6B North Cedarwood Ave., Clarkston, MI 48348",
        "720 Grant Ave., Rolling Meadows, IL 60008",
        "636 Valley Drive, Boynton Beach, FL 33435",
        "68 Stonybrook Rd., Mount Prospect, IL 60056",
        "8363 Princeton Drive, Lenoir, NC 28645",
        "7352 Newport Dr., Carlisle, PA 17013",
        "29 Manor Station Ave., Bethesda, MD 20814",
        "68 College Ave., Goshen, IN 46526",
        "834 Middle River Street, Lemont, IL 60439",
        "797 Bellevue Lane, Irwin, PA 15642",
        "5 Summer Ave., Sarasota, FL 34231",
        "7800 Boston St., Webster, NY 14580",
        "416 Ridgeview St., Salem, MA 01970",
        "379 Beach Street, East Stroudsburg, PA 18301",
        "856 Carriage St., Ontario, CA 91762",
        "7581 South Gulf St., Gainesville, VA 20155",
        "367 Woodside St., Apopka, FL 32703",
        "517 2nd St., Yorktown, VA 23693",
        "701 Orange Rd., Bridgewater, NJ 08807",
        "8845 Bank Street, Southfield, MI 48076",
        "62 Berkshire Street, Satellite Beach, FL 32937",
        "9140 Lookout St., Rockaway, NJ 07866",
        "14 Rockledge Ave., Gastonia, NC 28052",
        "41 Hickory Road, Suite 915, Capitol Heights, MD 20743",
        "8747 Cobblestone Ave., West Roxbury, MA 02132",
        "516 Buttonwood Rd., Kansas City, MO 64151",
        "21 Gulf St., Elizabeth City, NC 27909",
        "746 East Edgemont Rd., Blackwood, NJ 08012",
        "7 Hilldale Drive, Suitland, MD 20746",
        "9480 Briarwood Dr., West Chicago, IL 60185",
    ]
    
    static func random() -> [Contact] {
        return zip(names, zip(phoneNumbers, addresses)).map { name, numberAndAddress in
            let firstName = name.components(separatedBy: " ")[0]
            let lastName = name.components(separatedBy: " ")[1]
            let number = numberAndAddress.0
            let address = numberAndAddress.1
            
            return Contact(id: Int.random(in: 0 ... Int.max),
                           firstName: firstName,
                           lastName: lastName,
                           dateOfBirth: Date(timeIntervalSince1970: Double.random(in: 0 ... 1_000_000_000)),
                           addresses: [address],
                           phoneNumbers: [try! PhoneNumber(number)],
                           emailAddresses: ["\(firstName.lowercased()).\(lastName.lowercased())@email.com"])
        }
    }
    
}
