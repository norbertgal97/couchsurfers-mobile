//
//  UserReservationListView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 30..
//

import SwiftUI

struct UserReservationListView: View {
    
    let userReservations: [UserReservation]
    
    var body: some View {
        if !userReservations.isEmpty {
            List(userReservations, id: \.id) { reservation in
                UserReservationPreviewView(name: reservation.name,
                                           email: reservation.email,
                                           photoUrl: reservation.userPhotoUrl,
                                           startDate: reservation.startDate,
                                           endDate: reservation.endDate,
                                           numberOfGuests: reservation.numberOfGuests)
                    .padding(.vertical)
            }
            .listStyle(GroupedListStyle())
        } else {
            Text("There are no reservations")
                .padding(.horizontal)
        }
    }
    
}
