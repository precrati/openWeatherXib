//
//  NetworkManager.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 18/05/2021.
//

import Foundation

final class NetworkManager {
    
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func request<T: Codable>(url: String, parameters: [String: String], type: T.Type, method: HTTPMethods? = .get, completeion: @escaping (T?, Error?) -> ()) {
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        request.httpMethod = method?.rawValue
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("\(error)")
                completeion(nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let result = try self.decoder.decode(T.self, from: data)
                completeion(result, nil)
            } catch let jsonError {
                print("There was an error connection \(jsonError)")
                completeion(nil, jsonError)
            }
        }
        task.resume()
    }
    
}
