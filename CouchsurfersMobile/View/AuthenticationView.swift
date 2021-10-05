//
//  AuthenticationView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @State var showSignUp = false
    
    var body: some View {
        VStack {
            Text("Couchsurfers")
                .font(.custom("Pacifico-Regular", size: 60))
                .padding(.vertical)
            ZStack {
                if showSignUp {
                    SignUp(viewModel: SignUpViewModel())
                        .transition(.move(edge: .trailing))
                } else {
                    SignIn(viewModel: SignInViewModel())
                        .transition(.move(edge: .trailing))
                }
            }
            
        }
        .frame(maxHeight: .infinity)
        .overlay(
            VStack {
                Divider()
                
                HStack {
                    Text(showSignUp ? NSLocalizedString("authenticationView.alreadyMemberButton", comment: "already have an account") : NSLocalizedString("authenticationView.notMemberButton", comment: "not a member"))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        withAnimation {
                            showSignUp.toggle()
                        }
                    }, label: {
                        Text(showSignUp ? NSLocalizedString("authenticationView.signInButton", comment: "Sign in") : NSLocalizedString("authenticationView.signUpButton", comment: "Sign up"))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                    })
                }
            }
            , alignment: .bottom
        )
        
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
