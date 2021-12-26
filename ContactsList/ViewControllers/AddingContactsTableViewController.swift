//
//  AddingContactsTableViewController.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 26.12.2021.
//

import UIKit
import RealmSwift

class AddingContactsTableViewController: UITableViewController {

    private let storageManager = StorageManager.shared
    
    var contacts: Results<Contact>!
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = try! Realm().objects(Contact.self).sorted(byKeyPath: "name.last")
        token = contacts.observe(on: .main) { [weak self] results in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customContact", for: indexPath) as! ContactTableViewCell
        let contact = contacts[indexPath.row]
        var imageURL: URL?
        if let pictureURL = contact.picture?.large {
            imageURL = URL(string: pictureURL)
        }
        cell.configure(image: imageURL, name: contact.name?.fullname ?? "")
        return cell
    }

}
