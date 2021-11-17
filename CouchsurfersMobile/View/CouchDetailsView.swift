//
//  CouchDetailsView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 14..
//

import SwiftUI

struct CouchDetailsView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    @ObservedObject var couchDetailsVM = CouchDetailsViewModel()
    
    let couchId: Int?
    let couchFilter: CouchFilter
    
    var body: some View {
        ScrollView {
            if !couchDetailsVM.couch.couchPhotos.isEmpty {
                TabView {
                    ForEach(couchDetailsVM.couch.couchPhotos, id: \.fileName) { photo in
                        if let photoUrl = photo.url {
                            KingFisherImage(url: photoUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .frame(maxWidth: UIScreen.main.bounds.size.width)
                                .clipped()
                        } else {
                            Text(NSLocalizedString("CouchDetailsView.ImageNotFound", comment: "Image not found"))
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: 300, alignment: .center)
                                .background(Color.gray)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 300)
            }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(couchDetailsVM.couch.name)
                        .fontWeight(.bold)
                        .font(.title)
                    
                    HStack {
                        Text(couchDetailsVM.couch.city)
                        Text(couchDetailsVM.couch.zipCode)
                    }
                    
                    HStack {
                        Text(couchDetailsVM.couch.street)
                        Text(couchDetailsVM.couch.buildingNumber)
                    }
                    
                    Divider()
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("CouchDetailsView.Highlights", comment: "Highlights"))
                        .fontWeight(.bold)
                    
                    Text("• \(couchDetailsVM.couch.numberOfGuests) " + NSLocalizedString("CouchDetailsView.Guests", comment: "guests"))
                    Text("• \(couchDetailsVM.couch.numberOfRooms) " + NSLocalizedString("CouchDetailsView.Rooms", comment: "rooms"))
                    Text("• $\(couchDetailsVM.couch.price) " + NSLocalizedString("CouchDetailsView.NightGuest", comment: "night/guest"))
                    
                    Divider()
                }
                .padding(.horizontal)
                
                if !couchDetailsVM.couch.ownerName.isEmpty && !couchDetailsVM.couch.ownerEmail.isEmpty {
                    VStack(alignment: .leading) {
                        Text(String.localizedStringWithFormat(NSLocalizedString("CouchDetailsView.HostedBy", comment: "Hosted by"), couchDetailsVM.couch.ownerName))
                            .fontWeight(.bold)
                        
                        Text(couchDetailsVM.couch.ownerEmail)
                        
                        Divider()
                    }
                    .padding(.horizontal)
                }
                
                
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("CouchDetailsView.WhatOffers", comment: "WhatOffers"))
                        .fontWeight(.bold)
                    
                    Text(couchDetailsVM.couch.amenities)
                    
                    Divider()
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("CouchDetailsView.About", comment: "WhatOffers"))
                        .fontWeight(.bold)
                    
                    Text(couchDetailsVM.couch.about)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                
                if !couchDetailsVM.reserved {
                    Button(action : {
                        couchDetailsVM.reserveCouch(with: couchId!, couchFilter) { loggedIn in
                            if !loggedIn {
                                self.globalEnv.userLoggedIn = false
                            }
                        }
                    }) {
                        Text(NSLocalizedString("CouchDetailsView.Reserve", comment: "Reserve"))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 50)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                Group {
                    Text(NSLocalizedString("CouchDetailsView.Reviews", comment: "Reviews"))
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(.horizontal)
                    
                    Button(action : {
                        couchDetailsVM.isShowingReviewsListView = true
                    }) {
                        Text(NSLocalizedString("CouchDetailsView.ShowAllReviews", comment: "Show all reviews"))
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 50)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                            .background(Color.white)
                    )
                    .padding(.horizontal)
                    
                    NavigationLink(destination: ReviewListView(couchId: couchId!), isActive: $couchDetailsVM.isShowingReviewsListView) { EmptyView() }
                }
            }
        }
        .navigationBarTitle(Text(NSLocalizedString("CouchDetailsView.Details", comment: "Details")), displayMode: .inline)
        .onAppear {
            if couchId != nil {
                couchDetailsVM.loadCouch(with: couchId!) { loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                }
            }
        }
    }
}
