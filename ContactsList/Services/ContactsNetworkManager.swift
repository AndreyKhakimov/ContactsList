//
//  ContactsNetworkManager.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 08.12.2021.
//

import Foundation

class ContactsNetworkManager {
    
    private enum Endpoints: Endpoint {
        case getContacts(Int)
        var url: URL {
            switch self {
            case .getContacts(let number):
                return URL(string: NetworkManager.hostUrl + "/?results=\(number)")!
            }
        }
        var httpMethod: String {
            switch self {
            case .getContacts:
                return "GET"
            }
        }
    }
    
    private let networkManager = NetworkManager.shared
    
    func getContacts(count: Int, completion: @escaping ([Contact]?) -> Void) {
        networkManager.sendRequest(
            endpoint: Endpoints.getContacts(count),
            completion: { (response: ContactsResponse?) in
                completion(response?.results)
            }
        )
    }
    
}
