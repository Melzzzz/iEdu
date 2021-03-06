//
//  ChatView.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/19/20.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct ChatView : View {
    
    var name : String
    var pic : String
    var uid : String
    @Binding var chat : Bool
    @State var messages: [Message] = []
    @State var txt = String()
    @State var noMessages = false
    
    var messagesViewModel = MessagesViewModel()
    
    var body : some View {
        VStack {
            if messages.count == 0 {
                if self.noMessages {
                    Text("Start New Conversation !!!").foregroundColor(Color.black.opacity(0.5)).padding(.top)
                    Spacer()
                } else {
                    Spacer()
                    Indicator()
                    Spacer()
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(self.messages) { i in
                            HStack {
                                if i.user == UserDefaults.standard.value(forKey: "UID") as! String {
                                    Spacer()
                                    Text(i.msg)
                                        .padding()
                                        .background(Color.blue)
                                        .clipShape(ChatBubble(mymsg: true))
                                } else {
                                    Text(i.msg)
                                        .padding()
                                        .background(Color.green)
                                        .clipShape(ChatBubble(mymsg: false))
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            
            HStack {
                TextField("Enter Message", text: self.$txt).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    messagesViewModel.sendMessage(user: self.name, uid: self.uid, pic: self.pic, date: Date(), msg: self.txt)
                    self.txt = String()
                }) {
                    Text("Send")
                }
            }
            .navigationBarTitle(self.name, displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.chat.toggle()
            }, label: {
                Image(systemName: "arrow.left").resizable().frame(width: 20, height: 15)
            }))
        }.padding()
        .onAppear {
            self.getMessages()
        }
    }
    
    func getMessages() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("msgs").document(uid!).collection(self.uid).order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                self.noMessages = true
                return
            }
            
            if snap!.isEmpty {
                self.noMessages = true
            }
            
            for i in snap!.documentChanges {
                
                if i.type == .added {
                    let id = i.document.documentID
                    let msg = i.document.get("msg") as! String
                    let user = i.document.get("user") as! String
                    
                    self.messages.append(Message(id: id, msg: msg, user: user))
                }
            }
        }
    }
}
