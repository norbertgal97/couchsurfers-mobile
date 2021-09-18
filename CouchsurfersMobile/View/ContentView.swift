//
//  ContentView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    var body: some View {
        if globalEnv.userLoggedIn {
            VStack {
                Text("Logged in")
                Text(globalEnv.sessionId ?? "")
            }
        } else {
            AuthenticationView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GlobalEnvironment())
    }
}
