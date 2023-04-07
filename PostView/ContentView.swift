//
//  ContentView.swift
//  PostView
//
//  Created by Willian Santos on 04/07/23.
//

import SwiftUI

struct Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()

    init() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Erro na solicitação.")
                return
            }

            let decodedData = try? JSONDecoder().decode([Post].self, from: data)

            DispatchQueue.main.async {
                self.posts = decodedData ?? []
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var postVM = PostViewModel()

    var body: some View {
        List(postVM.posts, id: \.id) { post in
            VStack(alignment: .leading) {
                Text(post.title)
                    .font(.headline)
                Text(post.body)
                    .font(.subheadline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
