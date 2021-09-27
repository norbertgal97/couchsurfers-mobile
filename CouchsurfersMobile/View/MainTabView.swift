//
//  MainTabView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("Tab 1")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(NSLocalizedString("exploreTabItem", comment: "Explore"))
                }
            
            
            Text("Tab 2")
                .tabItem {
                    Image(systemName: "bed.double")
                    Text(NSLocalizedString("couchesTabItem", comment: "Couches"))
                }
            
            Text("Tab 3")
                .tabItem {
                    Image(systemName: "message")
                    Text(NSLocalizedString("inboxTabItem", comment: "Inbox"))
                }
            
            NavigationView {
                ProfileView()
                    //.navigationTitle("")
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "person")
                Text(NSLocalizedString("profileTabItem", comment: "Profile"))
            }
        }
        .accentColor(Color.red)
    }
}
