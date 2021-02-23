//
//  TopicListView.swift
//  iEdu
//
//  Created by Melisa Ibric on 1/14/21.
//

import SwiftUI

struct TopicListView: View {
    let menu = Bundle.main.decode([TopicSection].self, from: "menu.json")
    
    var body: some View {
        List {
            ForEach(menu) { section in
                Section(header: Text(section.name)) {
                    ForEach(section.items) { item in
                        ItemRow(item: item)
                    }
                }
            }
        }
    }
}

struct TopicListView_Previews: PreviewProvider {
    static var previews: some View {
        TopicListView()
    }
}
