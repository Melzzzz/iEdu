//
//  Home.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/16/20.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import FirebaseFirestore

struct Home : View {
    
    @State var myuid = UserDefaults.standard.value(forKey: "UserName") as! String
    @EnvironmentObject var datas : MainObservable
    @State var show = false
    @State var chat = false
    @State var uid = String()
    @State var name = String()
    @State var pic = String()
    
    var body : some View {
        ZStack {
            NavigationLink(destination: ChatView(name: self.name, pic: self.pic, uid: self.uid, chat: self.$chat), isActive: self.$chat) {
                Text(String())
            }
            
            VStack {
                if self.datas.recents.count == 0 {
                    if self.datas.norecetns {
                        Text("No Chat History")
                    }
                    else {
                        Indicator()
                    }
                }
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(datas.recents.sorted(by: {$0.stamp > $1.stamp})) {i in
                                Button(action: {
                                    self.uid = i.id
                                    self.name = i.name
                                    self.pic = i.pic
                                    self.chat.toggle()
                                }) {
                                    RecentCellView(url: i.pic, name: i.name, time: i.time, date: i.date, lastmsg: i.lastmsg)
                                }
                            }
                        }.padding()
                    }
                }
            }.navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(leading:
                                    
                                    Button(action: {
                                        UserDefaults.standard.set(String(), forKey: "UserName")
                                        UserDefaults.standard.set(String(), forKey: "UID")
                                        UserDefaults.standard.set(String(), forKey: "pic")
                                        
                                        try! Auth.auth().signOut()
                                        
                                        UserDefaults.standard.set(false, forKey: "status")
                                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                    }, label: {
                                        Text("Sign Out")
                                    }), trailing:
                                        Button(action: {
                                            self.show.toggle()
                                        }, label: {
                                            Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25)
                                        })
            )
        }
        .sheet(isPresented: self.$show) {
            NewChatView(name: self.$name, uid: self.$uid, pic: self.$pic, show: self.$show, chat: self.$chat)
        }
    }
}
