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
    
    var contacts: Results<ContactRealm>!
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = try! Realm().objects(ContactRealm.self).sorted(byKeyPath: "lastName")
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
        if let pictureURL = contact.picture {
            imageURL = URL(string: pictureURL)
        }
//       нужны ли в модели реалм опциональные типы свойств cell.configure(image: imageURL, name: contact.fullName ?? "")
        cell.configure(image: imageURL, name: contact.fullName)
        return cell
    }

}
