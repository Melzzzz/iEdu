//
//  NewPostViewModel.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/22/21.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftUI

class NewPostViewModel: ObservableObject {
    
    @Published var postTxt = String()
    @Published var picker = false
    @Published var imgData = Data(count: 0)
    @Published var isPosting = false
    
    let uid = Auth.auth().currentUser!.uid
    
    func post(updateId: String, present: Binding<PresentationMode>) {
        isPosting = true
        
        if updateId != String() {
            ref.collection("Posts").document(updateId).updateData([
                "title": postTxt
            ]) { err in
                self.isPosting = false
                if err != nil { return }
                
                present.wrappedValue.dismiss()
            }
            return
        }
        
        if imgData.count == 0 {
            ref.collection("Posts").document().setData([
                "title": self.postTxt,
                "url": String(),
                "ref": ref.collection("users").document(self.uid),
                "time": Date()
            ]) { err in
                if err != nil {
                    self.isPosting = false
                    return
                }
                
                self.isPosting = false
                present.wrappedValue.dismiss()
            }
        } else {
            UploadImage(imageData: imgData, path: "post_Pics") { url in
                ref.collection("Posts").document().setData([
                    "title": self.postTxt,
                    "url": url,
                    "ref": ref.collection("users").document(self.uid),
                    "time": Date()
                ]) { err in
                    if err != nil {
                        self.isPosting = false
                        return
                    }
                    
                    self.isPosting = false
                    present.wrappedValue.dismiss()
                }
            }
        }
    }
}
