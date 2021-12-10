//
//  ChatRoomListViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 03..
//

import Foundation

class ChatRoomListViewModel: ObservableObject {
    @Published var chatRooms = [ChatRoom]()
    @Published var roomName = ""
    @Published var recipientEmail = ""
    
    @Published var showPopUp = false
    
    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknownError", comment: "Default alert message")
    @Published var showingAlert = false
    
    private var chatRoomInteractor = ChatRoomInteractor()
    
    func createChatRoom(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        chatRoomInteractor.createChatRoom(chatRoomName: roomName, recipientEmail: recipientEmail) { chatroom, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedChatroom = chatroom {
                DispatchQueue.main.async {
                    self.chatRooms.insert(unwrappedChatroom, at: 0)
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func getOwnChatRooms(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        chatRoomInteractor.getOwnChatRooms { chatrooms, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedChatRooms = chatrooms {
                DispatchQueue.main.async {
                    self.chatRooms = unwrappedChatRooms
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
}
