//
//  ChatInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 03..
//

import Foundation
import StompClientLib
import os

class ChatInteractor {
    
    let socketManager = WebsocketManager()
    let chatRoomId: Int
    
    private let baseUrl: String
    private let messagesUrl = "/api/v1/messages"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    var delegate: StompClientDelegate?
    
    init(chatRoomId: Int) {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
        self.chatRoomId = chatRoomId
        
        socketManager.delegate = self
    }
    
    func getMessagesForChatRoom(chatRoomId: Int,
                                completionHandler: @escaping (_ chatMessages: [ChatMessage]?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<[ChatMessageDTO]>()
        
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + messagesUrl + "?chat-room-id=\(chatRoomId)")!, method: .GET)
        
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            var message: String?
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    if unwrappedStatusCode == 401 {
                        self.logger.debug("Session has expired!")
                        completionHandler(nil, nil, false)
                        return
                    }
                }
                
                if let unwrappedError = error {
                    if let unwrappedStatusCode = statusCode {
                        switch unwrappedStatusCode {
                        case 404:
                            message = "Chat room is not found"
                        default:
                            message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(nil, message, true)
            case .successful:
                self.logger.debug("Messages are loaded. Count: \(data!.count)")
                completionHandler(self.convertDTOToModel(dtoList: data!), message, true)
            }
        }
    }
    
    func convertDTOToModel(dtoList: [ChatMessageDTO]) -> [ChatMessage] {
        var messagesList = [ChatMessage]()
        
        for dto in dtoList {
            messagesList.append(ChatMessage(id: dto.id, senderId: dto.senderId, senderName: dto.senderName, content: dto.content))
        }
        
        messagesList.sort {
            $0.id > $1.id
        }
        
        return messagesList
    }
    
    private func handleUnmanagedErrors(statusCode: Int?) -> String {
        if let unwrappedStatusCode = statusCode {
            self.logger.debug("Unknown error with status code: \(unwrappedStatusCode)")
            return NSLocalizedString("networkError.unknownError", comment: "Unknown error")
        } else {
            self.logger.debug("Could not connect to the server!")
            return NSLocalizedString("networkError.connectionError", comment: "Connection error")
        }
    }
    
    
    
    
    
    func registerSocket() {
        socketManager.registerSocket()
    }
    
    func disconnect() {
        socketManager.disconnect()
    }
    
    func unsubscribe() {
        socketManager.unsubscribe(chatRoomId: chatRoomId)
    }
    
    func sendMessage(content: String, senderId: Int) {
        socketManager.sendMessage(content: content, senderId: senderId, chatRoomId: chatRoomId)
    }
    
}

extension ChatInteractor: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("Destination : \(destination)")
        print("JSON Body : \(String(describing: jsonBody))")
        print("String Body : \(stringBody ?? "nil")")
        
        if let jsonString = stringBody {
            let data = Data(jsonString.utf8)
            if let jsonData = try? JSONDecoder().decode(ChatMessageDTO.self, from: data) {
                delegate?.appendMessage(message: ChatMessage(id: jsonData.id, senderId: jsonData.senderId, senderName: jsonData.senderName, content: jsonData.content))
            }
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected")
        socketManager.stompClientDidConnect(client: client, chatRoomId: chatRoomId)
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error Send : \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
}
