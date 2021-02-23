//
//  Post.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/22/21.
//

import Foundation

struct Post: Identifiable {
    var id: String
    var title: String
    var pic: String
    var time: Date
    var user: User
    
    #if DEBUG
    static let example = Post(id: "1", title: "New Post", pic: String(), time: Date(), user: User(id: "1", name: "Name", pic: String(), about: "Something about me"))
    #endif
}
