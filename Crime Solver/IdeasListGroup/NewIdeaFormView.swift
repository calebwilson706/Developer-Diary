//
//  NewIdeaFormView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
import SwiftUI


struct NewIdeaFormView : View {
    @EnvironmentObject var listOfCurrentAssignments : ListOfAssignments
    @Binding var showThisForm : Bool
    @State private var descriptionTemp = ""
    var headerCancelbar : some View {
        HStack{
            Text("New Assignment").modifier(HeaderFormFont())
            Spacer()
            Button(action: {
                withAnimation {
                    self.showThisForm = false
                }
            }){
                Image(systemName: "xmark.circle").imageScale(.medium)
            }.buttonStyle(CloseButtonStyle())
        }.padding()
    }
    var descriptiontextEditor : some View {
        VStack(spacing: 5){
            FormTitlesViews(str: "Description:")
            TextEditor(text: $descriptionTemp)
                .background(Color.clear)
                .font(.body)
                
        }.padding()
            
    }
    var body : some View {
        VStack{
            headerCancelbar
            Form {
                //title text field here
                descriptiontextEditor
                //features list here
                //tag list here
                //save button here
            }
        }.frame(minWidth: 200,minHeight: 200)
    }
}


struct FormTitlesViews : View {
    var str : String
    var body : some View {
        HStack{
            Text(str).modifier(MiniHeaderFormFont())
            Spacer()
        }
    }
}
