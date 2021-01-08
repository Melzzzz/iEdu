//
//  GetAllUsers.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/19/20.
//

import Foundation
import FirebaseFirestore

class GetAllUsers : ObservableObject {
    
    @Published var users: [User] = []
    @Published var empty = false
    
    init() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snap, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                self.empty = true
                return
            }
            
            if (snap?.documents.isEmpty)! {
                self.empty = true
                return
            }
            
            for i in snap!.documents {
                
                let id = i.documentID
                let name = i.get("name") as! String
                let pic = i.get("pic") as! String
                let about = i.get("about") as! String
                
                if id != UserDefaults.standard.value(forKey: "UID") as! String{
                    self.users.append(User(id: id, name: name, pic: pic, about: about))
                }
            }
            
            if self.users.isEmpty {
                self.empty = true
            }
        }
    }
}
