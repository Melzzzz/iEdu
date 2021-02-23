//
//  SettingsView.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/22/21.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var pushNotifications = false
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    var body: some View {
        List {
            Text("Profile")
            Toggle("Push Notifications", isOn: $pushNotifications)
            Toggle("Dark Mode", isOn: $isDarkMode)
            Button(action: {
                UserDefaults.standard.set(String(), forKey: "UserName")
                UserDefaults.standard.set(String(), forKey: "UID")
                UserDefaults.standard.set(String(), forKey: "pic")
                
                try! Auth.auth().signOut()
                
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            }, label: {
                Text("Sign Out")
            })
        }
    }
}

public struct DarkModeViewModifier: ViewModifier {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
