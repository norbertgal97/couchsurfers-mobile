//
//  ProfileView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @StateObject var profileVM = ProfileViewModel()
    
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
                
                Section(header: Text(NSLocalizedString("ProfileView.AccountSettings", comment: "Account Settings"))) {
                    NavigationLink(destination: PersonalInformationView()) {
                        HStack {
                            Image(systemName: "person")
                                .padding(.trailing, 3)
                            Text(NSLocalizedString("ProfileView.PersonalInformation", comment: "Personal information"))
                        }
                        .foregroundColor(Color.black)
                    }
                    
                    NavigationLink(destination: Text("Notifications...")) {
                        HStack {
                            Image(systemName: "bell")
                                .padding(.trailing, 3)
                            Text(NSLocalizedString("ProfileView.Notifications", comment: "Notifications"))
                        }
                        .foregroundColor(Color.black)
                    }
                }
                
                Section(header: Text(NSLocalizedString("ProfileView.Hosting", comment: "Hosting"))) {
                    NavigationLink(destination: MyCouchView().environmentObject(globalEnv)) {
                        HStack {
                            Image(systemName: "list.dash")
                                .padding(.trailing, 3)
                            Text(NSLocalizedString("ProfileView.ListYourCouch", comment: "List your couch"))
                        }
                        .foregroundColor(Color.black)
                    }
                }
                
                Section {
                    Button(action: {
                        profileVM.logout { loggedIn in
                            if !loggedIn {
                                self.globalEnv.userLoggedIn = false
                            }
                        }
                    }) {
                        Text(NSLocalizedString("ProfileView.LogOut", comment: "Log out"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle(NSLocalizedString("ProfileView.Profile", comment: "Profile"), displayMode: .large)
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

