//
//  AutocompleteFieldView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation
import SwiftUI

struct AutocompleteField: View {
    @Binding var cityNameText: String
    
    let autocompleteFieldVM : AutocompleteFieldViewModel
    
    var body: some View {
        TextField("City name", text: $cityNameText)
            .onChange(of: cityNameText) {
                if $0 == "" {
                    autocompleteFieldVM.generateSessionToken()
                } else {
                    autocompleteFieldVM.autocomplete(cityname: $0)
                }
            }
    }
}
