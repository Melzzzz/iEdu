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

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView(url: "test.com", name: "John Doe", about: "something about me")
    }
}
