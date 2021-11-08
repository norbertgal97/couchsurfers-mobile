//
//  ChatRoomInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 05..
//

import Foundation
import os

class ChatRoomInteractor {
    
    private let baseUrl: String
    private let chatRoomUrl = "/api/v1/chat-rooms"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func createChatRoom(chatRoomName: String,
                        recipientEmail: String,
                        completionHandler: @escaping (_ chatRoom: ChatRoom?, _ message: String?, _ loggedIn: Bool) -> Void) {
        
        let chatRoomRequest = ChatRoomRequestDTO(chatRoomName: chatRoomName, recipientEmail: recipientEmail)
        let networkManager = NetworkManager<ChatRoomDTO>()
        
        let urlRequest = networkManager.makeRequest(from: chatRoomRequest, url: URL(string: baseUrl + chatRoomUrl)!, method: .POST)
        
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
                            message = "\(recipientEmail) is not found"
                        case 422:
                            message = "Empty fields"
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
                self.logger.debug("Chat room is loaded with id: \(data!.id)")
                completionHandler(self.convertDTOToModel(dto: data!), message, true)
            }
        }
    }
    
    func getOwnChatRooms(completionHandler: @escaping (_ chatRooms: [ChatRoom]?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<[ChatRoomDTO]>()
        
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + chatRoomUrl + "/own")!, method: .GET)
        
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
                    if statusCode != nil {
                        message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(nil, message, true)
            case .successful:
                self.logger.debug("Chat rooms are loaded. Count: \(data!.count)")
                completionHandler(self.convertDTOListToModelList(dtoList: data!), message, true)
            }
        }
    }
    
    private func convertDTOListToModelList(dtoList: [ChatRoomDTO]) -> [ChatRoom] {
        var chatRoomList = [ChatRoom]()
        
        for dto in dtoList {
            chatRoomList.append(convertDTOToModel(dto: dto))
        }
        
        chatRoomList.sort {
            $0.id > $1.id
        }
        
        return chatRoomList
    }
    
    private func convertDTOToModel(dto: ChatRoomDTO) -> ChatRoom {
        let chatRoom = ChatRoom(id: dto.id, myId: dto.myId, name: dto.chatRoomName, recipientEmail: dto.recipientEmail)
        return chatRoom
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
    
}
