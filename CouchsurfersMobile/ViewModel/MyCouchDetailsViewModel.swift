//
//  MyCouchDetailsViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 21..
//

import Foundation

class MyCouchDetailsViewModel: ObservableObject {
    @Published var myCouch = Couch()
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    @Published var showingAlert = false
    
    private var savedCouch : Couch?
    private var interactor = MyCouchInteracor()
    
    func saveCouch(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        validateCouchBeforeSave()
        
        interactor.saveCouch(myCouch: myCouch) { couch, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedCouch = couch {
                DispatchQueue.main.async {
                    self.myCouch = unwrappedCouch
                    self.savedCouch = unwrappedCouch
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func updateCouch(with id: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        validateCouchBeforeUpdate()
        
        interactor.updateCouch(with: id, myCouch: myCouch, savedCouch: savedCouch) { couch, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedCouch = couch {
                DispatchQueue.main.async {
                    self.myCouch = unwrappedCouch
                    self.savedCouch = unwrappedCouch
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
        
    }
    
    func loadCouch(with id: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        interactor.loadCouch(with: id) { couch, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedCouch = couch {
                DispatchQueue.main.async {
                    self.myCouch = unwrappedCouch
                    self.savedCouch = unwrappedCouch
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
            
        }
    }
    
    private func updateAlert(with message: String) {
        self.alertDescription = message
        self.showingAlert = true
    }
    
    private func validateCouchBeforeUpdate() {
        if Int(myCouch.numberOfRooms) == nil {
            if let unwrappedSavedCouch = savedCouch {
                myCouch.numberOfRooms = unwrappedSavedCouch.numberOfRooms
            } else {
                myCouch.numberOfRooms = ""
            }
        }
        
        if Int(myCouch.numberOfGuests) == nil {
            if let unwrappedSavedCouch = savedCouch {
                myCouch.numberOfGuests = unwrappedSavedCouch.numberOfGuests
            } else {
                myCouch.numberOfGuests = ""
            }
        }
        
        if Double(myCouch.price) == nil {
            if let unwrappedSavedCouch = savedCouch {
                myCouch.price = unwrappedSavedCouch.price
            } else {
                myCouch.price = ""
            }
        }
    }
    
    private func validateCouchBeforeSave() {
        if Int(myCouch.numberOfRooms) == nil {
            myCouch.numberOfRooms = ""
        }
        
        if Int(myCouch.numberOfGuests) == nil {
            myCouch.numberOfGuests = ""
        }
        
        if Double(myCouch.price) == nil {
            myCouch.price = ""
        }
    }
    
}
