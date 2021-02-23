//
//  PostRow.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/22/21.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct PostRow: View {
    
    var post: Post
    @ObservedObject var postViewModel: PostViewModel
    let uid = Auth.auth().currentUser!.uid
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    var body: some View {
        
        VStack(spacing: 15) {
            
            HStack(spacing: 10) {
                WebImage(url: URL(string: post.user.pic)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                Text(post.user.name)
                    .fontWeight(.bold)
                
                Spacer(minLength: 0)
                
                if post.user.id == uid {
                    Menu(content: {
                        Button(action: { postViewModel.editPost(id: post.id) }) {
                            Text("Edit")
                        }
                        
                        Button(action: { postViewModel.deletePost(id: post.id) }) {
                            Text("Delete")
                        }
                    }, label: {
                        Image(systemName: "ellipsis")
                            .renderingMode(.template)
                    })
                }
            }
            
            if post.pic != String() {
                WebImage(url: URL(string: post.pic)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 60, height: 250)
                    .cornerRadius(15)
            }
            
            HStack {
                Text(post.title)
                    .fontWeight(.bold)
                
                Spacer(minLength: 0)
            }.padding(.top, 5)
            
            HStack {
                Spacer(minLength: 0)
                
                Text(post.time, style: .time)
                    .fontWeight(.bold)
                    .font(.caption)
            }
        }.padding()
        .background(isDarkMode ? Color.white.opacity(0.06) : Color.black.opacity(0.06))
        .cornerRadius(15)
    }
}
