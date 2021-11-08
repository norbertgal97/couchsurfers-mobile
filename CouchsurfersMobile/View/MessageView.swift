//
//  MessageView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 07..
//

import SwiftUI

struct MessageView: View {
    
    let message: String
    let senderType: SenderType
    let senderName: String
    
    var body: some View {
        VStack(alignment: alignment(senderType), spacing: 2) {
            Text(senderName)
                .font(.footnote)
                .foregroundColor(Color.gray)
            
            HStack {
                Spacer()
                    .frame(height: 0)
            }
            
            Text(message)
                .lineLimit(nil)
                .padding(10)
                .font(.body)
                .background(backgroundColor(senderType))
                .cornerRadius(10)
        }
        .rotationEffect(Angle(degrees: 180))
        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
    }
    
    private func alignment(_ senderType: SenderType) -> HorizontalAlignment {
        switch senderType {
        case .me:
            return .trailing
        case .partner:
            return .leading
        }
    }
    
    private func backgroundColor(_ senderType: SenderType) -> Color {
        switch senderType {
        case .me:
            return Color.red.opacity(0.5)
        case .partner:
            return Color.gray.opacity(0.2)
        }
    }
}
