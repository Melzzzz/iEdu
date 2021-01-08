//
//  CheckUser.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/16/20.
//

import Foundation
import Firebase
import FirebaseFirestore

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
