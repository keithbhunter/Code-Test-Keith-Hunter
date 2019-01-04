//
//  ContactPhotoStore.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 1/4/19.
//  Copyright © 2019 Keith Hunter. All rights reserved.
//

import UIKit

struct ContactPhotoStore {
    
    static func save(photo: UIImage, for contact: Contact) {
        do {
            try photo.pngData()?.write(to: fileURL(for: contact))
        } catch {
            print(error)
        }
    }
    
    static func photo(for contact: Contact) -> UIImage? {
        guard let data = try? Data(contentsOf: fileURL(for: contact)) else { return nil }
        return UIImage(data: data, scale: UIScreen.main.scale)
    }
    
    private static func fileURL(for contact: Contact) -> URL {
        var fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL.appendPathComponent("Pictures")
        
        if !FileManager.default.fileExists(atPath: fileURL.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: [FileAttributeKey.protectionKey : FileProtectionType.complete])
            } catch {
                print(error)
            }
        }
        
        fileURL.appendPathComponent(contact.id)
        fileURL.appendPathExtension("png")
        return fileURL
    }
    
}
