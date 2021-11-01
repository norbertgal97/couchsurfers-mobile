//
//  MyCouchView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 20..
//

import SwiftUI

struct MyCouchView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @ObservedObject private var myCouchVM = MyCouchViewModel()
    
    var body: some View {
        Group {
            if myCouchVM.hostedCouch.id != nil {
                ScrollView {
                    if let photoUrl = myCouchVM.hostedCouch.couchPhotoId {
                        KingFisherImage(url: photoUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .frame(maxWidth: UIScreen.main.bounds.size.width)
                            .clipped()
                    } else {
                        Text("No content")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: 300, alignment: .center)
                            .background(Color.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("\(myCouchVM.hostedCouch.name)")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        if !myCouchVM.hostedCouch.about.isEmpty {
                            Text("\(myCouchVM.hostedCouch.about)")
                                .padding(.horizontal)
                        } else {
                            Text("Description")
                                .padding(.horizontal)
                        }
                        
                        Button(action : {
                            myCouchVM.hostCouch { loggedIn in
                                if !loggedIn {
                                    self.globalEnv.userLoggedIn = false
                                }
                            }
                        }) {
                            Text(myCouchVM.hostedCouch.hosted ? "Hide your couch" : "Host your couch")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: 50)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        Group {
                            Text("Reservations")
                                .fontWeight(.bold)
                                .font(.title)
                                .padding(.horizontal)
                            
                            Button(action : {
                                myCouchVM.isShowingUserReservationsListView = true
                            }) {
                                Text("Show all reservations")
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
                            
                            NavigationLink(destination: UserReservationListView(userReservations: myCouchVM.hostedCouch.reservations), isActive: $myCouchVM.isShowingUserReservationsListView) { EmptyView() }
                        }
                        
                        Divider()
                        
                        Group {
                            Text("Reviews")
                                .fontWeight(.bold)
                                .font(.title)
                                .padding(.horizontal)
                            
                            Button(action : {
                                myCouchVM.isShowingReviewsListView = true
                            }) {
                                Text("Show all reviews")
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
                            
                            NavigationLink(destination: ReviewListView(couchId: myCouchVM.hostedCouch.id!), isActive: $myCouchVM.isShowingReviewsListView) { EmptyView() }
                        }

                    }
                    
                }
            } else {
                Text("Nincs elmentve szállás.")
            }
        }
        .navigationBarTitle(Text(NSLocalizedString("myCouch.navigationBarTitle", comment: "My Couch")), displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: MyCouchDetails(myCouchDetailsVM: MyCouchDetailsViewModel(), couchId: myCouchVM.hostedCouch.id)) {
            Image(systemName: "square.and.pencil")
                .foregroundColor(Color.red)
        })
        .onAppear() {
            myCouchVM.getOwnHostedCouch { loggedIn, downloadImage in
                if !loggedIn {
                    self.globalEnv.userLoggedIn = false
                }
            }
        }
        .alert(isPresented: $myCouchVM.showingAlert, content: {
            Alert(title: Text(NSLocalizedString("authenticationView.error", comment: "Error")), message: Text(myCouchVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("authenticationView.cancel", comment: "Cancel"))) {
                print("Dismiss button pressed")
            })
        })
    }
}
