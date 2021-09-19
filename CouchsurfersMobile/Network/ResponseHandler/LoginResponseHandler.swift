//
//  LoginResponseHandler.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation

class LoginResponseHandler: ResponseHandler<LoginResponseDTO> {
    
    override func decodeResponse(from data: Data, httpResponse: HTTPURLResponse) throws -> LoginResponseDTO {
        let decodedData = try JSONDecoder().decode(LoginResponseDTO.self, from: data)
        
        if let cookie = httpResponse.allHeaderFields["Set-Cookie"] as? String {
            let sessionID = self.getSessionId(from: cookie)
            
            if let unwrappedSessionId = sessionID {
                decodedData.sessionId = unwrappedSessionId
            }
            
        }
        
        return decodedData
    }
    
    private func getSessionId(from cookie: String?) -> String? {
        guard let unwrappedCookie = cookie else {
            return nil
        }
        
        let splittedCookies = unwrappedCookie.split(separator: ";")
        
        let sessionID = splittedCookies.filter {
            $0.contains("JSESSIONID")
        }
        
        if sessionID.count != 1 {
            return nil
        }
        
        let sessionIdValue = sessionID[0].replacingOccurrences(of: "JSESSIONID=", with: "")
        
        return sessionIdValue
    }
}
