//
//  MyCouchDetailsView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 20..
//

import SwiftUI

struct MyCouchDetails: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @State private var selectedCity: String = ""
    @State private var cityNameText: String = ""
    @State private var cityId = ""
    
    let couchId: Int?
    
    @ObservedObject var myCouchDetailsVM: MyCouchDetailsViewModel
    @ObservedObject var autocompleteFieldVM = AutocompleteFieldViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Pictures")) {
                ScrollView(.horizontal) {
                    
                    HStack(spacing: 20) {
                        ForEach(myCouchDetailsVM.images, id: \.fileName) { image in
                            Image(uiImage: image.uiImage)
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
                                            
                                            if image.id != nil {
                                              myCouchDetailsVM.imagesToDelete.append(image.id!)
                                            }
                                            
                                        }, alignment: .center)
                        }
                        
                        if myCouchDetailsVM.images.count < 6 {
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
            
            Section(header: Text("Address")) {
                if selectedCity != "" {
                    TextField("City name", text: $selectedCity)
                        .disabled(true)
                        .overlay(
                            HStack {
                                Spacer()
                                if self.selectedCity != "" {
                                    Image(systemName: "xmark.circle.fill")
                                        .onTapGesture {
                                            self.selectedCity = ""
                                        }
                                }
                            }
                                .padding(), alignment: .center)
                } else {
                    AutocompleteField(cityNameText: $cityNameText, autocompleteFieldVM: autocompleteFieldVM)
                        .overlay(
                            HStack {
                                Spacer()
                                if cityNameText != "" {
                                    Image(systemName: "xmark.circle.fill")
                                        .onTapGesture {
                                            self.cityNameText = ""
                                        }
                                }
                            }
                                .padding(), alignment: .center)
                }
                
                if cityNameText != "" {
                    List {
                        ForEach(autocompleteFieldVM.places, id: \.id) { result in
                            Text(result.description)
                                .onTapGesture {
                                    cityNameText = ""
                                    selectedCity = result.description
                                    cityId = result.id
                                }
                        }
                    }
                }
                
                TextField("Zip code", text: $myCouchDetailsVM.myCouch.zipCode)
                    .disabled(cityNameText != "")
                    .listRowBackground(cityNameText != "" ? Color(UIColor.systemGroupedBackground) : Color.white)
                TextField("Street", text: $myCouchDetailsVM.myCouch.street)
                    .disabled(cityNameText != "")
                    .listRowBackground(cityNameText != "" ? Color(UIColor.systemGroupedBackground) : Color.white)
                TextField("Building number", text: $myCouchDetailsVM.myCouch.buildingNumber)
                    .disabled(cityNameText != "")
                    .listRowBackground(cityNameText != "" ? Color(UIColor.systemGroupedBackground) : Color.white)
            }
            
            Section(header: Text("Details")) {
                TextField("Accommodation name", text: $myCouchDetailsVM.myCouch.name)
                TextField("Number of guests", text: $myCouchDetailsVM.myCouch.numberOfGuests)
                    .keyboardType(.numberPad)
                TextField("Number of rooms", text: $myCouchDetailsVM.myCouch.numberOfRooms)
                    .keyboardType(.numberPad)
                TextField("Amenities", text: $myCouchDetailsVM.myCouch.amenities)
                TextField("Price", text: $myCouchDetailsVM.myCouch.price)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("About")) {
                TextEditor(text: $myCouchDetailsVM.myCouch.about)
                    .frame(width: 350, height: 200, alignment: .center)
            }
            
        }
        .navigationBarTitle(Text(NSLocalizedString("couchDetails", comment: "Couch details")))
        .navigationBarItems(trailing: Button(NSLocalizedString("save", comment: "Save")) {
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
                myCouchDetailsVM.loadCouch(with: couchId!) { loggedIn, downloadImage in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                        return
                    }
                    
                    if downloadImage {
                        myCouchDetailsVM.myCouch.couchPhotoIds?.forEach { id in
                            myCouchDetailsVM.downloadImage(photoId: id) { loggedIn in
                                if !loggedIn {
                                    self.globalEnv.userLoggedIn = false
                                }
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $myCouchDetailsVM.showingAlert, content: {
            Alert(title: Text(NSLocalizedString("authenticationView.error", comment: "Error")), message: Text(myCouchDetailsVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("authenticationView.cancel", comment: "Cancel"))) {
                print("Dismiss button pressed")
            })
        })
        .sheet(isPresented: $myCouchDetailsVM.showingImagePicker, onDismiss: getImage) {
            ImagePicker(image: self.$myCouchDetailsVM.pickedImage)
        }
    }
    
    func getImage() {
        guard let image = myCouchDetailsVM.pickedImage else { return }
        myCouchDetailsVM.addImage(image: image)
    }
}
