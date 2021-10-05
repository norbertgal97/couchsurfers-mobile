//
//  MyCouchDetailsViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 21..
//

import Foundation
import UIKit

class MyCouchDetailsViewModel: ObservableObject {
    @Published var myCouch = Couch()
    
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    @Published var showingAlert = false
    
    @Published var showingImagePicker = false
    @Published var pickedImage: UIImage?
    
    private var savedCouch : Couch?
    private var interactor = MyCouchInteractor()
    private var couchInteractor = MyCouchInteractor()
    
    
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
    
    func loadCouch(with id: Int, completionHandler: @escaping (_ loggedIn: Bool, _ downloadImage: Bool) -> Void) {
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
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn, downloadImage)
            }
            
        }
    }
    
    func downloadImage(photoId: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        if self.myCouch.id == nil {
            completionHandler(true)
            return
        }
        
        couchInteractor.downloadImage(couchId: self.myCouch.id!, imageId: photoId) { image, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedImage = image {
                DispatchQueue.main.async {
                    self.images.append(unwrappedImage)
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
        
        let uploadableImages = images.filter { $0.id == nil }
        
        if uploadableImages.isEmpty {
            completionHandler(true)
            return
        }
        
        couchInteractor.uploadImages(couchId: self.myCouch.id!, images: uploadableImages) { fileUploads, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedfileUploads = fileUploads {
                DispatchQueue.main.async {
                    unwrappedfileUploads.forEach { fileUpload in
                        for i in 0..<self.images.count {
                            if self.images[i].fileName == fileUpload.fileName {
                                self.images[i].id = fileUpload.couchPhotoId
                            }
                        }
                    }
                    
                    self.images.removeAll { $0.id == nil }
                    
                    var fileUploadIds = unwrappedfileUploads.map { $0.couchPhotoId }
                    
                    if let unwrappedIds = self.myCouch.couchPhotoIds {
                        fileUploadIds.append(contentsOf: unwrappedIds)
                    }
                    
                    self.images.removeAll{ !fileUploadIds.contains($0.id!)}
                    
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
        images.append(CouchPhoto(uiImage: image))
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
