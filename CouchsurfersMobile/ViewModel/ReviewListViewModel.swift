//
//  ReviewListViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 31..
//

import Foundation

class ReviewListViewModel: ObservableObject {
    @Published var reviews = [Review]()

    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknowError", comment: "Default alert message")
    @Published var showingAlert = false
    
    private var reviewInteractor = ReviewInteractor()
    
    func loadReviews(with couchId: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        reviewInteractor.getReviewsForSpecificCouch(with: couchId) { reviews, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedReviews = reviews {
                DispatchQueue.main.async {
                    self.reviews  = unwrappedReviews
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
}
