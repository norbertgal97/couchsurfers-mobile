//
//  MyCouchView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 20..
//

import Foundation
import SwiftUI

struct MyCouchView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @ObservedObject private var myCouchVM = MyCouchViewModel()
    
    var body: some View {
        Group {
            if myCouchVM.hostedCouch.id != nil {
                ScrollView {
                    if let uiImage = myCouchVM.hostedCouch.image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    } else {
                        Text("No content")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: 300, alignment: .center)
                            .background(Color.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("\(myCouchVM.hostedCouch.name)")
                            .font(.custom("Pacifico-Regular", size: 25))
                            .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        if !myCouchVM.hostedCouch.about.isEmpty {
                            Text("\(myCouchVM.hostedCouch.about)")
                                .padding(.horizontal)
                        } else {
                            Text("Description")
                                .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        Button(action : {
                            myCouchVM.hostCouch { loggedIn in 
                                if !loggedIn {
                                    self.globalEnv.userLoggedIn = false
                                }
                            }
                        }) {
                            Text(myCouchVM.hostedCouch.hosted ? "Hide your couch" : "Host your couch")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: 50)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                                .background(Color.white)
                        )
                        .padding(.horizontal)
                        
                    }
                }
            } else {
                Text("Nincs elmentve szállás.")
            }
        }
        .navigationBarTitle(Text(NSLocalizedString("myCouch.navigationBarTitle", comment: "My Couch")), displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: MyCouchDetails(couchId: myCouchVM.hostedCouch.id, myCouchDetailsVM: MyCouchDetailsViewModel())) {
            Image(systemName: "square.and.pencil")
                .foregroundColor(Color.red)
        })
        .onAppear() {
            myCouchVM.getOwnHostedCouch { loggedIn, downloadImage in
                if !loggedIn {
                    self.globalEnv.userLoggedIn = false
                    return
                }
                
                if downloadImage {
                    myCouchVM.downloadImage() {loggedIn in
                        if !loggedIn {
                            self.globalEnv.userLoggedIn = false
                        }
                    }
                }
                
            }
        }
        .alert(isPresented: $myCouchVM.showingAlert, content: {
            Alert(title: Text(NSLocalizedString("authenticationView.error", comment: "Error")), message: Text(myCouchVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("authenticationView.cancel", comment: "Cancel"))) {
                print("Dismiss button pressed")
            })
        })
    }
}
