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
        
        case getSuggestedContacts(Int)
        
        var query: String {
            switch self {
            case .getSuggestedContacts(let number):
                return "/?results=\(number)"
            }
        }
    }
    
    private let networkManager = NetworkManager.shared
    
    func getSuggestedContacts(count: Int, completion: @escaping (Result<[SuggestedContact], NetworkError>) -> Void) {
        networkManager.sendRequest(
            endpoint: Endpoints.getSuggestedContacts(count),
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
