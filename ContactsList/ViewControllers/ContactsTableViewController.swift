//
//  AddingContactsTableViewController.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 26.12.2021.
//

import UIKit
import RealmSwift

class ContactsTableViewController: UITableViewController {
    
    private let storageManager = StorageManager.shared
    private let imageManager = ImageManager.shared
    
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
        let image = imageManager.retrieveImage(with: contact.localPicture ?? "")
        cell.configure(image: image, name: contact.fullName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Are you sure?", message: "This action can not be undone.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                let contactToRemove = self.contacts[indexPath.row]
                self.imageManager.deleteImageFromDisk(pathComponent: contactToRemove.localPicture ?? "")
                self.storageManager.delete(contactToRemove)
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactNavVC = storyboard.instantiateViewController(withIdentifier: "StaticCells") as!
        UINavigationController
        let contactVC = contactNavVC.viewControllers.first as! ContactViewControllerStaticCells
        let contact = contacts[indexPath.row]
        contactVC.contactID = contact.contactID
        present(contactNavVC, animated: true, completion: nil)
    }
    
}
