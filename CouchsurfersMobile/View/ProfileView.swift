//
//  ProfileView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @State private var cityNameText: String = ""
    
    //@ObservedObject var profileVM = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("")
                }
                
                Section(header: Text("Account settings")) {
                    NavigationLink(destination: Text("")) {
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
                    NavigationLink(destination: MyCouchView()) {
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
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
