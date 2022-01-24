//
//  Contact.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import RealmSwift

struct SuggestedContact: Decodable {
    var contactID: String
    var name: Name?
    var location: Location?
    var email: String = ""
    var picture: Picture?
    var cellPhone: String = ""
    var homePhone: String = ""
        
    enum CodingKeys: String, CodingKey {
        case name, location, email, picture
        case cellPhone = "cell"
        case homePhone = "phone"
    }
    
    enum NameCodingKeys: String, CodingKey {
        case first, last
    }
    
    enum LocationCodingKeys: String, CodingKey {
        case street, city
    }
    
    enum StreetCodingKeys: String, CodingKey {
        case number, name
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case large, medium, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameElement = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        let firstName = try nameElement.decode(String.self, forKey: .first)
        let lastName = try nameElement.decode(String.self, forKey: .last)
        let locationElement = try container.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .location)
        let streetElement = try locationElement.nestedContainer(keyedBy: StreetCodingKeys.self, forKey: .street)
        let houseNumber = try streetElement.decode(Int.self, forKey: .number)
        let streetName = try streetElement.decode(String.self, forKey: .name)
        let city = try locationElement.decode(String.self, forKey: .city)
        let email = try container.decode(String.self, forKey: .email)
        let pictureElement = try container.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
        let picture = try pictureElement.decode(String.self, forKey: .large)
        let cellPhone = try container.decode(String.self, forKey: .cellPhone)
        let homePhone = try container.decode(String.self, forKey: .homePhone)
        
        self.contactID = UUID().uuidString
        self.name = Name(first: firstName, last: lastName)
        self.location = Location(street: Street(number: houseNumber, name: streetName), city: city)
        self.email = email
        self.picture = Picture(large: picture)
        self.cellPhone = cellPhone
        self.homePhone = homePhone
    }
    
    struct Name: Decodable {
        var first: String = ""
        var last: String = ""
        var fullname: String {
            first + " " + last
        }
    }

    struct Location: Decodable {
        var street: Street?
        var city: String = ""
        var fullAddress: String {
          "\(city), \(street?.fullStreet ?? "")"
        }
    }

    struct Street: Decodable {
        var number: Int = 0
        var name: String = ""
        var fullStreet: String {
            name + " \(number)"
        }
    }

    struct Picture: Decodable {
        var large: String = ""
    }
    
}
