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
        Group {
            if explorationListVM.filteredCouches.isEmpty {
                Text("There are no couches.")
            } else {
                List(explorationListVM.filteredCouches, id: \.id) { couchPreview in
                    ZStack {
                        CouchPreviewView(city: couchPreview.city,
                                         name: couchPreview.name,
                                         price: couchPreview.price,
                                         photoUrl: couchPreview.couchPhotoId)
                            .padding(.vertical)
                        NavigationLink(destination: CouchDetailsView(couchId: couchPreview.id, couchFilter: couchFilter)) {
                            EmptyView()
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
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
