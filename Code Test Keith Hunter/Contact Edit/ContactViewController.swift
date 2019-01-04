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

struct ContactValidationError: LocalizedError {
    
    static let addressCount = ContactValidationError(description: NSLocalizedString("You must enter one or more addresses.", comment: ""))
    static let noName = ContactValidationError(description: NSLocalizedString("You must enter at least a first or last name.", comment: ""))
    
    var errorDescription: String? { return description }
    private let description: String
    
    init(description: String) {
        self.description = description
    }
    
}

final class ContactViewController: UIViewController {
    
    private enum Section: Int {
        case header
        case phoneNumbers
        case emailAddress
        case address
        case delete
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
    private var editedContact: Contact
    private let isAddingNewContact: Bool
    private var isEditingContact = false
    private var addressCoordinate: CLLocationCoordinate2D?
    private var indexPathOfSelectedAddress = IndexPath(row: 0, section: Section.address.rawValue)
    
    private var indexPathOfMap: IndexPath {
        return IndexPath(row: editedContact.addresses.count, section: Section.address.rawValue)
    }
    
    
    // MARK: Init
    
    init(store: DataStore, contact: Contact?) {
        self.store = store
        self.contact = contact ?? Contact()
        self.editedContact = self.contact
        isAddingNewContact = contact == nil
        isEditingContact = isAddingNewContact

        super.init(nibName: nil, bundle: nil)
        
        if self.contact.addresses.count > 0 {
            getCoordinate(of: self.contact.addresses[0])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        if isAddingNewContact {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditState))
        }
    }
    
    func showError(_ error: Error, withTitle title: String) {
        let ok = NSLocalizedString("OK", comment: "")
        let alert = UIAlertController(title: title, message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ok, style: .cancel))
        present(alert, animated: true)
    }
    
    
    // MARK: - Setup
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraints(equalTo: view))
    }
    
    private func getCoordinate(of address: String) {
        DispatchQueue.global().async {
            CLGeocoder().geocodeAddressString(address) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                
                if let coordinate = placemarks?.first?.location?.coordinate {
                    self.addressCoordinate = coordinate
                    DispatchQueue.main.async {
                        self.tableView.reloadSections([Section.address.rawValue], with: .automatic)
                    }
                } else {
                    print("Unable to find coordinate")
                }
            }
        }
    }
    
    
    // MARK - Actions
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
    @objc private func done() {
        do {
            try validateAndSave(editedContact)
            dismiss(animated: true)
        } catch {
            showError(error, withTitle: NSLocalizedString("Unable to Save", comment: ""))
        }
    }
    
    @objc private func cancelEditing() {
        toggleEditState()
        editedContact = contact
        tableView.reloadData()
    }
    
    @objc private func doneEditing() {
        toggleEditState()
        saveOrShowError()
    }
    
    @objc private func toggleEditState() {
        guard !isAddingNewContact else { return }
        isEditingContact = !isEditingContact
        
        if isEditingContact {
            title = NSLocalizedString("Editing", comment: "")
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditing))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
            tableView.reloadData()
        } else {
            title = nil
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditState))
        }
    }
    
    private func saveOrShowError() {
        do {
            if contact.addresses[indexPathOfSelectedAddress.row] != editedContact.addresses[indexPathOfSelectedAddress.row] {
                getCoordinate(of: editedContact.addresses[indexPathOfSelectedAddress.row])
            }
            
            try validateAndSave(editedContact)
            contact = editedContact
            tableView.reloadData()
        } catch {
            showError(error, withTitle: NSLocalizedString("Unable to Save", comment: ""))
        }
    }
    
    private func validateAndSave(_ contact: Contact) throws {
        if editedContact.firstName.isEmpty && editedContact.lastName.isEmpty {
            throw ContactValidationError.noName
        } else if editedContact.addresses.isEmpty {
            throw ContactValidationError.addressCount
        }
        
        try store.save(contact: contact)
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
        table.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
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
            return isEditingContact ? editedContact.phoneNumbers.count + 1 : editedContact.phoneNumbers.count
        case .emailAddress:
            return isEditingContact ? editedContact.emailAddresses.count + 1 : editedContact.emailAddresses.count
        case .address:
            let hasExtraRow = isEditingContact || addressCoordinate != nil
            return hasExtraRow ? editedContact.addresses.count + 1 : editedContact.addresses.count
        case .delete: return isAddingNewContact ? 0 : 1
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
        case .delete: return deleteCell(at: indexPath)
        default: fatalError("Unexpected section: \(indexPath.section)")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title ?? ""
    }
    
}

