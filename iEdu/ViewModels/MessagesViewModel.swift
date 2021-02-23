//
//  MessagesViewModel.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/18/21.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct Message : Identifiable {
    var id : String
    var msg : String
    var user : String
}


struct Recent : Identifiable {
    var id: String
    var name: String
    var pic: String
    var lastmsg: String
    var time: String
    var date: String
    var stamp: Date
}

class MessagesViewModel: ObservableObject {
    @Published var recents: [Recent] = []
    @Published var norecetns = false
    
    init() {
        getMessages()
    }
    
    func getMessages() {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).collection("recents").order(by: "date", descending: true).addSnapshotListener { (snap, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                self.norecetns = true
                return
            }
            
            if snap!.isEmpty {
                self.norecetns = true
            }
            
            for i in snap!.documentChanges {
                
                if i.type == .added {
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let pic = i.document.get("pic") as! String
                    let lastmsg = i.document.get("lastmsg") as! String
                    let stamp = i.document.get("date") as! Timestamp
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    let date = formatter.string(from: stamp.dateValue())
                    
                    formatter.dateFormat = "hh:mm a"
                    let time = formatter.string(from: stamp.dateValue())
                    
                    self.recents.append(Recent(id: id, name: name, pic: pic, lastmsg: lastmsg, time: time, date: date, stamp: stamp.dateValue()))
                }
                
                if i.type == .modified {
                    
                    let id = i.document.documentID
                    let lastmsg = i.document.get("lastmsg") as! String
                    let stamp = i.document.get("date") as! Timestamp
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    let date = formatter.string(from: stamp.dateValue())
                    
                    formatter.dateFormat = "hh:mm a"
                    let time = formatter.string(from: stamp.dateValue())
                    
                    
                    for j in 0..<self.recents.count{
                        
                        if self.recents[j].id == id{
                            
                            self.recents[j].lastmsg = lastmsg
                            self.recents[j].time = time
                            self.recents[j].date = date
                            self.recents[j].stamp = stamp.dateValue()
                        }
                    }
                }
            }
        }
    }
    
    func sendMessage(user: String, uid: String, pic: String, date: Date, msg: String) {
        
        let db = Firestore.firestore()
        let myuid = Auth.auth().currentUser?.uid
        
        db.collection("users").document(uid).collection("recents").document(myuid!).getDocument { [self] (snap, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                // if there is no recents records....
                setRecents(user: user, uid: uid, pic: pic, msg: msg, date: date)
                return
            }
            
            if !snap!.exists {
                setRecents(user: user, uid: uid, pic: pic, msg: msg, date: date)
            } else {
                updateRecents(uid: uid, lastmsg: msg, date: date)
            }
        }
        
        updateDB(uid: uid, msg: msg, date: date)
    }
    
    func setRecents(user: String, uid: String, pic: String, msg: String, date: Date) {
        
        let db = Firestore.firestore()
        let myuid = Auth.auth().currentUser?.uid
        let myname = UserDefaults.standard.value(forKey: "UserName") as! String
        let mypic = UserDefaults.standard.value(forKey: "pic") as! String
        
        db.collection("users").document(uid).collection("recents").document(myuid!).setData(["name":myname,"pic":mypic,"lastmsg":msg,"date":date]) { (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
        }
        
        db.collection("users").document(myuid!).collection("recents").document(uid).setData(["name":user,"pic":pic,"lastmsg":msg,"date":date]) { (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    private func updateRecents(uid: String, lastmsg: String, date: Date) {
        
        let db = Firestore.firestore()
        let myuid = Auth.auth().currentUser?.uid
        
        db.collection("users").document(uid).collection("recents").document(myuid!).updateData(["lastmsg":lastmsg,"date":date])
        
        db.collection("users").document(myuid!).collection("recents").document(uid).updateData(["lastmsg":lastmsg,"date":date])
    }
    
    private func updateDB(uid: String,msg: String,date: Date) {
        
        let db = Firestore.firestore()
        let myuid = Auth.auth().currentUser?.uid
        
        db.collection("msgs").document(uid).collection(myuid!).document().setData(["msg":msg,"user":myuid!,"date":date]) { (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
        }
        
        db.collection("msgs").document(myuid!).collection(uid).document().setData(["msg":msg,"user":myuid!,"date":date]) { (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
        }
    }
}
