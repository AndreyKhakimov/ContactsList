//
//  ContactsTableViewController.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class ContactsTableViewController: UITableViewController {
    
    private let contactsNetworkManager = ContactsNetworkManager()
    private let storageManager = StorageManager.shared
    
    var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(with: 100)
        setupRefreshControl()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customContact", for: indexPath) as! ContactTableViewCell
        let contact = contacts[indexPath.row]
        let imageURL = URL(string: contact.picture?.large ?? "")!
        cell.configure(image: imageURL, name: contact.name?.fullname ?? "")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let detailVC = segue.destination as? DetailInfoViewController else { return }
        let contact = contacts[indexPath.row]
        detailVC.contact = contact
    }
    
    private func fetchData(with personNumber: Int) {
        contactsNetworkManager.getContacts(
            count: personNumber,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let contacts):
                        self.contacts = contacts
                        self.storageManager.save(contacts)
                        self.tableView.reloadData()
                        if self.refreshControl != nil {
                            self.refreshControl?.endRefreshing()
                        }
                        
                    case .failure(let error):
                        self.showAlert(title: error.title, message: error.description)
                    }
                }
            }
        )
    }
    
    @objc private func fetchData() {
        contactsNetworkManager.getContacts(
            count: 100,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let contacts):
                        self.contacts = contacts
                        self.storageManager.save(contacts)
                        self.tableView.reloadData()
                        if self.refreshControl != nil {
                            self.refreshControl?.endRefreshing()
                        }
                        
                    case .failure(let error):
                        self.showAlert(title: error.title, message: error.description)
                    }
                }
            }
        )
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(fetchData as () -> Void), for: .valueChanged)
    }
    
}
