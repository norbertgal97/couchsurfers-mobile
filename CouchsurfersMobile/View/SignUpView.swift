//
//  SignUpView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import SwiftUI

struct SignUp: View {
    @ObservedObject private var signUpVM = SignUpViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 13) {
                InputFieldWithImage(text: $signUpVM.signUpDetails.fullName, textFieldPlaceholder: NSLocalizedString("SignUpView.FullNamePlaceholder", comment: "Full Name"), imageSystemName:"person", isSecret: false)
                InputFieldWithImage(text: $signUpVM.signUpDetails.emailAddress, textFieldPlaceholder: NSLocalizedString("SignUpView.EmailAddressPlaceholder", comment: "Email address"), imageSystemName:"envelope", isSecret: false)
                InputFieldWithImage(text: $signUpVM.signUpDetails.password, textFieldPlaceholder: NSLocalizedString("SignUpView.PasswordPlaceholder", comment: "Password"), imageSystemName:"lock", isSecret: true)
                InputFieldWithImage(text: $signUpVM.signUpDetails.confirmedPassword, textFieldPlaceholder: NSLocalizedString("SignUpView.ConfirmPasswordPlaceholder", comment: "Confirm password"), imageSystemName:"lock", isSecret: true)
            }
            
            Button(action: {
                signUpVM.createNewUser()
            }, label: {
                HStack(spacing: 10) {
                    Text(NSLocalizedString("SignUpView.SignUpButton", comment: "Sign up"))
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
                .alert(isPresented: $signUpVM.showingAlert, content: {
                    Alert(title: Text(signUpVM.alertTitle), message: Text(signUpVM.alertDescription),
                          dismissButton: .default(Text(NSLocalizedString("SignUpView.Cancel", comment: "Cancel"))) {
                        print("Dismiss button pressed")
                    })
                })
            
        }
        .padding()
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
