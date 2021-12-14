//
//  NetworkManager.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import Foundation

protocol Endpoint {
    var url: URL { get }
    var httpMethod: String { get }
}

enum NetworkError: Error {
    case noData
    case decodingError
    case other(Error)
    
    var title: String {
        "Error"
    }
    
    var description: String {
        switch self {
        case .noData:
            return "The data received from the server is invalid"
            
        case .decodingError:
            return "The data can not be decoded"
            
        case .other(let error):
            return error.localizedDescription
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    static let hostUrl = "https://randomuser.me/api"
    
   private init() {}
    
    func sendRequest<Response: Decodable>(endpoint: Endpoint, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.httpMethod
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            
            var data = data
            if Response.self == Void.self {
                data = Data()
            }
            guard let data = data
            else {
                completion(.failure(.noData))
                return
            }
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
}


