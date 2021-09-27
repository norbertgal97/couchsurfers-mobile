//
//  MyCouchView.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 20..
//

import Foundation
import SwiftUI

struct MyCouchView: View {
    @EnvironmentObject var globalEnv: GlobalEnvironment
    
    var body: some View {
        NavigationView {
            VStack {
                Text("nincs kép")
                    .padding(.top, 5)
            }
        }
        .navigationBarTitle(Text(NSLocalizedString("myCouch.navigationBarTitle", comment: "My Couch")), displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: MyCouchDetails(couchId: 1, myCouchDetailsVM: MyCouchDetailsViewModel())) {
            Image(systemName: "square.and.pencil")
                .foregroundColor(Color.red)
        })
    }
}