extension ContactViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !isEditingContact else { return UITableView.automaticDimension }
        return indexPath == indexPathOfMap ? 250 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.phoneNumbers.rawValue {
            if let url = URL(string: "tel://\(contact.phoneNumbers[indexPath.row])"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        if indexPath.section == Section.emailAddress.rawValue {
            if let url = URL(string: "mailto://\(contact.emailAddresses[indexPath.row])"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        if !isEditingContact && indexPath.section == Section.address.rawValue && indexPath != indexPathOfSelectedAddress && indexPath != indexPathOfMap {
            indexPathOfSelectedAddress = indexPath
            getCoordinate(of: contact.addresses[indexPath.row])
            
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
            if let cell = tableView.cellForRow(at: indexPathOfSelectedAddress) {
                cell.accessoryType = .none
            }
        }
        
        if let coord = addressCoordinate, indexPath == indexPathOfMap {
            let placemark = MKPlacemark(coordinate: coord)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = contact.addresses[indexPathOfSelectedAddress.row]
            mapItem.openInMaps(launchOptions: nil)
        }
        
        if indexPath.section == Section.delete.rawValue {
            do {
                try store.delete(contact: contact)
                navigationController?.popViewController(animated: true)
            } catch {
                showError(error, withTitle: NSLocalizedString("Unable to Delete", comment: ""))
            }
        }
    }
    
}

extension ContactViewController {
    
    private func headerCell(at indexPath: IndexPath) -> ContactHeaderCell {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactHeaderCell.self), for: indexPath) as! ContactHeaderCell
        headerCell.firstNameTextField.text = editedContact.firstName
        headerCell.lastNameTextField.text = editedContact.lastName
        headerCell.dateOfBirthTextField.text = editedContact.dateOfBirth
        headerCell.cameraIconView.isHidden = !isEditingContact
        headerCell.delegate = self
        headerCell.isUserInteractionEnabled = isEditingContact
        headerCell.selectionStyle = .none
        
        DispatchQueue.global().async {
            let image = ContactPhotoStore.photo(for: self.contact)
            DispatchQueue.main.async {
                headerCell.profileImageView.image = image
            }
        }
        
        return headerCell
    }
    
    private func phoneNumberCell(at indexPath: IndexPath) -> TextFieldCell {
        precondition(indexPath.section == 1)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCell.self), for: indexPath) as! TextFieldCell
        
        if indexPath.row < editedContact.phoneNumbers.count {
            cell.textField.text = PhoneNumberFormatter().format(editedContact.phoneNumbers[indexPath.row])
        }
        
        cell.textField.placeholder = NSLocalizedString("New Phone Number", comment: "")
        cell.textField.textColor = isEditingContact ? .black : view.tintColor
        cell.delegate = self
        cell.textField.isUserInteractionEnabled = isEditingContact
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }
    
    private func emailAddressCell(at indexPath: IndexPath) -> TextFieldCell {
        precondition(indexPath.section == 2)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCell.self), for: indexPath) as! TextFieldCell
        
        if indexPath.row < editedContact.emailAddresses.count {
            cell.textField.text = editedContact.emailAddresses[indexPath.row]
        }
        
        cell.textField.placeholder = NSLocalizedString("New Email Address", comment: "")
        cell.textField.textColor = isEditingContact ? .black : view.tintColor
        cell.delegate = self
        cell.textField.isUserInteractionEnabled = isEditingContact
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }
    
    private func addressCell(at indexPath: IndexPath) -> TextFieldCell {
        precondition(indexPath.section == Section.address.rawValue)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCell.self), for: indexPath) as! TextFieldCell
        
        if indexPath.row < editedContact.addresses.count {
            cell.textField.text = editedContact.addresses[indexPath.row]
        }
        
        cell.textField.placeholder = NSLocalizedString("New Address", comment: "")
        cell.delegate = self
        cell.textField.isUserInteractionEnabled = isEditingContact
        cell.selectionStyle = .none
        cell.accessoryType = !isEditingContact && indexPath == indexPathOfSelectedAddress ? .checkmark : .none
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
    
    private func deleteCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = NSLocalizedString("Delete Contact", comment: "")
        cell.textLabel?.textColor = .red
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }
    
}

