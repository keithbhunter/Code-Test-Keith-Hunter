//
//  ViewController.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/21/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class ContactListViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    private let store: DataStore
    private let searchController = UISearchController(searchResultsController: nil)
    private var hasSearchQuery: Bool { return (searchController.searchBar.text ?? "").count > 0 }
    private var contacts = [Contact]()
    private var viewModel: ContactListViewModel?
    
    
    // MARK: - Init
    
    init(store: DataStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contacts = store.fetchAllContacts().sorted { $0.firstName < $1.firstName }
        viewModel = ContactListViewModel(contacts: contacts)
        tableView.reloadData()
    }
    
    
    // MARK: - Setup
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search Contacts", comment: "")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        
        if let contact = viewModel?.contact(at: indexPath) {
            cell.textLabel?.text = contact.firstName + " " + contact.lastName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.title(forSection: section)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.sectionIndexTitles
    }
    
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        
        let results = ContactSearcher.search(contacts: contacts, for: query)
        viewModel = ContactListViewModel(contacts: results)
        tableView.reloadData()
    }
    
    
    // MARK: - Views

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        table.dataSource = self
        
        return table
    }()

}
