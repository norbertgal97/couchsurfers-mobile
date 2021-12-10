//
//  ExplorationViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 06..
//

import Foundation

class ExplorationViewModel: GooglePlacesViewModel {
    
    @Published var couchFilter = CouchFilter()
    @Published var couchPreview = CouchPreview()
    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknownError", comment: "Default alert message")
    @Published var showingAlert = false
    @Published var showingSheet = false
    @Published var cityId: String = ""
    @Published var isShowingListView = false
    
    private var couchInteractor = CouchInteractor()
    
    private var reversedCity = ""
    
    func getNewestCouch(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        couchInteractor.loadNewestCouch { couch, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedCouch = couch {
                DispatchQueue.main.async {
                    self.reverseCity(cityId: unwrappedCouch.city) { reversedCity in
                        self.updatePreviewWithReversedID(preview: unwrappedCouch, reversedCity: reversedCity)
                    }
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func validateFilter(filter: CouchFilter) -> Bool {
        if filter.city.isEmpty || filter.numberOfGuests.isEmpty {
            self.alertDescription = NSLocalizedString("NetworkError.EmptyFieldsWarning", comment: "Fields can not be empty")
            self.showingAlert = true
            return false
        }
        
        isShowingListView = true
        return true
    }
    
    private func updatePreviewWithReversedID(preview: CouchPreview, reversedCity: String) {
        self.couchPreview.city = reversedCity
        self.couchPreview.id = preview.id
        self.couchPreview.couchPhotoId = preview.couchPhotoId
        self.couchPreview.name = preview.name
        self.couchPreview.price = preview.price
    }
}
