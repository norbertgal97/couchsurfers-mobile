//
//  UserReservationPreview.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 30..
//

import SwiftUI
import Kingfisher

struct UserReservationPreviewView: View {
    var name = ""
    var email = ""
    var photoUrl: String?
    var startDate = ""
    var endDate = ""
    var numberOfGuests = ""
    
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
                        .fontWeight(.bold)
                    Text(email)
                    Text("\(numberOfGuests) guest(s)")
                    Text("\(startDate) - \(endDate)")
                }
                .padding(.horizontal)
                .frame(width: 350, height: 100, alignment: .leading)
                
                Spacer()
            }
            
        }
        .frame(width: 350, height: 300)
    }
}
