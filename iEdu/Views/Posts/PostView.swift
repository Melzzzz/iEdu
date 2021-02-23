//
//  PostView.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/22/21.
//

import SwiftUI

struct PostView: View {
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @StateObject var postViewModel = PostViewModel()
    
    var body: some View {
        VStack {
            if postViewModel.posts.isEmpty {
                Spacer(minLength: 0)
                
                if postViewModel.noPosts {
                    Text("No Posts!")
                } else {
                    ProgressView()
                }
                
                Spacer(minLength: 0)
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(postViewModel.posts) { post in
                            PostRow(post: post, postViewModel: postViewModel)
                        }
                    }.padding()
                    .padding(.bottom, 55)
                }
            }
        }.fullScreenCover(isPresented: $postViewModel.newPost) {
            NewPost(updateId: $postViewModel.updateId)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
