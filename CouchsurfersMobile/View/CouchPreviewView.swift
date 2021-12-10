//
//  CouchPreview.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 06..
//

import SwiftUI
import Kingfisher

struct CouchPreviewView: View {
    let city: String
    let name: String
    let price: String
    var photoUrl: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 5)
            
            VStack {
                if photoUrl != nil {
                    KingFisherImage(url: photoUrl!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 200, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                } else {
                    Color.gray
                        .frame(width: 350, height: 200, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                    Text(city)
                    HStack {
                        Text("$\(price)").fontWeight(.bold)
                        Text(NSLocalizedString("CouchPreviewView.Night", comment: "Night"))
                    }
                }
                .padding(.horizontal)
                .frame(width: 350, height: 75, alignment: .leading)
                
                Spacer()
            }
            
        }
        .frame(width: 350, height: 275)
    }
}
