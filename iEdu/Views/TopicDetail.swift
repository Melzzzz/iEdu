//
//  TopicDetail.swift
//  iEdu
//
//  Created by Melisa Ibric on 1/14/21.
//

import SwiftUI

struct TopicDetail: View {
    var item: TopicItem
    @EnvironmentObject var topic: Topic
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(item.mainImage)
                Text("Photo: \(item.photoCredit)")
                    .padding(4)
                    .background(Color.black)
                    .font(.caption)
                    .foregroundColor(.white)
                    .offset(x: -5, y: -5)
            }
            Text(item.description)
                .padding()
            Spacer()
            
            Button("Order This") {
                self.topic.add(item: self.item)
            }.font(.headline)
        }
        .navigationBarTitle(Text(item.name), displayMode: .inline)
    }
}

struct TopicDetail_Previews: PreviewProvider {
    static var previews: some View {
        let topic = Topic()
        TopicDetail(item: TopicItem.example).environmentObject(topic)
    }
}
