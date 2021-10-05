//
//  SignUpView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import SwiftUI

struct SignUp: View {
    @ObservedObject var signUpVM: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self.signUpVM = viewModel
    }
    
    var body: some View {
        VStack {
            
            VStack(spacing: 13) {
                InputFieldWithImage(text: $signUpVM.signUpDetails.fullName, textFieldPlaceholder: NSLocalizedString("authenticationView.fullNamePlaceholder", comment: "Full Name"), imageSystemName:"person", isSecret: false)
                InputFieldWithImage(text: $signUpVM.signUpDetails.emailAddress, textFieldPlaceholder: NSLocalizedString("authenticationView.emailAddressPlaceholder", comment: "Email address"), imageSystemName:"envelope", isSecret: false)
                InputFieldWithImage(text: $signUpVM.signUpDetails.password, textFieldPlaceholder: NSLocalizedString("authenticationView.passwordPlaceholder", comment: "Password"), imageSystemName:"lock", isSecret: true)
                InputFieldWithImage(text: $signUpVM.signUpDetails.confirmedPassword, textFieldPlaceholder: NSLocalizedString("authenticationView.passwordPlaceholder", comment: "Password"), imageSystemName:"lock", isSecret: true)
            }
            
            Button(action: {
                signUpVM.createNewUser()
            }, label: {
                HStack(spacing: 10) {
                    Text(NSLocalizedString("authenticationView.signUpButton", comment: "Sign up"))
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
                Alert(title: Text(signUpVM.alertTitle), message: Text(signUpVM.alertDescription), dismissButton: .default(Text("Cancel")) {
                    print("Dismiss button pressed")
                })
            })
            
        }
        .padding()
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(viewModel: SignUpViewModel())
    }
}
