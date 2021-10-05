//
//  AutocompleteFieldViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation

class AutocompleteFieldViewModel: ObservableObject {
    @Published var places = [PlaceDTO]()
    
    private var sessionToken: String = UUID().uuidString
    private var API_KEY = ""
    
    init() {
        guard let googleApiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleApiKey") as? String else {
            fatalError()
        }
        
        self.API_KEY = googleApiKey
    }
    
    
    func autocomplete(cityname: String) {
        let nameWithoutSpaces = cityname.removeSpaces()
        let requestUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(nameWithoutSpaces)&types=(cities)&key=\(API_KEY)&language=\(NSLocalizedString("autocomplete.placesAPIlanguage", comment: "language"))&sessiontoken=\(sessionToken)"
        
        let networkManager = NetworkManager<PredictionsDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: requestUrl)!, method: .GET)
        
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    print("statusCode: \(unwrappedStatusCode)")
                }
            case .successful:
                print(self.sessionToken)
                
                if let allPredictions = data {
                    if allPredictions.status == "OK" {
                        DispatchQueue.main.async {
                            self.places = allPredictions.all
                        }
                        
                        for place in self.places {
                            print(place.description)
                        }
                        
                    } else if allPredictions.status == "ZERO_RESULTS" {
                        DispatchQueue.main.async {
                            self.places.removeAll()
                        }
                        print("Nincs találat")
                    } else {
                        print("Hiba történt")
                    }
                }
                
            }
            
        }
        
    }
    
    func generateSessionToken() {
        sessionToken = UUID().uuidString
    }
    
}
