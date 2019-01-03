//
//  ContactViewController.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

final class ContactViewController: UIViewController, UITableViewDelegate {
    
    private enum Section: Int {
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
    
    
    // MARK: - Properties
    
    private let store: DataStore
    private var contact: Contact
    private var isEditingContact = false
    private var addressCoordinate: CLLocationCoordinate2D?
    
    private var indexPathOfMap: IndexPath {
        return IndexPath(row: contact.addresses.count, section: Section.address.rawValue)
    }
    
    
    // MARK: Init
    
    init(store: DataStore, contact: Contact) {
        self.store = store
        self.contact = contact
        
        super.init(nibName: nil, bundle: nil)
        getCoordinateOfAddress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditState))
    }
    
    
    // MARK: - Setup
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraints(equalTo: view))
    }
    
    private func getCoordinateOfAddress() {
        DispatchQueue.global().async {
            CLGeocoder().geocodeAddressString(self.contact.addresses[0]) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                
                if let coordinate = placemarks?.first?.location?.coordinate {
                    self.addressCoordinate = coordinate
                    DispatchQueue.main.async {
                        self.tableView.reloadSections([Section.address.rawValue], with: .none)
                    }
                } else {
                    print("Unable to find coordinate")
                }
            }
        }
    }
    
    
    // MARK - Actions
    
    @objc private func toggleEditState() {
        isEditingContact = !isEditingContact
        
        if isEditingContact {
            title = NSLocalizedString("Editing", comment: "")
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleEditState))
            tableView.reloadData()
        } else {
            title = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditState))
            saveOrShowError()
        }
    }
    
    private func saveOrShowError() {
        do {
            try store.save(contact: contact)
            tableView.reloadData()
        } catch {
            let unableToSave = NSLocalizedString("Unable to Save", comment: "")
            let ok = NSLocalizedString("OK", comment: "")
            let alert = UIAlertController(title: unableToSave, message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ok, style: .cancel))
            present(alert, animated: true)
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !isEditingContact else { return UITableView.automaticDimension }
        return indexPath == indexPathOfMap ? 250 : UITableView.automaticDimension
    }
    
    
    // MARK: - Views
    
    fileprivate lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.contentInsetAdjustmentBehavior = .never
        table.contentInset = UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 0)
        
        table.register(ContactHeaderCell.self, forCellReuseIdentifier: String(describing: ContactHeaderCell.self))
        table.register(TextFieldCell.self, forCellReuseIdentifier: String(describing: TextFieldCell.self))
        table.register(MapCell.self, forCellReuseIdentifier: String(describing: MapCell.self))
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
}

extension ContactViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sect = Section(rawValue: section) else { return 0 }
        
        switch sect {
        case .header: return 1
        case .phoneNumbers:
            return isEditingContact ? contact.phoneNumbers.count + 1 : contact.phoneNumbers.count
        case .emailAddress:
            return isEditingContact ? contact.emailAddresses.count + 1 : contact.emailAddresses.count
        case .address:
            let hasExtraRow = isEditingContact || addressCoordinate != nil
            return hasExtraRow ? contact.addresses.count + 1 : contact.addresses.count
        default:
            assertionFailure("Unexpected section \(section)")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section: \(indexPath.section)")
        }
        
        switch section {
        case .header: return headerCell(at: indexPath)
        case .phoneNumbers: return phoneNumberCell(at: indexPath)
        case .emailAddress: return emailAddressCell(at: indexPath)
        case .address:
            if indexPath == indexPathOfMap && !isEditingContact {
                return mapCell(at: indexPath)
            } else {
                return addressCell(at: indexPath)
            }
            
        default: fatalError("Unexpected section: \(indexPath.section)")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title ?? ""
    }
    
}

extension ContactViewController {
    
