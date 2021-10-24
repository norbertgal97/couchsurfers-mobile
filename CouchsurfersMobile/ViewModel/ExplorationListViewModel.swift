//
//  ExplorationListViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 10..
//

import SwiftUI

class ExplorationListViewModel: ReversePlaceIdProtocol {
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    @Published var showingAlert = false
    @Published var filteredCouches = [CouchPreview]()
    
    private let hostInteractor = HostInteractor()
    
    func filterHostedCouches(couchFilter: CouchFilter, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        hostInteractor.filterHostedCouches(couchFilter: couchFilter) { couchPreviews, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedCouchPreviews = couchPreviews {
                DispatchQueue.main.async {
                    self.updatePreviewsWithReversedCity(previews: unwrappedCouchPreviews, cityId: couchFilter.city) { couches in
                        self.filteredCouches = couches
                    }
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
        
    }
    
    private func updatePreviewsWithReversedCity(previews: [CouchPreview], cityId: String, completionHandler: @escaping (_ couches: [CouchPreview]) -> Void) {
        var couchPreviews = previews
        
        self.reverseCity(cityId: cityId) { reversedCity in
            for i in couchPreviews.indices {
                couchPreviews[i].city = reversedCity
            }
            
            completionHandler(couchPreviews)
        }
    }
    
    private func updateAlert(with message: String) {
        self.alertDescription = message
        self.showingAlert = true
    }
    
}
