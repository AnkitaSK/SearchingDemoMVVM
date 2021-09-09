//
//  NetworkHandlerProtocol.swift
//  SearchingMVVM
//
//  Created by Ankita on 09.09.21.
//

import Foundation

protocol NetworkConfigProtocol {
    var apiKey: String {get set}
}
protocol NetworkHandlerProtocol {
    var config: NetworkConfigProtocol? { get set }
}
