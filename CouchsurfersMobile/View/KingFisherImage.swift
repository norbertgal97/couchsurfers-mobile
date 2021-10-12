//
//  KingFisherImage.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 07..
//

import SwiftUI
import Kingfisher

@ViewBuilder func KingFisherImage(url: String) -> KFImage {
    
    let modifier = AnyModifier { request in
        var modifiableRequest = request
        modifiableRequest.httpMethod = HTTPMethod.GET.rawValue
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == "JSESSIONID" {
                    modifiableRequest.setValue("JSESSIONID=\(cookie.value)", forHTTPHeaderField: "Cookie")
                }
            }
        }
        
        return modifiableRequest
    }
    
    let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? "http://localhost:8080"
    
    KFImage(URL(string: baseUrl + url))
        .placeholder{
            Color.gray
        }
        .requestModifier(modifier)
}


