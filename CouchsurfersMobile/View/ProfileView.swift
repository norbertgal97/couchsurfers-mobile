//
//  ProfileView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation
import SwiftUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @ObservedObject var profileVM = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                
                if let url = profileVM.profileData.userPhoto?.url {
                    VStack {
                        KingFisherImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(maxWidth: 150, maxHeight: 150, alignment: .center)
                        
                        Text(profileVM.profileData.fullName)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                    
                }
                
                
                Section(header: Text("Account settings")) {
                    NavigationLink(destination: PersonalInformationView()) {
                        HStack {
                            Image(systemName: "person")
                                .padding(.trailing, 3)
                            Text(NSLocalizedString("profileView.pInformation", comment: "Personal information"))
                        }
                        .foregroundColor(Color.black)
                    }
                    
                    NavigationLink(destination: Text("")) {
                        HStack {
                            Image(systemName: "bell")
                                .padding(.trailing, 3)
                            Text(NSLocalizedString("profileView.notifications", comment: "Notifications"))
                        }
                        .foregroundColor(Color.black)
                    }
                }
                
                Section(header: Text("Hosting")) {
                    NavigationLink(destination: MyCouchView().environmentObject(globalEnv)) {
                        HStack {
                            Image(systemName: "list.dash")
                                .padding(.trailing, 3)
                            Text(NSLocalizedString("profileView.listYourCouch", comment: "List your couch"))
                        }
                        .foregroundColor(Color.black)
                    }
                }
                
                Section {
                    Button(action: {
                        //
                    }) {
                        Text(NSLocalizedString("profileView.logOut", comment: "Log out"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle("Profile", displayMode: .large)
            .onAppear {
                profileVM.loadProfileData { loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                }
            }
            .environmentObject(globalEnv)
            
        }
    }
}

