//
//  ContentView.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/14/20.
//

import SwiftUI
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ContentView: View {
    
    enum Tab {
        case home, chat, users, add, settings
    }
    
    @State private var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var tabIndex: Tab = ContentView.Tab.home
    @State var show = false
    @State var chat = false
    @State var uid = String()
    @State var name = String()
    @State var pic = String()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                NavigationLink(destination: ChatView(name: self.name, pic: self.pic, uid: self.uid, chat: self.$chat), isActive: self.$chat) {
                    Text(String())
                }
                VStack {
                    if status {
                        TabView(selection: $tabIndex) {
                            TopicListView()
                                .tabItem {
                                    Label("Home", systemImage: "house")
                                }
                                .tag(Tab.home)
                            
                            TopicListView()
                                .tabItem {
                                    Label("Network", systemImage: "person.2")
                                }
                                .tag(Tab.users)
                            
                            TopicListView()
                                .tabItem {
                                    Label("Post", systemImage: "plus.circle")
                                }
                                .tag(Tab.add)
                            
                            ChatContentView(show: self.$show, chat: self.$chat, uid: self.$uid, name: self.$name, pic: self.$pic)
                                .environmentObject(MessagesViewModel())
                                .tabItem {
                                    Label("Chat", systemImage: "message")
                                }
                                .tag(Tab.chat)
                            
                            TopicListView()
                                .tabItem {
                                    Label("Settings", systemImage: "gear")
                                }
                                .tag(Tab.settings)
                        }.navigationBarItems(leading:
                                                Button(action: {
                                                    UserDefaults.standard.set(String(), forKey: "UserName")
                                                    UserDefaults.standard.set(String(), forKey: "UID")
                                                    UserDefaults.standard.set(String(), forKey: "pic")
                                                    
                                                    try! Auth.auth().signOut()
                                                    
                                                    UserDefaults.standard.set(false, forKey: "status")
                                                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                                }, label: {
                                                    Text("Sign Out")
                                                }),
                                             trailing:
                                                Button(action: {
                                                    self.show.toggle()
                                                }, label: {
                                                    Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25)
                                                }))
                    } else {
                        Verification()
                    }
                }
            }.onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { _ in
                    let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    self.status = status
                }
            }.sheet(isPresented: self.$show) {
                NewChatView(name: self.$name, uid: self.$uid, pic: self.$pic, show: self.$show, chat: self.$chat)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
