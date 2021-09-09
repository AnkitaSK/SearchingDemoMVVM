//
//  AppSearchViewModel.swift
//  SearchingMVVM
//
//  Created by Ankita on 09.09.21.
//

import Foundation

//struct NetworkConfigForSearch: NetworkConfigProtocol { // not needed as we can pass nil
//    var apiKey: String = ""
//}

class AppSearchViewModel {
    var appResults = Bindable<[Result]>()
    var isSearching = Bindable<Bool>()
    
    let networkHandler = NetworkHandler(config: nil)
    
    var timer: Timer?
    
    func performSearch(_ searchText: String) {
        timer?.invalidate()
        isSearching.value = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            let urlString = "https://itunes.apple.com/search?term=\(searchText)&entity=software" // TODO may be store in config
            guard let url = URL(string: urlString) else {
                return
            }
            self.search(searchTextWithUrl: url) { [weak self] searchResult, error in
                self?.appResults.value = searchResult?.results ?? []
                self?.isSearching.value = false
            }
        })
    }
    
    private func search(searchTextWithUrl: URL, completion: @escaping (SearchResult?, Error?) -> ()) {
        networkHandler.fetchRequest(for: searchTextWithUrl, completion: completion)
    }
}
