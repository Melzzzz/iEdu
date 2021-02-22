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

struct ChatContentView : View {
    
    @State var myuid = UserDefaults.standard.value(forKey: "UserName") as! String
    @EnvironmentObject var messagesViewModel : MessagesViewModel
    @Binding var show : Bool
    @Binding var chat : Bool
    @Binding var uid : String
    @Binding var name : String
    @Binding var pic : String
    
    var body : some View {
        ZStack {
            VStack {
                if self.messagesViewModel.recents.count == 0 {
                    if self.messagesViewModel.norecetns {
                        Text("No Chat History")
                    }
                    else {
                        Indicator()
                    }
                }
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(messagesViewModel.recents.sorted(by: {$0.stamp > $1.stamp})) {i in
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
            }            
        }
    }
}
