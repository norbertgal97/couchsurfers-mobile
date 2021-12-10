//
//  MyCouchDetailsView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 20..
//

import SwiftUI

struct MyCouchDetails: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @ObservedObject var myCouchDetailsVM: MyCouchDetailsViewModel
    
    let couchId: Int?
    
    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("MyCouchDetailsView.Pictures", comment: "Pictures"))) {
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(myCouchDetailsVM.images, id: \.fileName) { image in
                            if image.url != nil {
                                KingFisherImage(url: image.url!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 225, height: 150, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(
                                        Image(systemName: "trash")
                                            .font(.title)
                                            .padding(.all, 5)
                                            .foregroundColor(Color.red)
                                            .background(Color.black)
                                            .clipShape(Circle())
                                            .onLongPressGesture {
                                                myCouchDetailsVM.images.removeAll{ $0.fileName == image.fileName }
                                                
                                                if let imageId = image.id {
                                                    myCouchDetailsVM.imagesToDelete.append(imageId)
                                                }
                                                
                                            }, alignment: .center)
                            }
                        }
                        
                        ForEach(myCouchDetailsVM.imagesToUpload, id: \.fileName) { image in
                            if image.uiImage != nil {
                                Image(uiImage: image.uiImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 225, height: 150, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(
                                        Image(systemName: "trash")
                                            .font(.title)
                                            .padding(.all, 5)
                                            .foregroundColor(Color.red)
                                            .background(Color.black)
                                            .clipShape(Circle())
                                            .onLongPressGesture {
                                                myCouchDetailsVM.imagesToUpload.removeAll{ $0.fileName == image.fileName }
                                                
                                            }, alignment: .center)
                            }
                        }
                        
                        if myCouchDetailsVM.images.count + myCouchDetailsVM.imagesToUpload.count < 6 {
                            Button(action: {
                                self.myCouchDetailsVM.showingImagePicker = true
                            } ) {
                                Image(systemName: "plus.circle")
                                    .font(.title)
                            }
                        }
                    }
                }
            }
            
            Section(header: Text(NSLocalizedString("MyCouchDetailsView.Address", comment: "Pictures"))) {
                AutocompleteFieldWithResultsView(cityNameText: $myCouchDetailsVM.cityNameText,
                                                 cityId: $myCouchDetailsVM.myCouch.city,
                                                 places: $myCouchDetailsVM.places,
                                                 selectedCity: $myCouchDetailsVM.selectedCity,
                                                 generateSessionToken: { myCouchDetailsVM.generateSessionToken() },
                                                 autocomplete: { myCouchDetailsVM.autocomplete(cityname: $0) })
                
                Group {
                    TextField(NSLocalizedString("MyCouchDetailsView.ZipCode", comment: "Zip code"), text: $myCouchDetailsVM.myCouch.zipCode)
                    TextField(NSLocalizedString("MyCouchDetailsView.Street", comment: "Street"), text: $myCouchDetailsVM.myCouch.street)
                    TextField(NSLocalizedString("MyCouchDetailsView.BuildingNumber", comment: "Building number"), text: $myCouchDetailsVM.myCouch.buildingNumber)
                }
                .disabled(myCouchDetailsVM.cityNameText != "")
                .listRowBackground(myCouchDetailsVM.cityNameText != "" ? Color(UIColor.systemGroupedBackground) : Color.white)
            }
            
            Section(header: Text(NSLocalizedString("MyCouchDetailsView.Details", comment: "Details"))) {
                TextField(NSLocalizedString("MyCouchDetailsView.AccomodationName", comment: "Accomodation name"), text: $myCouchDetailsVM.myCouch.name)
                TextField(NSLocalizedString("MyCouchDetailsView.NumberOfGuests", comment: "Number of guests"), text: $myCouchDetailsVM.myCouch.numberOfGuests)
                    .keyboardType(.numberPad)
                TextField(NSLocalizedString("MyCouchDetailsView.NumberOfRooms", comment: "Number of rooms"), text: $myCouchDetailsVM.myCouch.numberOfRooms)
                    .keyboardType(.numberPad)
                TextField(NSLocalizedString("MyCouchDetailsView.Amenities", comment: "Number of amenities"), text: $myCouchDetailsVM.myCouch.amenities)
                TextField(NSLocalizedString("MyCouchDetailsView.Price", comment: "Price"), text: $myCouchDetailsVM.myCouch.price)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text(NSLocalizedString("MyCouchDetailsView.About", comment: "About"))) {
                TextEditor(text: $myCouchDetailsVM.myCouch.about)
                    .frame(height: 200)
            }
        }
        .navigationBarTitle(Text(NSLocalizedString("MyCouchDetailsView.CouchDetails", comment: "Couch details")))
        .navigationBarItems(trailing: Button(NSLocalizedString("MyCouchDetailsView.Save", comment: "Save")) {
            if couchId != nil {
                myCouchDetailsVM.deleteImages { loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                    
                    myCouchDetailsVM.updateCouch(with: couchId!) { loggedIn in
                        if !loggedIn {
                            self.globalEnv.userLoggedIn = false
                        }
                        
                        myCouchDetailsVM.uploadImages { loggedIn in
                            if !loggedIn {
                                self.globalEnv.userLoggedIn = false
                            }
                        }
                    }
                }
            } else {
                myCouchDetailsVM.saveCouch { loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                    
                    myCouchDetailsVM.uploadImages { loggedIn in
                        if !loggedIn {
                            self.globalEnv.userLoggedIn = false
                        }
                    }
                }
            }
        })
        .onAppear {
            if couchId != nil {
                myCouchDetailsVM.loadCouch(with: couchId!) { loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                }
            }
        }
        .alert(isPresented: $myCouchDetailsVM.showingAlert, content: {
            Alert(title: Text(NSLocalizedString("CommonView.Error", comment: "Couch details")), message: Text(myCouchDetailsVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("CommonView.Cancel", comment: "Cancel"))) {
                print("Dismiss button pressed")
            })
        })
        .sheet(isPresented: $myCouchDetailsVM.showingImagePicker, onDismiss: myCouchDetailsVM.getImage) {
            ImagePicker(image: self.$myCouchDetailsVM.pickedImage)
        }
    }
    
}
