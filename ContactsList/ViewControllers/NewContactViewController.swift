//
//  NewContactViewController.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 26.12.2021.
//

import UIKit

class NewContactViewController: UIViewController {

    @IBOutlet weak var contactImage: RoundedImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var cellPhoneTF: UITextField!
    @IBOutlet weak var homePhoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTF.addTarget(
            self,
            action: #selector(firstNameTFDidChanged),
            for: .editingChanged
        )
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        saveAndExit()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func firstNameTFDidChanged() {
        guard let firstName = firstNameTF.text else { return }
        doneButton.isEnabled = !firstName.isEmpty
    }
    
    private func saveAndExit() {
//      guard let contactImage
        guard let firstName = firstNameTF.text else { return }
        guard let lastName = lastNameTF.text else { return }
        guard let cellPhone = cellPhoneTF.text else { return }
        guard let homePhone = homePhoneTF.text else { return }
        guard let email = emailTF.text else { return }
        guard let address = addressTF.text else { return }
        let contact = ContactRealm(
            firstName: firstName,
            lastName: lastName,
            location: address,
            email: email,
            picture: nil,
            cellPhone: cellPhone,
            homePhone: homePhone)
        storageManager.save(contact)
        dismiss(animated: true)
    }
    
}
