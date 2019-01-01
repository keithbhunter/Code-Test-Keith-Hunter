//
//  ContactViewModel.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

protocol ContactViewModelDelegate: class {
    
    func viewModel(_ viewModel: ContactViewModel, foundAddressCoordinate coordinate: CLLocationCoordinate2D)
    func viewModelFailedToFindAddressCoordinate(_ viewModel: ContactViewModel)
    
}

final class ContactViewModel {
    
    enum Section: Int {
        case header
        case phoneNumbers
        case emailAddress
        case address
        // NOT TO BE USED! This is just for counting the sections
        case total
        
        var title: String {
            switch self {
            case .phoneNumbers: return NSLocalizedString("Phone Numbers", comment: "")
            case .emailAddress: return NSLocalizedString("Emails", comment: "")
            case .address: return NSLocalizedString("Addresses", comment: "")
            default: return ""
            }
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let contact: Contact
    weak var delegate: ContactViewModelDelegate?
    
    var formattedBirthday: String { return ContactViewModel.dateFormatter.string(from: contact.dateOfBirth) }
    var numberOfSections: Int { return Section.total.rawValue }
    var addressCoordinate: CLLocationCoordinate2D?
    
    var indexPathOfMap: IndexPath {
        return IndexPath(row: contact.addresses.count, section: Section.address.rawValue)
    }
    
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    func getCoordinateOfAddress() {
        DispatchQueue.global().async {
            CLGeocoder().geocodeAddressString(self.contact.addresses[0]) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                
                if let coordinate = placemarks?.first?.location?.coordinate {
                    self.addressCoordinate = coordinate
                    self.delegate?.viewModel(self, foundAddressCoordinate: coordinate)
                } else {
                    self.delegate?.viewModelFailedToFindAddressCoordinate(self)
                }
            }
        }
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let sect = Section(rawValue: section) else { return 0 }
        
        switch sect {
        case .header: return 1
        case .phoneNumbers: return contact.phoneNumbers.count
        case .emailAddress: return contact.emailAddresses.count
        case .address:
            return addressCoordinate == nil ? contact.addresses.count : contact.addresses.count + 1
        default:
            assertionFailure("Unexpected section \(section)")
            return 0
        }
    }
    
    func title(forSection section: Int) -> String {
        return Section(rawValue: section)?.title ?? ""
    }
    
}

extension ContactViewModel {
    
    func configure(headerCell: ContactHeaderCell) {
        headerCell.firstNameLabel.text = contact.firstName
        headerCell.lastNameLabel.text = contact.lastName
        headerCell.dateOfBirthLabel.text = formattedBirthday
    }
    
    func configure(phoneNumberCell cell: UITableViewCell, at indexPath: IndexPath) {
        guard indexPath.row < contact.phoneNumbers.count else { return }
        precondition(indexPath.section == 1)
        cell.textLabel?.text = contact.phoneNumbers[indexPath.row].formattedString
    }
    
    func configure(emailAddressCell cell: UITableViewCell, at indexPath: IndexPath) {
        guard indexPath.row < contact.emailAddresses.count else { return }
        precondition(indexPath.section == 2)
        cell.textLabel?.text = contact.emailAddresses[indexPath.row]
    }
    
    func configure(addressCell cell: UITableViewCell, at indexPath: IndexPath) {
        guard indexPath.row < contact.addresses.count else { return }
        precondition(indexPath.section == Section.address.rawValue)
        cell.textLabel?.text = contact.addresses[indexPath.row]
    }
    
    func configure(mapCell: MapCell) {
        guard let coord = addressCoordinate else { return }
        
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        mapCell.map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        mapCell.map.addAnnotation(annotation)
    }
    
}
