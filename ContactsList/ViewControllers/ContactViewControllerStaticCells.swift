//
//  ContactViewControllerStaticCells.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 23.01.2022.
//

import UIKit
import Kingfisher

class ContactViewControllerStaticCells: UITableViewController {
    
    @IBOutlet weak var contactImage: RoundedImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var cellPhoneTF: UITextField!
    @IBOutlet weak var homePhoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var contactID: String?
    var contact: ContactRealm?
    var imagePath: String?
    var addedContactsIndexPaths: IndexPath?
    
    private let storageManager = StorageManager.shared
    private let imageManager = ImageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contactID = contactID {
            contact = storageManager.retrieveObject(id: contactID)
            guard let contact = contact else { return }
            
            if let image = imageManager.retrieveImage(with: contact.localPicture ?? "") {
                contactImage.image = image
            } else {
                contactImage.image = UIImage(systemName: "photo.artframe")
            }
            
            firstNameTF.text = contact.firstName
            lastNameTF.text = contact.lastName
            cellPhoneTF.text = contact.cellPhone
            homePhoneTF.text = contact.homePhone
            emailTF.text = contact.email
            addressTF.text = contact.location
            
        } else if let contact = contact {
            contactID = contact.contactID
            if let image = URL(string: contact.picture ?? "") {
                contactImage.kf.setImage(with: image)
            } else {
                contactImage.image = UIImage(systemName: "photo.artframe")
            }
            
            firstNameTF.text = contact.firstName
            lastNameTF.text = contact.lastName
            cellPhoneTF.text = contact.cellPhone
            homePhoneTF.text = contact.homePhone
            emailTF.text = contact.email
            addressTF.text = contact.location
            
        } else {
            contactImage.image = UIImage(systemName: "photo.artframe")
        }
        firstNameTF.addTarget(
            self,
            action: #selector(dataDidChange),
            for: .editingChanged
        )
        lastNameTF.addTarget(
            self,
            action: #selector(dataDidChange),
            for: .editingChanged
        )
        cellPhoneTF.addTarget(
            self,
            action: #selector(dataDidChange),
            for: .editingChanged
        )
        homePhoneTF.addTarget(
            self,
            action: #selector(dataDidChange),
            for: .editingChanged
        )
        emailTF.addTarget(
            self,
            action: #selector(dataDidChange),
            for: .editingChanged
        )
        addressTF.addTarget(
            self,
            action: #selector(dataDidChange),
            for: .editingChanged
        )
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let image = contactImage.image else { return }
        guard let firstName = firstNameTF.text else { return }
        guard let lastName = lastNameTF.text else { return }
        guard let cellPhone = cellPhoneTF.text else { return }
        guard let homePhone = homePhoneTF.text else { return }
        guard let email = emailTF.text else { return }
        guard let location = addressTF.text else { return }
        
        if contactID == nil {
            contactID = UUID().uuidString
        }
        
        guard let contactID = contactID else { return }
        imageManager.saveImageOnDisk(
            image: image,
            pathComponent: contactID) { [weak self] imagePath in
                guard let self = self  else { return }
                self.imagePath = imagePath
            }
        
        createAndSave(
            contactID: contactID,
            firstName: firstName,
            lastName: lastName,
            location: location,
            email: email,
            cellPhone: cellPhone,
            homePhone: homePhone,
            picture: nil,
            localPicture: imagePath ?? ""
        )
        
        dismiss(animated: true)
    }

    
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Where do you want to set the photo from?", message: "You can use photo gallery or camera.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photoGallery = UIAlertAction(title: "Photo gallery", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            self.present(vc, animated: true)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.allowsEditing = true
            self.present(vc, animated: true)
        }
                                   
        alert.addAction(cancel)
        alert.addAction(photoGallery)
        alert.addAction(camera)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func dataDidChange() {
        if let firstName = firstNameTF.text,
           !firstName.isEmpty
        {
             doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    private func createAndSave(
        contactID: String,
        firstName: String,
        lastName: String,
        location: String,
        email: String,
        cellPhone: String,
        homePhone: String,
        picture: String?,
        localPicture: String?)
    {
        let contact = ContactRealm(
            contactID: contactID,
            firstName: firstName,
            lastName: lastName,
            location: location,
            email: email,
            picture: picture,
            localPicture: localPicture,
            cellPhone: cellPhone,
            homePhone: homePhone)
            storageManager.save(contact)
    }

}

extension ContactViewControllerStaticCells: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            contactImage.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
        dataDidChange()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
