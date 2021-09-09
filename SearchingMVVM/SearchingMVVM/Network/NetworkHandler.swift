//
//  NetworkHandler.swift
//  SearchingMVVM
//
//  Created by Ankita on 09.09.21.
//

import Foundation

enum HTTPMethods: String {
    case GET
    case POST
}

struct ContentType {
    static let json = "application/json"
}

struct HTTPHeaders {
    static let contentType = "Content-Type"
    static let contentLength = "Content-Length"
    static let contentDisposition = "Content-Dispositio"
    static let accept = "Accept"
    static let apiKey = "x-ps-api-key"
}

struct Config: NetworkConfigProtocol {
    var apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

class NetworkHandler: NetworkHandlerProtocol {
    var config: NetworkConfigProtocol? // TODO access specifier
    private var session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default), config:NetworkConfigProtocol?) {
        self.session = session
        self.config = config
    }
    
    func fetchRequest<T: Decodable>(for url: URL, method: HTTPMethods = .GET, contentType: String = ContentType.json, completion: @escaping (T?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(contentType, forHTTPHeaderField: HTTPHeaders.contentType)
        request.setValue(ContentType.json, forHTTPHeaderField: HTTPHeaders.accept)
        if let apiKey = config?.apiKey, apiKey != "" {
            request.setValue(apiKey, forHTTPHeaderField: HTTPHeaders.apiKey)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let data = data else {
                completion(nil, error) // TODO handle error types
                return
            }
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(object, nil)
            } catch {
                completion(nil, error) // TODO handle error types
            }
        }
        
        task.resume()
    }
}
