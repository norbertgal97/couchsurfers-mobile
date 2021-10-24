//
//  Autocomplete.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 09..
//

import SwiftUI

class GooglePlacesViewModel: ReversePlaceIdProtocol {
    
    @Published var places = [Place]()
    @Published var selectedCity: String = ""
    @Published var cityNameText: String = ""
    var sessionToken: String = UUID().uuidString
    
    func autocomplete(cityname: String) {
        let nameWithoutSpaces = cityname.removeSpaces()
        
        print(sessionToken)
        
        googlePlacesInteracor.autocomplete(cityname: nameWithoutSpaces, sessionToken: sessionToken) { places in
           self.places = places
        }
        
    }
    
    func generateSessionToken() {
        self.sessionToken = UUID().uuidString
    }
    
    func reverseCity(cityId: String) {
        googlePlacesInteracor.reverseCityId(cityId: cityId) { cityName in
            DispatchQueue.main.async {
                self.selectedCity = cityName
            }
        }
    }
    
}

protocol ReversePlaceIdProtocol: ObservableObject {
    var googlePlacesInteracor: GooglePlacesInteractor { get }
    
    func reverseCity(cityId: String, completionHandler: @escaping (_ reversedCity: String) -> Void)
}

extension ReversePlaceIdProtocol {
    var googlePlacesInteracor: GooglePlacesInteractor {
        get { return GooglePlacesInteractor() }
    }
    
    func reverseCity(cityId: String, completionHandler: @escaping (_ reversedCity: String) -> Void) {
        googlePlacesInteracor.reverseCityId(cityId: cityId) { cityName in
            DispatchQueue.main.async {
                completionHandler(cityName)
            }
        }
    }
}
