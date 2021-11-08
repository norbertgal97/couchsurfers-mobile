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
                    Text(NSLocalizedString("MainTabView.ExploreTabItem", comment: "Explore"))
                }
            
            ReservationView()
                .tabItem {
                    Image(systemName: "bed.double")
                    Text(NSLocalizedString("MainTabView.ReservationsTabItem", comment: "Reservations"))
                }
            
            ChatRoomListView()
                .tabItem {
                    Image(systemName: "message")
                    Text(NSLocalizedString("MainTabView.InboxTabItem", comment: "Inbox"))
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text(NSLocalizedString("MainTabView.ProfileTabItem", comment: "Profile"))
                }
        }
        .accentColor(Color.red)
    }
}
