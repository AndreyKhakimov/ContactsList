//
//  NewContactViewController.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 26.12.2021.
//

import UIKit
import Kingfisher

class ContactViewController: UIViewController {
    
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
    
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contactID = contactID {
            contact = storageManager.retrieveObject(id: contactID)
            guard let contact = contact else { return }
            
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
            
        } else if let contact = contact {
            
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
            action: #selector(firstNameTFDidChanged),
            for: .editingChanged
        )
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let firstName = firstNameTF.text else { return }
        guard let lastName = lastNameTF.text else { return }
        guard let cellPhone = cellPhoneTF.text else { return }
        guard let homePhone = homePhoneTF.text else { return }
        guard let email = emailTF.text else { return }
        guard let location = addressTF.text else { return }
        //        if contact == nil {
        createAndSave(
            firstName: firstName,
            lastName: lastName,
            location: location,
            email: email,
            cellPhone: cellPhone,
            homePhone: homePhone
        )
        //        } else {
        //            editAndSave(
        //                firstName: firstName,
        //                lastName: lastName,
        //                location: location,
        //                email: email,
        //                cellPhone: cellPhone,
        //                homePhone: homePhone
        //            )
        //        }
        dismiss(animated: true)
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func firstNameTFDidChanged() {
        guard let firstName = firstNameTF.text else { return }
        doneButton.isEnabled = !firstName.isEmpty
    }
    
    private func createAndSave(
        firstName: String,
        lastName: String,
        location: String,
        email: String,
        cellPhone: String,
        homePhone: String)
    {
        let contact = ContactRealm(
            contactID: contact?.contactID ?? UUID().uuidString,
            firstName: firstName,
            lastName: lastName,
            location: location,
            email: email,
            picture: contact?.picture,
            cellPhone: cellPhone,
            homePhone: homePhone)
        storageManager.save(contact)
    }
    
    //    private func editAndSave(
    //        firstName: String,
    //        lastName: String,
    //        location: String,
    //        email: String,
    //        cellPhone: String,
    //        homePhone: String)
    //    {
    //        guard let contact = contact else {
    //            return
    //        }
    //
    //        storageManager.editContact(
    //            contact: contact,
    //            firstName: firstName,
    //            lastName: lastName,
    //            location: location,
    //            email: email,
    //            cellPhone: cellPhone,
    //            homePhone: homePhone
    //        )
    //    }
    
}

extension ContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            contactImage.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
