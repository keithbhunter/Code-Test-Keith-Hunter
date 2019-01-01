//
//  ContactViewController.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import CoreLocation
import UIKit

final class ContactViewController: UIViewController, UITableViewDelegate, ContactViewModelDelegate {
    
    private let viewModel: ContactViewModel
    
    
    // MARK: Init
    
    init(contact: Contact) {
        viewModel = ContactViewModel(contact: contact)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        viewModel.getCoordinateOfAddress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    
    // MARK: - Setup
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraints(equalTo: view))
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath == viewModel.indexPathOfMap ? 250 : UITableView.automaticDimension
    }
    
    
    // MARK: - ContactViewModelDelegate
    
    func viewModel(_ viewModel: ContactViewModel, foundAddressCoordinate coordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            self.tableView.reloadSections([ContactViewModel.Section.address.rawValue], with: .none)
        }
    }
    
    func viewModelFailedToFindAddressCoordinate(_ viewModel: ContactViewModel) {
        print("Unable to find coordinate")
    }
    
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.contentInsetAdjustmentBehavior = .never
        table.contentInset = UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 0)
        
        table.register(ContactHeaderCell.self, forCellReuseIdentifier: String(describing: ContactHeaderCell.self))
        table.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        table.register(MapCell.self, forCellReuseIdentifier: String(describing: MapCell.self))
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
}

extension ContactViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        guard let section = ContactViewModel.Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section: \(indexPath.section)")
        }
        
        switch section {
        case .header:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactHeaderCell.self), for: indexPath) as! ContactHeaderCell
            viewModel.configure(headerCell: headerCell)
            cell = headerCell
            
        case .phoneNumbers:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            viewModel.configure(phoneNumberCell: cell, at: indexPath)
            
        case .emailAddress:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            viewModel.configure(emailAddressCell: cell, at: indexPath)
            
        case .address:
            if indexPath == viewModel.indexPathOfMap {
                let mapCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MapCell.self), for: indexPath) as! MapCell
                viewModel.configure(mapCell: mapCell)
                cell = mapCell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
                viewModel.configure(addressCell: cell, at: indexPath)
            }
            
        default: fatalError("Unexpected section: \(indexPath.section)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(forSection: section)
    }
    
}