extension ContactViewController: TextFieldCellDelegate {
    
    func textFieldCellTextDidChange(_ cell: TextFieldCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let lastRowInSection = tableView(tableView, numberOfRowsInSection: indexPath.section)
        
        switch indexPath.section {
        case Section.phoneNumbers.rawValue:
            let formatted = PhoneNumberFormatter().format(cell.textField.text ?? "")
            let unformatted = PhoneNumberFormatter().removeFormatting(from: cell.textField.text ?? "")
            cell.textField.text = formatted
            
            if formatted == nil && indexPath.row != lastRowInSection {
                tableView.beginUpdates()
                editedContact.phoneNumbers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            } else if indexPath.row < editedContact.phoneNumbers.count {
                editedContact.phoneNumbers[indexPath.row] = unformatted
            } else {
                tableView.beginUpdates()
                editedContact.phoneNumbers.append(unformatted)
                tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .automatic)
                tableView.endUpdates()
            }
            
        case Section.emailAddress.rawValue:
            if (cell.textField.text ?? "").isEmpty && indexPath.row != lastRowInSection {
                tableView.beginUpdates()
                editedContact.emailAddresses.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            } else if indexPath.row < editedContact.emailAddresses.count {
                editedContact.emailAddresses[indexPath.row] = cell.textField.text ?? ""
            } else {
                tableView.beginUpdates()
                editedContact.emailAddresses.append(cell.textField.text ?? "")
                tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .automatic)
                tableView.endUpdates()
            }
            
        case Section.address.rawValue:
            if (cell.textField.text ?? "").isEmpty && indexPath.row != lastRowInSection {
                tableView.beginUpdates()
                editedContact.addresses.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            } else if indexPath.row < editedContact.addresses.count {
                editedContact.addresses[indexPath.row] = cell.textField.text ?? ""
            } else {
                tableView.beginUpdates()
                editedContact.addresses.append(cell.textField.text ?? "")
                tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .automatic)
                tableView.endUpdates()
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

extension ContactViewController: ContactHeaderCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func contactHeaderCellTextDidChange(_ cell: ContactHeaderCell) {
        editedContact.firstName = cell.firstNameTextField.text ?? ""
        editedContact.lastName = cell.lastNameTextField.text ?? ""
        
        let dateOfBirth = DateOfBirthFormatter().format(cell.dateOfBirthTextField.text ?? "") ?? ""
        editedContact.dateOfBirth = dateOfBirth
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
    
    func contactHeaderCellDidSelectProfileImage(_ cell: ContactHeaderCell) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let fixedImage = image.fixOrientation() else {
            return
        }
        
        dismiss(animated: true) {
            let headerIndexPath = IndexPath(row: 0, section: Section.header.rawValue)
            if let cell = self.tableView.cellForRow(at: headerIndexPath) as? ContactHeaderCell {
                cell.profileImageView.image = fixedImage
            }
        }
        
        DispatchQueue.global().async {
            ContactPhotoStore.save(photo: fixedImage, for: self.contact)
        }
    }
    
}
