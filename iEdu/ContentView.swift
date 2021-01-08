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

struct ContentView: View {
    
    @State private var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        VStack {
            if status {
                NavigationView {
                    Home().environmentObject(MainObservable())
                }
            } else {
                NavigationView {
                    Verification()
                }
            }
        }.onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { _ in
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                self.status = status
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
