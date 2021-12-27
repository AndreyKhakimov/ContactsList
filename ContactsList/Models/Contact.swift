//
//  Contact.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import RealmSwift

struct Contact: Codable {
    var name: Name?
    var location: Location?
    var email: String = ""
    var picture: Picture?
    var cellPhone: String = ""
    var homePhone: String = ""
    
    var info: String {
    """
    Name: \(name?.fullname ?? "")
    Location: \(location?.city ?? ""), \(location?.street?.fullStreet ?? "")
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
    
    struct Name: Codable {
        var first: String = ""
        var last: String = ""
        var fullname: String {
            first + " " + last
        }
    }

    struct Location: Codable {
        var street: Street?
        var city: String = ""
    }

    class Street: Codable {
        var number: Int = 0
        var name: String = ""
        var fullStreet: String {
            name + " \(number)"
        }
    }

    struct Picture: Codable {
        var large: String = ""
    }
    
}
