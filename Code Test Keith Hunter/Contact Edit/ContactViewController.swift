//
//  ContactViewController.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class ContactViewController: UIViewController, UITableViewDataSource {
    
    private let viewModel: ContactViewModel
    
    
    // MARK: Init
    
    init(contact: Contact) {
        viewModel = ContactViewModel(contact: contact)
        super.init(nibName: nil, bundle: nil)
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
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactHeaderCell.self), for: indexPath) as! ContactHeaderCell
        viewModel.configure(headerCell: cell)
        return cell
    }
    
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(ContactHeaderCell.self, forCellReuseIdentifier: String(describing: ContactHeaderCell.self))
        table.dataSource = self
        
        return table
    }()
    
}
