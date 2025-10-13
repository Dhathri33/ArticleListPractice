//
//  NetworkState.swift
//  ArticleListPractice
//
//  Created by Dhathri Bathini on 10/13/25.
//
import Foundation

enum NetworkState {
    case isLoading
    case invalidURL
    case errorFetchingData
    case noDataFromServer
    case success(Data)
}
