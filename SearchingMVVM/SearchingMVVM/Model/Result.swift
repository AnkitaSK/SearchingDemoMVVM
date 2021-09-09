//
//  Result.swift
//  SearchingMVVM
//
//  Created by Ankita on 09.09.21.
//

import Foundation

struct SearchResult {
    let resultCount: Int
    let results: [Result]
}

struct Result {
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String // app icon
    let description: String
    let releaseNotes: String
}

extension SearchResult: Decodable {}
extension Result: Decodable {}
