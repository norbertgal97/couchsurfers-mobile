//
//  ExplorationFormView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 10..
//

import SwiftUI

struct ExplorationFormView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var places: [Place]
    @Binding var selectedCity: String
    @Binding var cityNameText: String
    @Binding var cityId: String
    @Binding var isShowingListView: Bool
    @Binding var couchFilter: CouchFilter
    
    var generateSessionToken: () -> Void
    var autocomplete: (_ cityName: String) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Address")) {
                AutocompleteFieldWithResultsView(cityNameText: $cityNameText,
                                                 cityId: $cityId,
                                                 places: $places,
                                                 selectedCity: $selectedCity,
                                                 generateSessionToken: { generateSessionToken() },
                                                 autocomplete: { autocomplete($0) })
            }
            
            Section(header: Text("Details")) {
                TextField("Number of guests", text: $couchFilter.numberOfGuests)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Date")) {
                let today = Date()
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                
                DatePicker("Check-in", selection: $couchFilter.fromDate, in: today..., displayedComponents: .date)
                DatePicker("Check-out", selection: $couchFilter.toDate, in: tomorrow..., displayedComponents: .date)
            }
            
            Section {
                Button(action: {
                    couchFilter.city = selectedCity
                    isShowingListView = true
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Search")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .accentColor(Color.red)
            }

                    
        }
    
    }
    
    
}