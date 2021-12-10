//
//  ChatView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 06..
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @ObservedObject var chatVM: ChatViewModel
    
    let chatRoomId: Int
    let myId: Int
    
    init(chatRoomId: Int, myId: Int, chatViewModel: ChatViewModel) {
        self.chatRoomId = chatRoomId
        self.myId = myId
        self.chatVM = chatViewModel
    }
    
    var body: some View {
        VStack {
            List(chatVM.chatMessages, id: \.id) { message in
                MessageView(message: message.content, senderType: message.senderId == myId ? .me : .partner, senderName: message.senderName)
                .listRowSeparator(.hidden)
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            .listStyle(PlainListStyle())
            
            HStack {
                TextEditor(text: $chatVM.message)
                    .frame(height: 100)
                    .border(Color.gray)

                Button(action: { chatVM.sendMessage(senderId: myId) }) {
                    Text(NSLocalizedString("ChatView.Send", comment: "Send"))
                }
                .disabled(chatVM.message.isEmpty)
            }
            .padding()
        }
        .navigationBarTitle(Text(NSLocalizedString("ChatView.Messages", comment: "Messages")), displayMode: .inline)
        .onAppear {
            chatVM.getMessages(chatRoomId: chatRoomId) { loggedIn in
                if !loggedIn {
                    self.globalEnv.userLoggedIn = false
                }
            }
            
            chatVM.registerSocket()
        }
        .onDisappear {
            chatVM.unsubscribe()
            chatVM.disconnect()
        }
    }
}
