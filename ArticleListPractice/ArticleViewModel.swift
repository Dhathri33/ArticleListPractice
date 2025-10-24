//
//  ArticleViewModelProtocol.swift
//  ArticleListPractice
//
//  Created by Dhathri Bathini on 10/13/25.
//
import Foundation
import Combine

@MainActor
protocol ArticleViewModelProtocol {
    var articleList: [ArticleDetails] { get set}
    var errorMessage: String { get }
    func getDataFromServer() async
}

@Observable
class ArticleViewModel: ArticleViewModelProtocol {
    
    var articleList: [ArticleDetails] = []
    private let networkManager: NetworkManagerProtocol
    var errorState: NetworkState?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
        
    func getDataFromServer() async {
        let fetchedState = await networkManager.getData(from: Server.endPoint.rawValue)
        switch fetchedState {
        case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
            errorState = fetchedState
        case .success(let fetchedData):
            self.articleList = networkManager.parse(data: fetchedData)
            errorState = nil
        }
        return
    }
    
}

extension ArticleViewModel {
    var errorMessage: String {
        guard let errorState = errorState else { return "" }
        switch errorState {
        case .invalidURL:
            return "Invalid URL"
        case .errorFetchingData:
            return "Error fetching data"
        case .noDataFromServer:
            return "No data from server"
        default :
            return ""
        }
    }
}

