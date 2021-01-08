//
//  NewChatView.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/19/20.
//

import SwiftUI

struct NewChatView : View {
    
    @ObservedObject var datas = GetAllUsers()
    @Binding var name : String
    @Binding var uid : String
    @Binding var pic : String
    @Binding var show : Bool
    @Binding var chat : Bool
    
    
    var body : some View {
        VStack(alignment: .leading) {
            if self.datas.users.count == 0 {
                if self.datas.empty {
                    Text("No Users Found")
                } else {
                    Indicator()
                }
            } else {
                Text("Select To Chat").font(.title).foregroundColor(Color.black.opacity(0.5))
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(datas.users) { i in
                            Button(action: {
                                self.uid = i.id
                                self.name = i.name
                                self.pic = i.pic
                                self.show.toggle()
                                self.chat.toggle()
                            }) {
                                UserCellView(url: i.pic, name: i.name, about: i.about)
                            }
                        }
                        
                    }
                    
                }
            }
        }.padding()
    }
}
