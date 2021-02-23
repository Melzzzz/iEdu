//
//  UsersViewModel.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/18/21.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class UsersViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var empty = false
    
    init() {
        getAllUsers()
    }
    
    func getAllUsers() {
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
    
    func checkUser(completion: @escaping (Bool, String, String, String) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snap, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documents {
                if i.documentID == Auth.auth().currentUser?.uid {
                    completion(true,
                               i.get("name") as! String,
                               i.documentID,
                               i.get("pic") as! String)
                    return
                }
            }
            
            completion(false, String(), String(), String())
        }
    }
    
    func createUser(name: String, about: String, imagedata: Data, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser?.uid
        
        storage.child("profilepics").child(uid!).putData(imagedata, metadata: nil) { (_, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            storage.child("profilepics").child(uid!).downloadURL { (url, err) in
                
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                
                db.collection("users").document(uid!).setData(["name": name,
                                                               "about": about,
                                                               "pic": "\(url!)",
                                                               "uid": uid!]) { (err) in
                    
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    
                    completion(true)
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    UserDefaults.standard.set(name, forKey: "UserName")
                    UserDefaults.standard.set(uid, forKey: "UID")
                    UserDefaults.standard.set("\(url!)", forKey: "pic")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
            }
        }
    }
}
