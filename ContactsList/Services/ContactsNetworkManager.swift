//
//  ContactsNetworkManager.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 08.12.2021.
//

import Foundation
import UIKit

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
    
    func getContacts(count: Int, completion: @escaping (Result<[Contact], NetworkError>) -> Void) {
        networkManager.sendRequest(
            endpoint: Endpoints.getContacts(count),
            completion: { (result: Result<ContactsResponse, NetworkError>) in
                switch result {
                case .success(let contacts):
                    completion(.success(contacts.results))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
    
}
