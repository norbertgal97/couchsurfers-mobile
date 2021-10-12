//
//  ExplorationListView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 10..
//

import SwiftUI

struct ExplorationListView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @StateObject var explorationListVM = ExplorationListViewModel()
    
    let couchFilter: CouchFilter
    
    var body: some View {
        List(explorationListVM.filteredCouches, id: \.id) { couchPreview in
            ZStack {
                
                
                CouchPreviewView(city: couchPreview.city,
                                 name: UUID().uuidString,
                                 price: couchPreview.price,
                                 photoUrl: couchPreview.couchPhotoId)
                    .padding(.vertical)
                NavigationLink(destination: Text("hello")) {
                   EmptyView()
                }.buttonStyle(PlainButtonStyle())
            }
            
            
        }
        .listStyle(GroupedListStyle())
        .onAppear {
            explorationListVM.filterHostedCouches(couchFilter: couchFilter) {loggedIn in
                if !loggedIn {
                    self.globalEnv.userLoggedIn = false
                }
            }
        }
        .navigationBarTitle(Text("Couches"), displayMode: .inline)
    }
    
}
