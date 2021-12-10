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
    @Binding var couchFilter: CouchFilter
    
    @Binding var showingAlert: Bool
    @Binding var alertDescription: String
    
    var generateSessionToken: () -> Void
    var autocomplete: (_ cityName: String) -> Void
    var validateFilter: (_ filter: CouchFilter) -> Bool
    
    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("ExplorationFormView.Address", comment: "Address"))) {
                AutocompleteFieldWithResultsView(cityNameText: $cityNameText,
                                                 cityId: $cityId,
                                                 places: $places,
                                                 selectedCity: $selectedCity,
                                                 generateSessionToken: { generateSessionToken() },
                                                 autocomplete: { autocomplete($0) })
            }
            
            Section(header: Text(NSLocalizedString("ExplorationFormView.Details", comment: "Details"))) {
                TextField(NSLocalizedString("ExplorationFormView.NumberOfGuests", comment: "Number Of Guests"), text: $couchFilter.numberOfGuests)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text(NSLocalizedString("ExplorationFormView.Date", comment: "Date"))) {
                let today = Date()
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                
                DatePicker(NSLocalizedString("ExplorationFormView.Checkin", comment: "Check-in"), selection: $couchFilter.fromDate, in: today..., displayedComponents: .date)
                DatePicker(NSLocalizedString("ExplorationFormView.Checkout", comment: "Check-out"), selection: $couchFilter.toDate, in: tomorrow..., displayedComponents: .date)
            }
            
            Section {
                Button(action: {
                    couchFilter.city = cityId
                    
                    if validateFilter(couchFilter) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text(NSLocalizedString("ExplorationFormView.Search", comment: "Search"))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .accentColor(Color.red)
            }
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text(NSLocalizedString("CommonView.Error", comment: "Error")), message: Text(alertDescription), dismissButton: .default(Text(NSLocalizedString("CommonView.Cancel", comment: "Cancel"))) {
                print("Dismiss button pressed")
            })
        })
    }
}
