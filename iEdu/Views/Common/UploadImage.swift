//
//  UploadImage.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/22/21.
//

import Foundation
import Firebase

func UploadImage(imageData: Data, path: String, completion: @escaping (String) -> ()) {
    let storage = Storage.storage().reference()
    let uid = Auth.auth().currentUser!.uid
    
    storage.child(path).child(uid).putData(imageData, metadata: nil) { (_, err) in
        if err != nil {
            completion(String())
            return
        }
    }
    
    storage.child(path).child(uid).downloadURL { (url, err) in
        if err != nil {
            completion(String())
            return
        }
        
        completion("\(url!)")
    }
}
