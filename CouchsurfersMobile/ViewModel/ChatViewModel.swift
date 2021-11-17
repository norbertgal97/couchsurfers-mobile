//
//  ChatViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 07..
//

import Foundation

class ChatViewModel: ObservableObject, StompClientDelegate {
    @Published var chatMessages = [ChatMessage]()
    @Published var message = ""
    
    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknownError", comment: "Default alert message")
    @Published var showingAlert = false
    
    private var chatInteracor: ChatInteractor
    
    init(chatRoomId: Int) {
        self.chatInteracor = ChatInteractor(chatRoomId: chatRoomId)
        self.chatInteracor.delegate = self
    }
    
    func getMessages(chatRoomId: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        chatInteracor.getMessagesForChatRoom(chatRoomId: chatRoomId) { chatMessages, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedChatMessages = chatMessages {
                DispatchQueue.main.async {
                    self.chatMessages = unwrappedChatMessages
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func registerSocket() {
        chatInteracor.registerSocket()
    }
    
    func disconnect() {
        chatInteracor.disconnect()
    }
    
    func unsubscribe() {
        chatInteracor.unsubscribe()
    }
    
    func sendMessage(senderId: Int) {
        chatInteracor.sendMessage(content: message, senderId: senderId)
        message = ""
    }
    
    func appendMessage(message: ChatMessage) {
        chatMessages.insert(message, at: 0)
    }
}

protocol StompClientDelegate {
    func appendMessage(message: ChatMessage)
}
