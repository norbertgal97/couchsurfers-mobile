//
//  ReservationDetailsView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 23..
//

import SwiftUI

struct ReservationDetailsView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    @ObservedObject var reservationDetailsVM = ReservationDetailsViewModel()
    
    let reservationId: Int
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
                                Text("No content")
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
                        Text("About your reservation")
                            .fontWeight(.bold)
                        
                        Text("• \(unwrappedReservation.reservationNumberOfGuests) guest(s)")
                        Text("• $\(unwrappedReservation.price) / night / guest")
                        Text("• \(unwrappedReservation.startDate) - \(unwrappedReservation.endDate)")
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading) {
                        Text("What this place offers")
                            .fontWeight(.bold)
                        
                        Text(unwrappedReservation.amenities)
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("About this place")
                            .fontWeight(.bold)
                        
                        Text(unwrappedReservation.about)
                            .multilineTextAlignment(.leading)
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    
                }
                
                
                
                /* if !couchDetailsVM.reserved {
                 Button(action : {
                 couchDetailsVM.reserveCouch(with: couchId!, couchFilter) { loggedIn in
                 if !loggedIn {
                 self.globalEnv.userLoggedIn = false
                 }
                 }
                 }) {
                 Text("Reserve")
                 .foregroundColor(Color.white)
                 .fontWeight(.bold)
                 .frame(maxWidth: .infinity, alignment: .center)
                 .frame(height: 50)
                 .background(Color.red)
                 .clipShape(RoundedRectangle(cornerRadius: 10))
                 }
                 .padding(.horizontal)
                 }*/
                
            }
            
            
        }
        .onAppear {
            reservationDetailsVM.loadReservationDetails(with: reservationId) { loggedIn in
                if !loggedIn {
                    self.globalEnv.userLoggedIn = false
                }
            }
        }
        .navigationBarTitle(Text("Details"), displayMode: .inline)
        
    }
    
}
