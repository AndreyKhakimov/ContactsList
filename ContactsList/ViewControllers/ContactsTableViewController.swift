//
//  ContactsTableViewController.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import UIKit
import Kingfisher

class ContactsTableViewController: UITableViewController {
    
    let contactsNetworkManager = ContactsNetworkManager()
    
    var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(with: 100)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customContact", for: indexPath) as! ContactTableViewCell
        let contact = contacts[indexPath.row]
        let imageURL = URL(string: contact.picture.large)!
        cell.configure(image: imageURL, name: contact.name.fullname)
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
                        self.tableView.reloadData()
                        
                    case .failure(let error):
                        self.showAlert(title: error.title, message: error.description)
                    }
                }
            }
        )
    }
    
}
