//
//  ReservationViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 21..
//

import Foundation

class ReservationViewModel: ReversePlaceIdProtocol {
    @Published var reservationPreviews = [ReservationPreview]()
    @Published var reservationState = 0
    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknownError", comment: "Default alert message")
    @Published var showingAlert = false
    
    private var reservationInteractor = ReservationInteractor()
    
    var filteredReservationPreviews : [ReservationPreview] {
        return reservationPreviews.filter {
            switch reservationState {
            case 0:
                return $0.active != nil && $0.active!
            case 1:
                return $0.active != nil && !$0.active!
            default:
                return $0.active != nil
            }
        }
    }
    
    func loadReservations(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        reservationInteractor.loadReservations { reservationPreviews, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedReservationPreviews = reservationPreviews {
                DispatchQueue.main.async {
                    self.reservationPreviews = unwrappedReservationPreviews
                    
                    self.updatePreviewsWithReversedCity(previews: unwrappedReservationPreviews) { reservationPreviews in
                        self.reservationPreviews = reservationPreviews
                    }
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    private func updatePreviewsWithReversedCity(previews: [ReservationPreview], completionHandler: @escaping (_ reservationPreviews: [ReservationPreview]) -> Void) {
        var reservationPreviews = previews
        
        for i in reservationPreviews.indices {
            self.reverseCity(cityId: reservationPreviews[i].city) { reversedCity in
                reservationPreviews[i].city = reversedCity
                
                if i == reservationPreviews.count - 1 {
                    completionHandler(reservationPreviews)
                }
            }
        }
    }
}
