//
//  ContentView.swift
//  ArticleListPractice
//
//  Created by Dhathri Bathini on 10/13/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var articleViewModel: ArticleViewModel
    
    init(articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
    }
    
    var body: some View {
        Text("News")
            .font(.headline)
            .bold()
            .foregroundStyle(.blue)
        
        List(articleViewModel.articleList, id: \.self) { article in
            RowCell(author: article.author, description: article.description, imageURL: article.urlToImage, date: String(article.publishedAt?.prefix(10) ?? ""))
        }
        .listStyle(.insetGrouped)
        .task{
            await articleViewModel.getDataFromServer()
        }
    }
}

struct RowCell: View {
    var author: String?
    var description: String?
    var imageURL: String?
    var date: String?

    @State private var uiImage: UIImage?

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Text(author ?? "")
                    .foregroundStyle(.blue)
                    .bold()
                Text(description ?? "")
                    .foregroundStyle(.gray)
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.blue)
                    Text(date ?? "")
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
            Group {
                if let img = uiImage {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "photo.trianglebadge.exclamationmark.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(8)
        }
        .task(id: imageURL) {
            await fetchImage()
        }
    }
    
    @MainActor
    private func fetchImage() async {
        let state = await NetworkManager.shared.getData(from: imageURL)
        switch state {
        case .success(let data):
            uiImage = UIImage(data: data)
            break
        case .errorFetchingData, .isLoading, .invalidURL, .noDataFromServer:
            uiImage = nil
        }
    }
}

#Preview {
    ContentView(articleViewModel: ArticleViewModel())
}
