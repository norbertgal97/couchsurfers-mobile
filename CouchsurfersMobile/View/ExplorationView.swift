//
//  ExplorationView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 06..
//

import SwiftUI

struct ExplorationView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @StateObject var explorationVM = ExplorationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if explorationVM.couchPreview.id != nil {
                    CouchPreviewView(city: explorationVM.couchPreview.city,
                                     name: explorationVM.couchPreview.name,
                                     price: explorationVM.couchPreview.price,
                                     photoUrl: explorationVM.couchPreview.couchPhotoId)
                        .padding(.top)
                }
                
                Spacer()
                
                Button(action : {
                    explorationVM.showingSheet.toggle()
                }) {
                    Text(NSLocalizedString("ExplorationView.ExploreNewPlaces", comment: "Explore"))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .frame(width: 350, height: 50, alignment: .center)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Spacer()
                
                NavigationLink(destination: ExplorationListView(couchFilter: explorationVM.couchFilter), isActive: $explorationVM.isShowingListView) { EmptyView() }
            }
            .navigationBarTitle(NSLocalizedString("ExplorationView.Explore", comment: "Explore"), displayMode: .large)
            .environmentObject(globalEnv)
            .onAppear {
                explorationVM.getNewestCouch { loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                }
            }
        }
        .sheet(isPresented: $explorationVM.showingSheet) {
            ExplorationFormView(places: $explorationVM.places,
                                selectedCity: $explorationVM.selectedCity,
                                cityNameText: $explorationVM.cityNameText,
                                cityId: $explorationVM.cityId,
                                couchFilter: $explorationVM.couchFilter,
                                showingAlert: $explorationVM.showingAlert,
                                alertDescription: $explorationVM.alertDescription,
                                generateSessionToken: { explorationVM.generateSessionToken() },
                                autocomplete: { explorationVM.autocomplete(cityname: $0) },
                                validateFilter: { explorationVM.validateFilter(filter: $0) } )
        }
        .alert(isPresented: $explorationVM.showingAlert, content: {
            Alert(title: Text(NSLocalizedString("CommonView.Error", comment: "Error")), message: Text(explorationVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("CommonView.Cancel", comment: "Cancel"))) {
                print("Dismiss button pressed")
            })
        })
    }
}
