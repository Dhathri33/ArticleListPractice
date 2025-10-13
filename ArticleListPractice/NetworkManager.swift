//
//  NetworkManagerProtocol.swift
//  ArticleListPractice
//
//  Created by Dhathri Bathini on 10/13/25.
//

import Foundation

protocol NetworkManagerProtocol {
    func getData(from serverUrl: String?) async -> NetworkState
    func parse(data: Data?) -> [ArticleDetails]
    
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    var state: NetworkState = .isLoading
    
    func getData(from serverUrl: String?) async -> NetworkState {
        
        guard let imageUrl = serverUrl, let serverURL = URL(string: imageUrl) else {
            state = .invalidURL
            return state
        }
        
        do {
            let (data, _ ) = try await URLSession.shared.data(from: serverURL)
            state = .success(data)
            return state
        } catch {
            state = .errorFetchingData
            return state
        }
    }
    
    func parse(data: Data?) -> [ArticleDetails] {
        guard let data = data else {
            print("No data to parse")
            return []
        }
        do {
            let decoder = JSONDecoder()
            let fetchedResult = try decoder.decode(ArticleList.self, from: data)
            return fetchedResult.articles
        } catch {
            print(error)
        }
        return []
    }
}
