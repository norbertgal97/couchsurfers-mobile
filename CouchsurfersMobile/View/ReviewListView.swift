//
//  ReviewListView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 31..
//

import SwiftUI

struct ReviewListView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment

    @StateObject var reviewListVM = ReviewListViewModel()
    
    let couchId: Int
    
    var body: some View {
        Group {
            if !reviewListVM.reviews.isEmpty {
                List(reviewListVM.reviews, id: \.id) { review in
                    VStack(alignment: .leading) {
                        Text(review.name)
                            .fontWeight(.bold)
                        
                        Text(review.description)
                    }
                }
                .listStyle(GroupedListStyle())
            } else {
                Text(NSLocalizedString("ReviewList.NoReservations", comment: "No reservations"))
                    .padding(.horizontal)
            }
        }
        .onAppear {
            reviewListVM.loadReviews(with: couchId) { loggedIn in
                if !loggedIn {
                    self.globalEnv.userLoggedIn = false
                }
            }
        }
        .navigationBarTitle(Text(NSLocalizedString("ReviewList.Reviews", comment: "Reviews")), displayMode: .inline)
    }
}
