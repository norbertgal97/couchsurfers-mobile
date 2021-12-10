//
//  WebsocketManager.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 03..
//

import Foundation
import StompClientLib

class WebsocketManager {
    
    var delegate: StompClientLibDelegate?
    let socketClient: StompClientLib
    let baseUrl: String
    
    init() {
        self.socketClient = StompClientLib()
        
        guard let url = Bundle.main.object(forInfoDictionaryKey: "SocketBaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func registerSocket() {
        let cookie = HTTPCookieStorage.shared.cookies?.filter({ cookie in
            cookie.name == "JSESSIONID"
        }).first
        
        let url = NSURL(string: baseUrl)!
        let urlRequest = NSMutableURLRequest(url: url as URL)
        urlRequest.allHTTPHeaderFields = [String : String]()
        
        if let sessionId = cookie?.value {
            urlRequest.allHTTPHeaderFields?.updateValue("JSESSIONID=\(sessionId)", forKey: "Cookie")
        }
        
        if let unwrappedDelegate = delegate {
            socketClient.openSocketWithURLRequest(request: urlRequest, delegate: unwrappedDelegate)
        }
    }
    
    func disconnect() {
        socketClient.disconnect()
    }
    
    func unsubscribe(chatRoomId: Int) {
        socketClient.unsubscribe(destination: "/queue/\(chatRoomId)")
    }
    
    func stompClientDidConnect(client: StompClientLib!, chatRoomId: Int) {
        socketClient.subscribe(destination: "/queue/\(chatRoomId)")
    }
    
    func sendMessage(content: String, senderId: Int, chatRoomId: Int) {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(MessageRequestDTO(content: content, senderId: senderId))
        
        if let unwrappedJsonData = jsonData, let json = String(data: unwrappedJsonData, encoding: String.Encoding.utf8) {
            var headersToSend = [String: String]()
            headersToSend["content-type"] = "application/json;charset=UTF-8"
            socketClient.sendMessage(message: json, toDestination: "/app/chat/send/\(chatRoomId)", withHeaders: headersToSend, withReceipt: nil)
        }
    }
}
