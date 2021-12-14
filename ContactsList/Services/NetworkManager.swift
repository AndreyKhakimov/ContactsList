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

class NetworkManager {
    
    static let shared = NetworkManager()
    static let hostUrl = "https://randomuser.me/api"
    
   private init() {}
    
    func sendRequest<Response: Decodable>(endpoint: Endpoint, completion: @escaping (Response?) -> Void) {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.httpMethod
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data
            else {
                print(error?.localizedDescription ?? "No error description")
                completion(nil)
                return
            }
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                completion(result)
            } catch let error {
                print(error)
                completion(nil)
            }
        }.resume()
    }
    
}


