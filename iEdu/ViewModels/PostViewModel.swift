//
//  PostViewModel.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/22/21.
//

import Foundation
import Firebase

class PostViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var noPosts = false
    @Published var newPost = false
    @Published var updateId = String()
    
    let ref = Firestore.firestore()
    
    init() {
        getAllPosts()
    }
    
    func getAllPosts() {
        ref.collection("Posts").addSnapshotListener { (snap, err) in
            guard let docs = snap else {
                self.noPosts = true
                return
            }
            
            if docs.documents.isEmpty {
                self.noPosts = true
                return
            }
            
            docs.documentChanges.forEach { doc in
                if doc.type == .added {
                    let title = doc.document.data()["title"] as! String
                    let time = doc.document.data()["time"] as! Timestamp
                    let pic = doc.document.data()["url"] as! String
                    let userRef = doc.document.data()["ref"] as! DocumentReference
                    
                    self.fetchUser(uid: userRef.documentID) { user in
                        self.posts.append(Post(id: doc.document.documentID, title: title, pic: pic, time: time.dateValue(), user: user))
                        
                        self.posts.sort { (p1, p2) -> Bool in
                            return p1.time > p2.time
                        }
                    }
                }
                
                if doc.type == .removed {
                    let id = doc.document.documentID
                    self.posts.removeAll { post -> Bool in
                        return post.id == id
                    }
                }
                
                if doc.type == .modified {
                    print("Updated...")
                    
                    let id = doc.document.documentID
                    let title = doc.document.data()["title"] as! String
                    
                    let index = self.posts.firstIndex { post -> Bool in
                        return post.id == id
                    } ?? -1
                    
                    if index != -1 {
                        self.posts[index].title = title
                        self.updateId = String()
                    }
                }
            }
        }
    }
    
    func deletePost(id: String) {
        ref.collection("Posts").document(id).delete { err in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
        }
    }
    
    func editPost(id: String) {
        updateId = id
        newPost.toggle()
    }
    
    func fetchUser(uid: String, completion: @escaping (User) -> ()) {
        ref.collection("users").document(uid).getDocument { (doc, err) in
            guard let data = doc?.data() else { return }
            
            let name = data["name"] as! String
            let pic = data["pic"] as! String
            let about = data["about"] as! String
            let id = doc!.documentID
            
            DispatchQueue.main.async {
                completion(User(id: id, name: name, pic: pic, about: about))
            }
        }
    }
}
