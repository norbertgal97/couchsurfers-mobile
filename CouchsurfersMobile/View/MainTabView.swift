//
//  MainTabView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            ExplorationView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(NSLocalizedString("exploreTabItem", comment: "Explore"))
                }
            
            
            ReservationView()
                .tabItem {
                    Image(systemName: "bed.double")
                    Text(NSLocalizedString("couchesTabItem", comment: "Couches"))
                }
            
            Text("Tab 3")
                .tabItem {
                    Image(systemName: "message")
                    Text(NSLocalizedString("inboxTabItem", comment: "Inbox"))
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text(NSLocalizedString("profileTabItem", comment: "Profile"))
                }
        }
        .accentColor(Color.red)
    }
}