    private func headerCell(at indexPath: IndexPath) -> ContactHeaderCell {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactHeaderCell.self), for: indexPath) as! ContactHeaderCell
        headerCell.firstNameTextField.text = contact.firstName
        headerCell.lastNameTextField.text = contact.lastName
        headerCell.dateOfBirthTextField.text = contact.dateOfBirth
        headerCell.delegate = self
        headerCell.isUserInteractionEnabled = isEditingContact
        headerCell.selectionStyle = .none
        return headerCell
    }
    
    private func phoneNumberCell(at indexPath: IndexPath) -> TextFieldCell {
        precondition(indexPath.section == 1)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCell.self), for: indexPath) as! TextFieldCell
        
        if indexPath.row < contact.phoneNumbers.count {
            cell.textField.text = PhoneNumberFormatter().format(contact.phoneNumbers[indexPath.row])
        } else {
            cell.textField.placeholder = NSLocalizedString("New Phone Number", comment: "")
        }
        
        cell.delegate = self
        cell.isUserInteractionEnabled = isEditingContact
        cell.selectionStyle = .none
        return cell
    }
    
    private func emailAddressCell(at indexPath: IndexPath) -> TextFieldCell {
        precondition(indexPath.section == 2)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCell.self), for: indexPath) as! TextFieldCell
        
        if indexPath.row < contact.phoneNumbers.count {
            cell.textField.text = contact.emailAddresses[indexPath.row]
        } else {
            cell.textField.placeholder = NSLocalizedString("New Email Address", comment: "")
        }
        
        cell.delegate = self
        cell.isUserInteractionEnabled = isEditingContact
        cell.selectionStyle = .none
        return cell
    }
    
    private func addressCell(at indexPath: IndexPath) -> TextFieldCell {
        precondition(indexPath.section == Section.address.rawValue)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCell.self), for: indexPath) as! TextFieldCell
        
        if indexPath.row < contact.phoneNumbers.count {
            cell.textField.text = contact.addresses[indexPath.row]
        } else {
            cell.textField.placeholder = NSLocalizedString("New Address", comment: "")
        }
        
        cell.delegate = self
        cell.isUserInteractionEnabled = isEditingContact
        cell.selectionStyle = .none
        return cell
    }
    
    private func mapCell(at indexPath: IndexPath) -> MapCell {
        let mapCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MapCell.self), for: indexPath) as! MapCell
        guard let coord = addressCoordinate else { return mapCell }
        
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        mapCell.map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        mapCell.map.addAnnotation(annotation)
        return mapCell
    }
    
}

extension ContactViewController: TextFieldCellDelegate {
    
    func textFieldCellTextDidChange(_ cell: TextFieldCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        switch indexPath.section {
        case Section.phoneNumbers.rawValue:
            cell.textField.text = PhoneNumberFormatter().format(cell.textField.text ?? "")
            
            if indexPath.row < contact.phoneNumbers.count {
                contact.phoneNumbers[indexPath.row] = PhoneNumberFormatter().removeFormatting(from: cell.textField.text ?? "")
            }
            
        case Section.emailAddress.rawValue:
            if indexPath.row < contact.emailAddresses.count {
                contact.emailAddresses[indexPath.row] = cell.textField.text ?? ""
            }
            
        case Section.address.rawValue:
            if indexPath.row < contact.addresses.count {
                contact.addresses[indexPath.row] = cell.textField.text ?? ""
            }
            
        default: return
        }
    }
    
    func textFieldCellShouldReturn(_ cell: TextFieldCell) -> Bool {
        guard let indexPath = tableView.indexPath(for: cell) else { return false }
        
        let nextRow = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        let nextSection = IndexPath(row: 0, section: indexPath.section + 1)
        
        if let cell = tableView.cellForRow(at: nextRow) as? TextFieldCell {
            cell.textField.becomeFirstResponder()
        } else if let cell = tableView.cellForRow(at: nextSection) as? TextFieldCell {
            cell.textField.becomeFirstResponder()
        } else {
            cell.textField.resignFirstResponder()
        }
        
        return false
    }
    
}

extension ContactViewController: ContactHeaderCellDelegate {
    
    func contactHeaderCellTextDidChange(_ cell: ContactHeaderCell) {
        contact.firstName = cell.firstNameTextField.text ?? ""
        contact.lastName = cell.lastNameTextField.text ?? ""
        
        let dateOfBirth = DateOfBirthFormatter().format(cell.dateOfBirthTextField.text ?? "") ?? ""
        contact.dateOfBirth = dateOfBirth
        cell.dateOfBirthTextField.text = dateOfBirth
    }
    
    func contactHeaderCell(_ cell: ContactHeaderCell, textFieldShouldReturn textField: UITextField) -> Bool {
        if textField == cell.firstNameTextField {
            cell.lastNameTextField.becomeFirstResponder()
        } else if textField == cell.lastNameTextField {
            cell.dateOfBirthTextField.becomeFirstResponder()
        } else if textField == cell.dateOfBirthTextField, let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.header.rawValue + 1)) as? TextFieldCell {
            cell.textField.becomeFirstResponder()
        }
        
        return false
    }
    
}
