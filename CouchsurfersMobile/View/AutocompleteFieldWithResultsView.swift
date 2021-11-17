//
//  AutocompleteFieldWithResultsView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 09..
//

import SwiftUI

struct AutocompleteFieldWithResultsView: View {
    @Binding var cityNameText: String
    @Binding var cityId: String
    @Binding var places: [Place]
    @Binding var selectedCity : String
    
    var generateSessionToken: () -> Void
    var autocomplete: (_ cityName: String) -> Void
    
    var body: some View {
        if selectedCity != "" {
            TextField(NSLocalizedString("AutocompleteFieldWithResultsView.City", comment: "City"), text: $selectedCity)
                .disabled(true)
                .overlay(
                    HStack {
                        Spacer()
                        if selectedCity != "" {
                            Image(systemName: "xmark.circle.fill")
                                .onTapGesture {
                                    selectedCity = ""
                                    cityId = ""
                                }
                        }
                    }
                        .padding(), alignment: .center)
        } else {
            TextField(NSLocalizedString("AutocompleteFieldWithResultsView.City", comment: "City"), text: $cityNameText)
                .onChange(of: cityNameText) {
                    if $0 == "" {
                        generateSessionToken()
                    } else {
                        autocomplete($0)
                    }
                }
                .overlay(
                    HStack {
                        Spacer()
                        if cityNameText != "" {
                            Image(systemName: "xmark.circle.fill")
                                .onTapGesture {
                                    self.cityNameText = ""
                                }
                        }
                    }
                        .padding(), alignment: .center)
        }
        
        if cityNameText != "" {
            List {
                ForEach(places, id: \.id) { result in
                    Text(result.description)
                        .onTapGesture {
                            selectedCity = result.description
                            cityId = result.id
                            cityNameText = ""
                        }
                }
            }
        }
    }
}
