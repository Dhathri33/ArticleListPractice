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
            RowCell(author: article.author, description: article.description, image: article.urlToImage, date: "12323")
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
    var image: String?
    var date: String?
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 10) {
                Text(author ?? "")
                    .foregroundStyle(.blue)
                    .bold()
                Text(description ?? "")
                    .foregroundStyle(.gray)
                HStack() {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.blue)
                    Text(date ?? "")
                        .foregroundStyle(.gray)
                }
            }
            Image(systemName: image ?? "figure.wave")
                .resizable()
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fill)
        }
       
    }
}

#Preview {
    ContentView(articleViewModel: ArticleViewModel())
}
