//
//  CouchsurfersMobileApp.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import SwiftUI
import UIKit

@main
struct CouchsurfersMobileApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GlobalEnvironment())
        }
    }
}

class GlobalEnvironment: ObservableObject {
    @Published var userLoggedIn : Bool {
        didSet {
            UserDefaults.standard.set(userLoggedIn, forKey: "userLoggedIn")
        }
    }
    
    init() {
        self.userLoggedIn = UserDefaults.standard.object(forKey: "userLoggedIn") as? Bool ?? false
    }
}
