//
//  Contact.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import Foundation

struct ContactsResponse: Codable {
    let results: [Contact]
}

struct Contact: Codable {
    let name: Name
    let location: Location
    let email: String
    let picture: Picture
    let cellPhone: String
    let homePhone: String
    
    var description: String {
        """
    Name: \(name.fullname)
    Location: \(location.city), \(location.street.fullStreet)
    Email: \(email)
    Home phone: \(homePhone)
    Cell phone: \(cellPhone)
    """
    }
    
    enum CodingKeys: String, CodingKey {
        case name, location, email, picture
        case cellPhone = "cell"
        case homePhone = "phone"
    }
}

struct Name: Codable {
    let first: String
    let last: String
    var fullname: String {
        first + " " + last
    }
}

struct Location: Codable {
    let street: Street
    let city: String
}

struct Street: Codable {
    let number: Int
    let name: String
    var fullStreet: String {
        name + " \(number)"
    }
}

struct Picture: Codable {
    let large: String
}
