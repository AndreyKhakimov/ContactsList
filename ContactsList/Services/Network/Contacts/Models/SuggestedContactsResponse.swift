//
//  ContactsResponse.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 20.12.2021.
//

import Foundation

struct SuggestedContactsResponse: Decodable {
    let results: [SuggestedContact]
}
