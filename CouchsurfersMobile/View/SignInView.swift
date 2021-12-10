//
//  SignInView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import SwiftUI

struct SignIn: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @StateObject private var signInVM = SignInViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 13) {
                InputFieldWithImage(text: $signInVM.signInDetails.emailAddress, textFieldPlaceholder: NSLocalizedString("SignInView.EmailAddressPlaceholder", comment: "Email address"), imageSystemName:"envelope", isSecret: false)
                InputFieldWithImage(text: $signInVM.signInDetails.password, textFieldPlaceholder: NSLocalizedString("SignInView.PasswordPlaceholder", comment: "Password"), imageSystemName:"lock", isSecret: true)
            }
            
            Button(action: {}, label: {
                Text(NSLocalizedString("SignInView.ForgottenPasswordButton", comment: "Forgotten password?"))
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)
            
            Button(action: {
                signInVM.signInUser() { loggedIn in
                    if loggedIn {
                        DispatchQueue.main.async {
                            self.globalEnv.userLoggedIn = loggedIn
                        }
                    }
                }
            }, label: {
                HStack(spacing: 10) {
                    Text(NSLocalizedString("SignInView.SignInButton", comment: "Sign in"))
                        .fontWeight(.heavy)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 24, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .background(Color.black)
                .clipShape(Capsule())
                .shadow(color: Color.red.opacity(0.4), radius: 5, x: 0.0, y: 0.0)
                
                
            })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)
                .alert(isPresented: $signInVM.showingAlert, content: {
                    Alert(title: Text(NSLocalizedString("SignInView.Error", comment: "Error")), message: Text(signInVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("SignInView.Cancel", comment: "Cancel"))) {
                        print("Dismiss button pressed")
                    })
                })
        }
        .padding()
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        let globalEnvironment = GlobalEnvironment()
        
        SignIn()
            .environmentObject(globalEnvironment)
    }
}

