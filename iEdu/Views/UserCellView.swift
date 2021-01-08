//
//  UserCellView.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/19/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserCellView : View {
    
    var url : String
    var name : String
    var about : String
    
    var body : some View {
        HStack {
            AnimatedImage(url: URL(string: url)!)
                .resizable()
                .renderingMode(.original)
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(name).foregroundColor(.black)
                        Text(about).foregroundColor(.gray)
                    }
                    Spacer()
                }
                Divider()
            }
        }
    }
}

struct User : Identifiable {
    
    var id : String
    var name : String
    var pic : String
    var about : String
}
