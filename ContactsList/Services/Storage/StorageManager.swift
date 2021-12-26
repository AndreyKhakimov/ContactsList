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
    
    func save(_ object: Contact) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Saving data Error")
        }
    }
    
    func save(_ objects: [Contact]) {
        do {
            try realm.write {
                realm.delete(realm.objects(Contact.self))
                realm.delete(realm.objects(Name.self))
                realm.delete(realm.objects(Location.self))
                realm.delete(realm.objects(Street.self))
                realm.delete(realm.objects(Picture.self))
                realm.add(objects)
                print("Realm is located at:", realm.configuration.fileURL!)
            }
        } catch {
            print("Saving data Error")
        }
    }
    
    private func retrieveObject() {}
}
