//
//  iEduApp.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/14/20.
//

import SwiftUI
import Firebase

@main
struct iEduApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { (url) in
                    Auth.auth().canHandle(url)
                }
        }
    }
}
