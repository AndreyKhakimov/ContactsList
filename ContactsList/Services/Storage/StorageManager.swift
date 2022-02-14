//
//  StorageManager.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 15.12.2021.
//

import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func editContact(
        contact: ContactRealm,
        firstName: String,
        lastName: String,
        location: String,
        email: String,
        cellPhone: String,
        homePhone: String)
    {
        let realm = try! Realm()
        try? realm.write {
            contact.firstName = firstName
            contact.lastName = lastName
            contact.location = location
            contact.email = email
            contact.cellPhone = cellPhone
            contact.homePhone = homePhone
        }
    }
    
    func save(_ object: ContactRealm) {
        do {
            try realm.write {
                realm.add(object, update: .all)
                print("Realm is located at:", realm.configuration.fileURL!)
            }
        } catch {
            print("Saving data Error")
        }
    }
    
    func save(_ objects: [ContactRealm]) {
        do {
            try realm.write {
                realm.add(objects)
                print("Realm is located at:", realm.configuration.fileURL!)
            }
        } catch {
            print("Saving data Error")
        }
    }
    
    func delete(_ objects: [ContactRealm]) {
        do {
            try realm.write {
                realm.delete(objects)
                print("Realm is located at:", realm.configuration.fileURL!)
            }
        } catch {
            print("Saving data Error")
        }
    }
    
    func delete(_ object: ContactRealm) {
        do {
            try realm.write {
                realm.delete(object)
                print("Realm is located at:", realm.configuration.fileURL!)
            }
        } catch {
            print("Saving data Error")
        }
    }
    
    func retrieveObject(id: String) -> ContactRealm? {
        realm.object(ofType: ContactRealm.self, forPrimaryKey: id)
    }
    
    func getSavedContacts() -> [ContactRealm] {
        let realmObjects = realm.objects(ContactRealm.self)
        return Array(realmObjects)
    }
    
}
