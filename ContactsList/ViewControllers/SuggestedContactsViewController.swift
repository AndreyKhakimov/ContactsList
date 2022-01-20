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
    
    var contacts = [SuggestedContact]()
    var addedContactsIndexPaths = Set<IndexPath>()
    var test: (() -> Void)? = {}
    var imagePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test = { [unowned self] in
            self.contacts.removeAll()
            
        }
        //            switch results {
        //            case .initial:
        //                self?.tableView.reloadData()
        //            case .error(let error):
        //                self?.showAlert(title: "Error", message: error.localizedDescription)
        //            case .update(_, let deletions, let insertions, let modifications):
        //                self?.tableView.beginUpdates()
        //                self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0)}, with: .automatic)
        //                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0)}, with: .automatic)
        //                self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0)}, with: .automatic)
        //                self?.tableView.endUpdates()
        //            }
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
        
        cell.configure(
            image: imageURL,
            name: contact.name?.fullname ?? "",
            onPlusTapped: { [weak self] in
                guard let self = self else { return }
                var image: UIImage?
                self.imageManager.downloadImage(with: contact.picture?.large ?? "") { downloadedImage in
                    image = downloadedImage
                }
                let contactID = UUID().uuidString
                let realmContact = ContactRealm(
                    contactID: contactID,
                    firstName: contact.name?.first ?? "",
                    lastName: contact.name?.last ?? "",
                    location: contact.location?.fullAddress ?? "",
                    email: contact.email,
                    picture: nil,
                    localPicture: contactID,
                    cellPhone: contact.cellPhone,
                    homePhone: contact.homePhone
                )
                if let image = image {
                    self.imageManager.saveImageOnDisk(
                        image: image,
                        pathComponent: realmContact.localPicture ?? "")
                }
                realmContact.localPicture = contactID + ""
                self.storageManager.save(realmContact)
                self.addedContactsIndexPaths.insert(indexPath)
            },
            isAdded: addedContactsIndexPaths.contains(indexPath)
        )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactVC = storyboard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        let contact = contacts[indexPath.row]
        let realmContact = ContactRealm(
            contactID: UUID().uuidString,
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
        present(contactVC, animated: true) {
            contactVC.dataDidChange()
        }

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
