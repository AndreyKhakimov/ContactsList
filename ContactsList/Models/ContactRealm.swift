//
//  ContactRealm.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 26.12.2021.
//

import Foundation
import RealmSwift

class ContactRealm: Object {
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var location: String = ""
    @Persisted var email: String = ""
    @Persisted var picture: String? = ""
    @Persisted var cellPhone: String = ""
    @Persisted var homePhone: String = ""

    convenience init(
        firstName: String,
        lastName: String,
        location: String,
        email: String,
        picture: String?,
        cellPhone: String,
        homePhone: String
    ) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
        self.email = email
        self.picture = picture
        self.cellPhone = cellPhone
        self.homePhone = homePhone
    }
    
    var fullName: String {
        firstName + " " + lastName
    }
    
    var info: String {
    """
    Name: \(firstName + lastName)
    Cell phone: \(cellPhone)
    Home phone: \(homePhone)
    Email: \(email)
    Adress: \(location)
    """
    }
    
}
