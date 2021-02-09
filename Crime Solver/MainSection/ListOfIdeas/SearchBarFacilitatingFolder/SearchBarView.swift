//
//  SearchBarView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 09/02/2021.
//

import Foundation
import SwiftUI

/*
 create a view with a binding string that then is
 used to filter the list in the navigation view by tags.
 
 -> Possible ability to use a seperator to make more than one filter
 
 -> remember to replace spaces with '-' and to make it all lowercase
*/

struct SearchBarView : View {
    @Binding var theSearchString : String
    @State var showTextField = false
    
    var magnifyingGlassButton : some View {
        Button(action: {
            withAnimation {
                showTextField.toggle()
            }
        }){
            Image(systemName: "magnifyingglass")
        }.buttonStyle(CloseButtonStyle())
    }
    var body : some View {
        HStack {
            magnifyingGlassButton
            
            TextField("Search For Tags...", text: $theSearchString)
                .opacity(showTextField ? 1.0 : 0.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())

        }.padding(.horizontal).padding(.top)
    }
}
