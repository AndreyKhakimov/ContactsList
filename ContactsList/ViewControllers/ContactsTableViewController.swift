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
        configureDefaultState()
        tableView.allowsMultipleSelectionDuringEditing = true
        contacts = try! Realm().objects(ContactRealm.self).sorted(byKeyPath: "lastName")
        token = contacts.observe(on: .main) { [weak self] results in
            self?.tableView.reloadData()
        }
    }
    
    private func configureEditingState() {
        tableView.setEditing(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditing))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteSelectedRows))]
        navigationItem.rightBarButtonItems?.first?.isEnabled = false
    }
    
    private func configureDefaultState() {
        tableView.setEditing(false, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(deleteMultipleContacts))
        let suggestionItem = UIBarButtonItem(title: "You may know", style: .plain, target: self, action: #selector(showSuggestions))
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewContact))
        navigationItem.rightBarButtonItems = [addItem, suggestionItem]
    }
    
    @objc private func deleteSelectedRows() {
        let contactsArray = tableView.indexPathsForSelectedRows?.reversed().compactMap({ [contacts] indexPath in
            contacts?[indexPath.row]
        }) ?? []
        let contactsImages = contactsArray.map { $0.localPicture ?? "" }
        imageManager.deleteImagesFromDisk(pathComponents: contactsImages)
        storageManager.delete(contactsArray)
    }
    
    @objc private func showSuggestions() {
        performSegue(withIdentifier: "suggestedContacts", sender: self)
    }
    
    @objc private func showNewContact() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactNavVC = storyboard.instantiateViewController(withIdentifier: "StaticCells") as!
        UINavigationController
        present(contactNavVC, animated: true, completion: nil)
    }
    
    @objc private func deleteMultipleContacts() {
        configureEditingState()
    }
    
    @objc private func cancelEditing() {
        configureDefaultState()
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
        guard !tableView.isEditing else {
            navigationItem.rightBarButtonItems?.first?.isEnabled = true
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactNavVC = storyboard.instantiateViewController(withIdentifier: "StaticCells") as!
        UINavigationController
        let contactVC = contactNavVC.viewControllers.first as! ContactViewControllerStaticCells
        let contact = contacts[indexPath.row]
        contactVC.contactID = contact.contactID
        tableView.deselectRow(at: indexPath, animated: true)
        present(contactNavVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard !tableView.isEditing else {
            navigationItem.rightBarButtonItems?.first?.isEnabled = tableView.indexPathsForSelectedRows?.isEmpty == false
            return
        }
    }
    
}
