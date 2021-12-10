//
//  PersonalInformationView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 24..
//

import SwiftUI

struct PersonalInformationView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @StateObject var personalInformationVM = PersonalInformationViewModel()
    
    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("PersonalInformationView.Image", comment: "Image"))) {
                if let image = personalInformationVM.image.url {
                    KingFisherImage(url: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            Image(systemName: "trash")
                                .font(.title)
                                .padding(.all, 5)
                                .foregroundColor(Color.red)
                                .background(Color.black)
                                .clipShape(Circle())
                                .onLongPressGesture {
                                    personalInformationVM.imageToDelete = personalInformationVM.image.id
                                    personalInformationVM.image.url = nil
                                }, alignment: .center)
                        .listRowBackground(Color.clear)
                } else if let uiImage = personalInformationVM.imageToUpload?.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            Image(systemName: "trash")
                                .font(.title)
                                .padding(.all, 5)
                                .foregroundColor(Color.red)
                                .background(Color.black)
                                .clipShape(Circle())
                                .onLongPressGesture {
                                    personalInformationVM.imageToUpload = nil
                                }, alignment: .center)
                        .listRowBackground(Color.clear)
                } else {
                    Button(action: {
                        self.personalInformationVM.showingImagePicker = true
                    } ) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
            Section(header: Text(NSLocalizedString("PersonalInformationView.Name", comment: "Name"))) {
                TextField(NSLocalizedString("PersonalInformationView.FullName", comment: "Full name"), text: $personalInformationVM.personalInformation.fullName)
            }
            
            Section(header: Text(NSLocalizedString("PersonalInformationView.Contact", comment: "Contact"))) {
                TextField(NSLocalizedString("PersonalInformationView.PhoneNumber", comment: "Phone number"), text: $personalInformationVM.personalInformation.phoneNumber)
                    .keyboardType(.phonePad)
                Text(personalInformationVM.personalInformation.email)
            }
            
            
        }
        .navigationBarItems(trailing: Button(NSLocalizedString("PersonalInformationView.Save", comment: "Save")) {
            if let unwrappedId = personalInformationVM.personalInformation.id {
                personalInformationVM.deleteImage { loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                    
                    personalInformationVM.updatePersonalInformation(with: unwrappedId, personalInformationVM.personalInformation) { loggedIn in
                        if !loggedIn {
                            self.globalEnv.userLoggedIn = false
                        }
                        
                        personalInformationVM.uploadImage { loggedIn in
                            if !loggedIn {
                                self.globalEnv.userLoggedIn = false
                            }
                        }
                    }
                }
            }
        })
        .navigationBarTitle(Text(NSLocalizedString("PersonalInformationView.PersonalInformation", comment: "Personal Information")), displayMode: .inline)
        .onAppear {
            personalInformationVM.loadPersonalInformation { loggedIn in
                if !loggedIn {
                    self.globalEnv.userLoggedIn = false
                }
            }
        }
        .sheet(isPresented: $personalInformationVM.showingImagePicker, onDismiss: personalInformationVM.getImage) {
            ImagePicker(image: self.$personalInformationVM.pickedImage)
        }
        
    }
}
