//
//  ContactsNetworkManager.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 08.12.2021.
//

import RealmSwift
import UIKit

class ContactsNetworkManager {
    
    private enum Endpoints: EndpointProtocol {
        case getContacts(Int)
        
        var url: URL {
            var query = ""
            switch self {
            case .getContacts(let number):
                query = "/?results=\(number)"
            }
            
            return URL(string: Endpoints.hostURL + query)!
        }
        var httpMethod: String {
            switch self {
            case .getContacts:
                return "GET"
            }
        }
    }
    
    private let networkManager = NetworkManager.shared
    
    func getSuggestedContacts(count: Int, completion: @escaping (Result<[SuggestedContact], NetworkError>) -> Void) {
        networkManager.sendRequest(
            endpoint: Endpoints.getContacts(count),
            completion: { (result: Result<SuggestedContactsResponse, NetworkError>) in
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
