//
//  ReservationDetailsView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 23..
//

import SwiftUI

struct ReservationDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var globalEnv: GlobalEnvironment
    @ObservedObject var reservationDetailsVM = ReservationDetailsViewModel()
    
    let reservationId: Int
    let couchId: Int
    let active: Bool
    
    var body: some View {
        ScrollView {
            if let unwrappedReservation = reservationDetailsVM.reservation {
                if !unwrappedReservation.couchPhotos.isEmpty {
                    TabView {
                        ForEach(unwrappedReservation.couchPhotos, id: \.fileName) { photo in
                            if let photoUrl = photo.url {
                                KingFisherImage(url: photoUrl)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 300)
                                    .frame(maxWidth: UIScreen.main.bounds.size.width)
                                    .clipped()
                            } else {
                                Text(NSLocalizedString("ReservationDetailsView.ImageNotFound", comment: "Image not found"))
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
                        Text(unwrappedReservation.name)
                            .fontWeight(.bold)
                            .font(.title)
                        
                        HStack {
                            Text(unwrappedReservation.city)
                            Text(unwrappedReservation.zipCode)
                        }
                        
                        HStack {
                            Text(unwrappedReservation.street)
                            Text(unwrappedReservation.buildingNumber)
                        }
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("ReservationDetailsView.About", comment: "About"))
                            .fontWeight(.bold)
                        
                        Text("• \(unwrappedReservation.reservationNumberOfGuests) " + NSLocalizedString("ReservationDetailsView.Guests", comment: "Guests"))
                        Text("• $\(unwrappedReservation.price) " + NSLocalizedString("ReservationDetailsView.NightGuest", comment: "Night / Guest"))
                        Text("• \(unwrappedReservation.startDate) - \(unwrappedReservation.endDate)")
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    
                    if !unwrappedReservation.ownerName.isEmpty && !unwrappedReservation.ownerEmail.isEmpty {
                        VStack(alignment: .leading) {
                            Text(String(format: NSLocalizedString("ReservationDetailsView.HostedBy", comment: "Hosted by"), unwrappedReservation.ownerName))
                                .fontWeight(.bold)

                            Text(unwrappedReservation.ownerEmail)
                            
                            Divider()
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("ReservationDetailsView.WhatOffers", comment: "What this place offers"))
                            .fontWeight(.bold)
                        
                        Text(unwrappedReservation.amenities)
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("ReservationDetailsView.About", comment: "About"))
                            .fontWeight(.bold)
                        
                        Text(unwrappedReservation.about)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                }
                
                if active {
                    Button(action : {
                        reservationDetailsVM.cancelReservation(with: reservationId) { loggedIn in
                            if !loggedIn {
                                self.globalEnv.userLoggedIn = false
                            }
                        }
                    }) {
                        Text(NSLocalizedString("ReservationDetailsView.CancelReservation", comment: "Cancel"))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 50)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                    
                    Divider()
                }
                
                Group {
                    Text(NSLocalizedString("ReservationDetailsView.Reviews", comment: "Reviews"))
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action : {
                        reservationDetailsVM.isShowingReviewsListView = true
                    }) {
                        Text(NSLocalizedString("ReservationDetailsView.ShowAllReviews", comment: "Show all reviews"))
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
                    
                    NavigationLink(destination: ReviewListView(couchId: couchId), isActive: $reservationDetailsVM.isShowingReviewsListView) { EmptyView() }
                }
                
                if !active {
                    Group {
                        TextEditor(text: $reservationDetailsVM.description)
                            .frame(height: 100)
                            .background(
                                Rectangle()
                                    .stroke(Color.gray, lineWidth: 2)
                                    .background(Color.white)
                            )
                            .padding()
                        
                        Button(action : {
                            reservationDetailsVM.createReview(with: couchId, description: reservationDetailsVM.description) { loggedIn in
                                if !loggedIn {
                                    self.globalEnv.userLoggedIn = false
                                }
                            }
                        }) {
                            Text(NSLocalizedString("ReservationDetailsView.SendReview", comment: "Send review"))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: 50)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            reservationDetailsVM.loadReservationDetails(with: reservationId) { loggedIn in
                if !loggedIn {
                    self.globalEnv.userLoggedIn = false
                }
            }
        }
        .navigationBarTitle(Text(NSLocalizedString("ReservationDetailsView.Details", comment: "Details")), displayMode: .inline)
        .alert(isPresented: $reservationDetailsVM.showingAlert, content: {
            Alert(title: Text(reservationDetailsVM.alertTitle), message: Text(reservationDetailsVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("CommonView.Cancel", comment: "Cancel"))) {
                print("Dismiss button pressed")
            })
        })
    }
}
