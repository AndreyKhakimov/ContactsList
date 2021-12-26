//
//  Contact.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import RealmSwift

class Contact: Object, Codable {
    @Persisted var name: Name?
    @Persisted var location: Location?
    @Persisted var email: String = ""
    @Persisted var picture: Picture?
    @Persisted var cellPhone: String = ""
    @Persisted var homePhone: String = ""
    
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
    
}

class Name: Object, Codable {
    @Persisted var first: String = ""
    @Persisted var last: String = ""
    var fullname: String {
        first + " " + last
    }
}

class Location: Object, Codable {
    @Persisted var street: Street?
    @Persisted var city: String = ""
}

class Street: Object, Codable {
    @Persisted var number: Int = 0
    @Persisted var name: String = ""
    var fullStreet: String {
        name + " \(number)"
    }
}

class Picture: Object, Codable {
    @Persisted var large: String = ""
}
