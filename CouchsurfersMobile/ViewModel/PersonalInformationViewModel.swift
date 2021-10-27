//
//  PersonalInformationViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 24..
//

import UIKit
import Kingfisher

class PersonalInformationViewModel: ObservableObject {
    @Published var personalInformation = PersonalInformation()
    @Published var image = UserPhoto()
    
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    @Published var showingAlert = false
    
    @Published var showingImagePicker = false
    @Published var pickedImage: UIImage?
    
    @Published var imageToUpload: UserPhoto?
    @Published var imageToDelete: Int?
    
    private var interactor = UserInteractor()
    
    private var savedPersonalInformation: PersonalInformation?
    
    func loadPersonalInformation(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        interactor.loadPersonalInformation { personalInformation, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedPersonalInformation = personalInformation {
                DispatchQueue.main.async {
                    self.personalInformation = unwrappedPersonalInformation
                    self.savedPersonalInformation = unwrappedPersonalInformation
                    
                    if let unwrappedUserPhoto = unwrappedPersonalInformation.userPhoto {
                        self.image = unwrappedUserPhoto
                    }
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
            
        }
    }
    
    func updatePersonalInformation(with id: Int,_ personalInformation: PersonalInformation, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        if let unwrappedSavedPersonalInformation = savedPersonalInformation {
            self.personalInformation.fullName = unwrappedSavedPersonalInformation.fullName
        }
        
        interactor.updatePersonalInformation(with: id, personalInformation) { personalInformation, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedPersonalInformation = personalInformation {
                DispatchQueue.main.async {
                    self.personalInformation = unwrappedPersonalInformation
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
        
    }
    
    func uploadImage(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        guard let _ = imageToUpload?.uiImage else {
            completionHandler(true)
            return
        }
        
        interactor.uploadImage(image: imageToUpload!) { imageUpload, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedImageUpload = imageUpload {
                DispatchQueue.main.async {
                    guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
                        fatalError()
                    }
                    
                    KingfisherManager.shared.cache.removeImage(forKey: url + unwrappedImageUpload.url!)
                    
                    self.imageToUpload = nil
                    self.image = UserPhoto(id: unwrappedImageUpload.id, fileName: unwrappedImageUpload.fileName, url: unwrappedImageUpload.url, uiImage: nil)
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func deleteImage(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        if self.imageToDelete == nil {
            completionHandler(true)
            return
        }
        
        interactor.deleteImage(imageId: imageToDelete!) { message, loggedIn in
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
    
    private func updateAlert(with message: String) {
        self.alertDescription = message
        self.showingAlert = true
    }
    
    func getImage() {
        guard let image = pickedImage else { return }
        addImage(image: image)
    }
    
    func addImage(image: UIImage) {
        imageToUpload = UserPhoto(uiImage: image)
    }
    
}
