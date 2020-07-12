//
//  SearchResultController.swift
//  iTunes Search
//
//  Created by Eoin Lavery on 09/07/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import Foundation

class SearchResultController {
    let baseUrl = URL(string: "https://itunes.apple.com/search")
    
    var searchResults: [SearchResult] = []
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void) {
        
        guard let url = baseUrl else {
            print("Given URL is not valid.")
            return
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let searchQueryTerm = URLQueryItem(name: "term", value: searchTerm)
        let resultTypeQueryItem = URLQueryItem(name: "entity", value: resultType.rawValue)
        urlComponents?.queryItems = [searchQueryTerm, resultTypeQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            print("URL Request item is not valid.")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error fetching data: \(error).")
                return
            }
            
            guard let data = data else {
                print("Data Task returned an error.")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let searchResult = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = searchResult.results
                completion(nil)
            } catch {
                print("Unable to decode data nto SearchResult object: \(error)")
                completion(error)
            }
            
        }.resume()
        
    }
}

