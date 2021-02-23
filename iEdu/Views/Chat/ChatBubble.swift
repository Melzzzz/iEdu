//
//  ChatBubble.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/19/20.
//

import SwiftUI

struct ChatBubble : Shape {
    var mymsg : Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
}
