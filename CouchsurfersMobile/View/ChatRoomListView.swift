//
//  ChatRoomListView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 03..
//

import Foundation
import SwiftUI

struct ChatRoomListView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @ObservedObject var chatRoomListVM = ChatRoomListViewModel()
    
    @State private var showPopUp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List(chatRoomListVM.chatRooms, id: \.id) { chatRoom in
                        ZStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text(chatRoom.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(chatRoom.recipientEmail)
                            }
                            NavigationLink(destination: ChatView(chatRoomId: chatRoom.id, myId: chatRoom.myId)) {
                                EmptyView()
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                if showPopUp {
                    ZStack {
                        Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                        VStack {
                            Text("Add chat room")
                                .font(.title)
                            
                            TextField("Room name", text: $chatRoomListVM.roomName)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                            
                            TextField("Recipient", text: $chatRoomListVM.recipientEmail)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                            
                            Spacer()
                            Divider()
                            HStack {
                                Button(action: {
                                    chatRoomListVM.createChatRoom { loggedIn in
                                        if !loggedIn {
                                            self.globalEnv.userLoggedIn = false
                                        }
                                    }
                                    self.showPopUp = false
                                }, label: {
                                    Text("Add")
                                }).padding(.trailing, 80)
                                
                                Button(action: {
                                    self.showPopUp = false
                                }, label: {
                                    Text("Close")
                                })
                            }
                        }
                        .padding()
                        .frame(width: 300, height: 200)
                        .background(Color.white)
                        .cornerRadius(20).shadow(radius: 20)
                    }
                }
            }
            .navigationBarTitle(Text("Chat rooms"), displayMode: .large)
            .toolbar {
                Button(action: {
                    self.showPopUp = true
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(Color.red)
                })
            }
            .onAppear {
                chatRoomListVM.getOwnChatRooms { loggedIn in
                    if !loggedIn {
                        self.globalEnv.userLoggedIn = false
                    }
                }
            }
        }
    }
}
