//
//  Topic.swift
//  iEdu
//
//  Created by Melisa Ibric on 1/14/21.
//

import SwiftUI

class Topic: ObservableObject {
    @Published var topics: [TopicItem] = []

    func add(item: TopicItem) {
        topics.append(item)
    }

    func remove(item: TopicItem) {
        if let index = topics.firstIndex(of: item) {
            topics.remove(at: index)
        }
    }
}

struct TopicSection: Codable, Identifiable {
    var id: UUID
    var name: String
    var items: [TopicItem]
}

struct TopicItem: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var photoCredit: String
    var price: Int
    var restrictions: [String]
    var description: String

    var mainImage: String {
        name.replacingOccurrences(of: " ", with: "-").lowercased()
    }

    var thumbnailImage: String {
        "\(mainImage)-thumb"
    }

    #if DEBUG
    static let example = TopicItem(id: UUID(), name: "Maple French Toast", photoCredit: "Joseph Gonzalez", price: 6, restrictions: ["G", "V"], description: "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada, which is where all maple syrup in the world comes from. And if you believe that, we have some land to sell you…")
    #endif
}

struct Topic_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
