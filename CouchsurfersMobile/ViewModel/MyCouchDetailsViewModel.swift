//
//  MyCouchDetailsViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 21..
//

import Foundation
import UIKit

class MyCouchDetailsViewModel: GooglePlacesViewModel {
    @Published var myCouch = Couch()
    
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    @Published var showingAlert = false
    
    @Published var showingImagePicker = false
    @Published var pickedImage: UIImage?
    
    private var savedCouch : Couch?
    private var interactor = MyCouchInteractor()
    private var couchInteractor = MyCouchInteractor()
    
    @Published var imagesToUpload = [CouchPhoto]()
    @Published var images = [CouchPhoto]()
    var imagesToDelete = [Int]()
    
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
                    
                    self.reverseCity(cityId: self.myCouch.city) { reversedCity in
                        self.selectedCity = reversedCity
                    }
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
                    
                    self.reverseCity(cityId: self.myCouch.city) { reversedCity in
                        self.selectedCity = reversedCity
                    }
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
        
    }
    
    func loadCouch(with id: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        interactor.loadCouch(with: id) { couch, message, loggedIn, downloadImage in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedCouch = couch {
                DispatchQueue.main.async {
                    self.myCouch = unwrappedCouch
                    self.savedCouch = unwrappedCouch
                    
                    self.reverseCity(cityId: self.myCouch.city) { reversedCity in
                        self.selectedCity = reversedCity
                    }
                    
                    if !unwrappedCouch.couchPhotos.isEmpty {
                        self.images = unwrappedCouch.couchPhotos
                    }

                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
            
        }
    }
    
    func uploadImages(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        if self.myCouch.id == nil {
            completionHandler(true)
            return
        }
        
        if imagesToUpload.isEmpty {
            completionHandler(true)
            return
        }
        
        couchInteractor.uploadImages(couchId: self.myCouch.id!, images: imagesToUpload) { imageUploads, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedImageUploads = imageUploads {
                DispatchQueue.main.async {
                    unwrappedImageUploads.forEach { imageUpload in
                        self.imagesToUpload.removeAll { $0.fileName == imageUpload.fileName }
                        self.images.append(CouchPhoto(id: imageUpload.id, fileName: imageUpload.fileName, url: imageUpload.url, uiImage: nil))
                    }

                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func deleteImages(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        if self.myCouch.id == nil || self.imagesToDelete.isEmpty {
            completionHandler(true)
            return
        }
        
        couchInteractor.deleteImages(couchId: self.myCouch.id!, imageIds: imagesToDelete) { message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func addImage(image: UIImage) {
        imagesToUpload.append(CouchPhoto(uiImage: image))
    }
    
    func getImage() {
        guard let image = pickedImage else { return }
        addImage(image: image)
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
