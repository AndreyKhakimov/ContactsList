//
//  ContactsTableViewController.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import UIKit
import RealmSwift
import Kingfisher

class SuggestedContactsViewController: UITableViewController {
    
    private let contactsNetworkManager = ContactsNetworkManager()
    private let storageManager = StorageManager.shared
    private let imageManager = ImageManager.shared
    private var token: NotificationToken?
    
    var contacts = [SuggestedContact]()
    var addedContacts: Results<ContactRealm>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(with: 100)
        setupRefreshControl()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestedContact", for: indexPath) as! SuggestedContactCell
        let contact = contacts[indexPath.row]
        let imageURL = URL(string: contact.picture?.large ?? "")
        let isAdded = storageManager.retrieveObject(id: contact.contactID) != nil
        cell.configure(
            image: imageURL,
            name: contact.name?.fullname ?? "",
            onPlusTapped: { [weak self] in
                print("ON plus tapped -----")
                guard let self = self else { return }
                var image: UIImage?
                
                self.imageManager.downloadImage(with: contact.picture?.large ?? "") { downloadedImage in
                    image = downloadedImage
                }
                var localImage: String?
                if let image = image {
                    self.imageManager.saveImageOnDisk(
                        image: image,
                        pathComponent: contact.contactID) { localImagePath in
                            localImage = localImagePath
                        }
                }
                
                let realmContact = ContactRealm(
                    contactID: contact.contactID,
                    firstName: contact.name?.first ?? "",
                    lastName: contact.name?.last ?? "",
                    location: contact.location?.fullAddress ?? "",
                    email: contact.email,
                    picture: nil,
                    localPicture: localImage,
                    cellPhone: contact.cellPhone,
                    homePhone: contact.homePhone
                )

                self.storageManager.save(realmContact)
            },
            isAdded: isAdded
        )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactNavVC = storyboard.instantiateViewController(withIdentifier: "StaticCells") as!
        UINavigationController
        let contactVC = contactNavVC.viewControllers.first as! ContactViewControllerStaticCells
        let contact = contacts[indexPath.row]
        let realmContact = ContactRealm(
            contactID: contact.contactID,
            firstName: contact.name?.first ?? "",
            lastName: contact.name?.last ?? "",
            location: contact.location?.fullAddress ?? "",
            email: contact.email,
            picture: contact.picture?.large,
            localPicture: nil,
            cellPhone: contact.cellPhone,
            homePhone: contact.homePhone
        )
        contactVC.contact = realmContact
        present(contactNavVC, animated: true) {
            contactVC.doneButton.title = "Add"
            contactVC.dataDidChange()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func fetchData(with personNumber: Int) {
        contactsNetworkManager.getSuggestedContacts(
            count: personNumber,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let contacts):
                        self.contacts = contacts
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
    
    @objc private func refreshAction() {
        fetchData(with: 100)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
    
}
