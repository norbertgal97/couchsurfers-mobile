//
//  InputFieldWithImage.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 09. 30..
//

import SwiftUI

struct InputFieldWithImage: View {
    @Binding var text: String
    
    let textFieldPlaceholder: String
    let imageSystemName: String
    let isSecret: Bool
    
    var body: some View {
        HStack {
            Image(systemName: imageSystemName)
                .frame(width: 50, height: 50)
                .scaleEffect(1.3)
                .foregroundColor(.black)
            
            if isSecret {
                SecureField(textFieldPlaceholder, text: $text)
                    .autocapitalization(.none)
            } else {
                TextField(textFieldPlaceholder, text: $text)
                    .autocapitalization(.none)
            }
        }
        .frame(width: 350, height: 50)
        .background(
            RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 2)
                .background(Color.white)
        )
    }
}

struct InputFieldWithImage_Previews: PreviewProvider {
    @State static var name = ""
    
    static var previews: some View {
        InputFieldWithImage(text: $name, textFieldPlaceholder: "Placeholder", imageSystemName:"lock", isSecret: true)
    }
}
