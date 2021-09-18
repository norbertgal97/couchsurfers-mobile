//
//  CouchsurfersMobileApp.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import SwiftUI

@main
struct CouchsurfersMobileApp: App {
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
    
    @Published var sessionId : String? {
        didSet {
            UserDefaults.standard.set(sessionId, forKey: "sessionId")
        }
    }
    
    init() {
        self.userLoggedIn = UserDefaults.standard.object(forKey: "userLoggedIn") as? Bool ?? false
        self.sessionId = UserDefaults.standard.object(forKey: "sessionId") as? String ?? nil
    }
}
