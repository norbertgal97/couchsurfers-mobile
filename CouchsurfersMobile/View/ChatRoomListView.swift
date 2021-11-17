//
//  ChatRoomListView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 03..
//

import SwiftUI

struct ChatRoomListView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    @ObservedObject var chatRoomListVM = ChatRoomListViewModel()
    
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
                
                if chatRoomListVM.showPopUp {
                    ZStack {
                        Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                        VStack {
                            Text(NSLocalizedString("ChatRoomListView.AddChatRoom", comment: "Add chat room"))
                                .font(.title)
                            
                            TextField(NSLocalizedString("ChatRoomListView.RoomName", comment: "Room name"), text: $chatRoomListVM.roomName)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                            
                            TextField(NSLocalizedString("ChatRoomListView.Recipient", comment: "Recipient"), text: $chatRoomListVM.recipientEmail)
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
                                    chatRoomListVM.showPopUp = false
                                }, label: {
                                    Text(NSLocalizedString("ChatRoomListView.Add", comment: "Add"))
                                }).padding(.trailing, 80)
                                
                                Button(action: {
                                    chatRoomListVM.showPopUp = false
                                }, label: {
                                    Text(NSLocalizedString("ChatRoomListView.Cancel", comment: "Cancel"))
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
            .navigationBarTitle(Text(NSLocalizedString("ChatRoomListView.ChatRooms", comment: "Chat rooms")), displayMode: .large)
            .toolbar {
                Button(action: {
                    chatRoomListVM.showPopUp = true
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
            .alert(isPresented: $chatRoomListVM.showingAlert, content: {
                Alert(title: Text(NSLocalizedString("CommonView.Error", comment: "Error")), message: Text(chatRoomListVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("CommonView.Cancel", comment: "Cancel"))) {
                    print("Dismiss button pressed")
                })
            })
        }
    }
}
