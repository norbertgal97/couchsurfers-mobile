//
//  ReviewInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 31..
//

import Foundation
import os

class ReviewInteractor {
    
    private let baseUrl: String
    private let reviewsUrl = "/api/v1/reviews"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func getReviewsForSpecificCouch(with couchId: Int, completionHandler: @escaping (_ reviews: [Review]?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<[ReviewDTO]>()
        
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + reviewsUrl + "?couchid=\(couchId)")!, method: .GET)
        
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
                            message = NSLocalizedString("networkError.couchNotFound", comment: "Couch not found")
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
                self.logger.debug("Reviews are loaded. Count: \(data!.count)")
                completionHandler(self.convertDTOToModel(dto: data!), message, true)
            }
            
        }
        
    }
    
    func createReview(with couchId: Int, _ description: String, completionHandler: @escaping (_ created: Bool, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<ReviewDTO>()
        
        let reviewRequestDTO = ReviewRequestDTO(couchId: couchId, description: description)
        
        let urlRequest = networkManager.makeRequest(from: reviewRequestDTO, url: URL(string: baseUrl + reviewsUrl + "/")!, method: .POST)
                
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            var message: String?
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    if unwrappedStatusCode == 401 {
                        self.logger.debug("Session has expired!")
                        completionHandler(false, nil, false)
                        return
                    }
                }
                
                if let unwrappedError = error {
                    if let unwrappedStatusCode = statusCode {
                        switch unwrappedStatusCode {
                        case 404:
                            message = NSLocalizedString("networkError.couchNotFound", comment: "Couch not found")
                        case 422:
                            message = NSLocalizedString("networkError.emptyFields", comment: "Empty fields")
                        default:
                            message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(false, message, true)
            case .successful:
                self.logger.debug("Review is created with id: \(data!.id)")
                completionHandler(true, message, true)
            }
            
        }
        
    }
    
    private func convertDTOToModel(dto: [ReviewDTO]) -> [Review] {
        var reviewList = [Review]()
        
        for review in dto {
            let newReview = Review(id: review.id, name: review.name, description: review.description)
            reviewList.append(newReview)
        }
        
        return reviewList
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
