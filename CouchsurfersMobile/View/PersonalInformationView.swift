//
//  PersonalInformationView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 24..
//

import SwiftUI

struct PersonalInformationView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @ObservedObject var personalInformationVM = PersonalInformationViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Image")) {
                if personalInformationVM.image.url != nil {
                    KingFisherImage(url: personalInformationVM.image.url!)
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
                } else if personalInformationVM.imageToUpload?.uiImage != nil {
                    Image(uiImage: personalInformationVM.imageToUpload!.uiImage!)
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
            
            Section(header: Text("Name")) {
                TextField("Full name", text: $personalInformationVM.personalInformation.fullName)
            }
            
            Section(header: Text("Contact")) {
                TextField(NSLocalizedString("number", comment: "Number"), text: $personalInformationVM.personalInformation.phoneNumber)
                    .keyboardType(.phonePad)
                Text(personalInformationVM.personalInformation.email)
            }
            
            
        }
        .navigationBarItems(trailing: Button(NSLocalizedString("save", comment: "Save")) {
            if personalInformationVM.personalInformation.id != nil {
                personalInformationVM.deleteImage { loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                    
                    personalInformationVM.updatePersonalInformation(with: personalInformationVM.personalInformation.id!, personalInformationVM.personalInformation) { loggedIn in
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
        .navigationBarTitle(Text("Personal Information"), displayMode: .inline)
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
