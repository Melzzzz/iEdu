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
import SDWebImageSwiftUI

struct ContentView: View {
    
    enum Tab {
        case home, chat, users, add, settings
    }
    
    @StateObject var postViewModel = PostViewModel()
    @State private var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var tabIndex: Tab = ContentView.Tab.home
    @State var show = false
    @State var chat = false
    @State var uid = String()
    @State var name = String()
    @State var pic = String()
    
    let mypic = UserDefaults.standard.value(forKey: "pic") as? String
    
    var body: some View {
        
        NavigationView {
            ZStack {
                NavigationLink(destination: ChatView(name: self.name, pic: self.pic, uid: self.uid, chat: self.$chat), isActive: self.$chat) {
                    Text(String())
                }
                VStack {
                    if status {
                        TabView(selection: $tabIndex) {
                            PostView()
                                .tabItem {
                                    Label("Home", systemImage: "house")
                                }
                                .tag(Tab.home)
                            
                            TopicListView()
                                .tabItem {
                                    Label("Network", systemImage: "person.2")
                                }
                                .tag(Tab.users)
 
                            Text("")
                                .onAppear {
                                    DispatchQueue.main.async {
                                        self.postViewModel.newPost = true
                                    }
                                }.sheet(isPresented: $postViewModel.newPost) {
                                    NewPost(updateId: $postViewModel.updateId)
                                }.tabItem {
                                    Label("Post", systemImage: "plus.circle")
                                }.tag(Tab.add)

                            ChatContentView(show: self.$show, chat: self.$chat, uid: self.$uid, name: self.$name, pic: self.$pic)
                                .environmentObject(MessagesViewModel())
                                .tabItem {
                                    Label("Chat", systemImage: "message")
                                }
                                .tag(Tab.chat)
                            
                            SettingsView()
                                .tabItem {
                                    Label("Settings", systemImage: "gear")
                                }
                                .tag(Tab.settings)
                        }.navigationBarItems(leading:
                                                AnimatedImage(url: URL(string: mypic ?? String()))
                                                .resizable()
                                                .renderingMode(.original)
                                                .frame(width: 30, height: 30)
                                                .clipShape(Circle()),
                                             trailing:
                                                Button(action: {
                                                    DispatchQueue.main.async {
                                                        self.show.toggle()
                                                    }
                                                }, label: {
                                                    Image(systemName: "message.circle").resizable().frame(width: 25, height: 25)
                                                }))
                        .navigationTitle("iEdu")
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
        }.modifier(DarkModeViewModifier())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
