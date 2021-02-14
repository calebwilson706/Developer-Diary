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
    //essentials
    @Binding var theSearchString : String
    @State private var showTextField = false
    let operationToBeCarriedOutAfterChanged : () -> Void
    
    //help
    @Binding var showHelp : Bool
    
    var magnifyingGlassButton : some View {
        Button(action: {
            withAnimation {
                showTextField.toggle()
            }
        }){
            Image(systemName: "magnifyingglass")
        }.buttonStyle(CloseButtonStyle())
    }
    
    var helpButton : some View {
        Button(action : {
            self.showHelp.toggle()
        }){
            Image(systemName: "questionmark.circle.fill")
        }.buttonStyle(BaseForCloseButtonStyle())
        .modifier(cursorForButtonStyleMod(disableThisFeature: !showTextField))
    }
    var theTextField : some View {
        TextField("Search For Tags...", text: $theSearchString).onChange(of: theSearchString, perform: { _ in
            operationToBeCarriedOutAfterChanged()
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    var body : some View {
        HStack {
            magnifyingGlassButton
            
            Group {
                theTextField
                helpButton
            }.opacity(showTextField ? 1.0 : 0.0)
             .disabled(!showTextField)
            
            

        }.padding(.horizontal).padding(.top)
    }
}
