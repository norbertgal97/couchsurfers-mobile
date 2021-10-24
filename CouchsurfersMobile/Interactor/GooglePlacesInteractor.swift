//
//  GooglePlacesInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 09..
//

import Foundation
import os

class GooglePlacesInteractor {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    private var API_KEY = ""
    
    init() {
        guard let googleApiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleApiKey") as? String else {
            fatalError()
        }
        
        self.API_KEY = googleApiKey
    }
    
    func autocomplete(cityname: String, sessionToken: String, completionHandler: @escaping (_ places: [Place]) -> Void) {
        let requestUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(cityname)&types=(cities)&key=\(API_KEY)&language=\(NSLocalizedString("autocomplete.placesAPIlanguage", comment: "language"))&sessiontoken=\(sessionToken)"
        
        let networkManager = NetworkManager<PredictionsDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: requestUrl)!, method: .GET)
        
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    completionHandler([Place]())
                    print("statusCode: \(unwrappedStatusCode)")
                }
            case .successful:
                //print(sessionToken)
                
                if let allPredictions = data {
                    if allPredictions.status == "OK" {
                        DispatchQueue.main.async {
                            completionHandler(self.convertDTOToModel(dto: allPredictions.all))
                        }
                        
                    } else if allPredictions.status == "ZERO_RESULTS" {
                        DispatchQueue.main.async {
                            completionHandler([Place]())
                        }
                        print("Nincs találat")
                    } else {
                        print("Hiba történt")
                    }
                }
                
            }
            
        }
    }
    
    func reverseCityId(cityId: String, completionHandler: @escaping (_ cityName: String) -> Void) {
        let requestUrl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(cityId)&key=\(self.API_KEY)&language=&language=\(NSLocalizedString("autocomplete.placesAPIlanguage", comment: "language"))"
        
        let networkManager = NetworkManager<ReversePlaceIdDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: requestUrl)!, method: .GET)
        
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    completionHandler("-")
                    print("statusCode: \(unwrappedStatusCode)")
                }
            case .successful:
                if let unwrappedData = data {
                    if unwrappedData.status == "OK" {
                        DispatchQueue.main.async {
                            completionHandler(unwrappedData.result.address)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completionHandler("-")
                        }
                    }
                }
                
            }
            
        }
    }
    
    private func convertDTOToModel(dto: [PlaceDTO]) -> [Place] {
        var places = [Place]()
        
        for place in dto {
            places.append(Place(id: place.id, description: place.description))
        }
        
        return places
    }
    
}
