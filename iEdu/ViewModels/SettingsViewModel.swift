//
//  SettingsViewModel.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/22/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let ref = Firestore.firestore()

class SettingsViewModel {
    let uid = Auth.auth().currentUser!.uid
    @Published var userInfo = User(id: "", name: "", pic: "", about: "")
    
    init() {
        fetchUser(uid: uid) { user in
            self.userInfo = user
        }
    }
    
    func fetchUser(uid: String, completion: @escaping (User) -> ()) {
        ref.collection("users").document(uid).getDocument { (doc, err) in
            guard let data = doc?.data() else { return }
            
            let name = data["name"] as! String
            let id = data["id"] as! String
            let pic = data["pic"] as! String
            let about = data["about"] as! String
            
            DispatchQueue.main.async {
                completion(User(id: id, name: name, pic: pic, about: about))
            }
        }
    }
}
