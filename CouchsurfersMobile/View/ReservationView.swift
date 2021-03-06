//
//  ReservationView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 20..
//

import SwiftUI

struct ReservationView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @StateObject var reservationVM = ReservationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $reservationVM.reservationState, label: Text("State of reservations")) {
                    Text(NSLocalizedString("ReservationView.Active", comment: "Active")).tag(0)
                    Text(NSLocalizedString("ReservationView.Inactive", comment: "Inactive")).tag(1)
                }
                .pickerStyle(.segmented)
                
                Group {
                    if reservationVM.filteredReservationPreviews.isEmpty {
                        Spacer()
                        Text(NSLocalizedString("ReservationView.NoReservations", comment: "Nothing comes up here"))
                        Spacer()
                    } else {
                        List(reservationVM.filteredReservationPreviews, id: \.id) { reservationPreview in
                            ZStack {
                                ReservationPreviewView(city: reservationPreview.city,
                                                       name: reservationPreview.name,
                                                       price: reservationPreview.price,
                                                       photoUrl: reservationPreview.couchPhotoId,
                                                       startDate: reservationPreview.startDate,
                                                       endDate: reservationPreview.endDate,
                                                       numberOfGuests: reservationPreview.numberOfGuests)
                                    .padding(.vertical)
                                
                                NavigationLink(destination: ReservationDetailsView(reservationId: reservationPreview.id,
                                                                                   couchId: reservationPreview.couchId,
                                                                                   active: reservationPreview.active!)) {
                                   EmptyView()
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        .listStyle(GroupedListStyle())
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle(NSLocalizedString("ReservationView.Reservations", comment: "Reservations"), displayMode: .large)
            .onAppear {
                reservationVM.loadReservations{ loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                }
            }
        }
    }
}
