//
//  ListOfIdeasView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
import SwiftUI

struct ListOfIdeasView : View {
    @ObservedObject var listOfAssignments = ListOfAssignments()
    @State var showForm = false
    var body: some View {
        ZStack{
            NavigationView {
                 VStack {
                    List {
                        ForEach(0..<100){ num in
                            NavigationLink(destination: Text("Testing This : \(num)")){
                                Text("next view")
                            }
                        }
                    }.padding(.all)
                    
                    Button(action: {
                        self.showForm = true
                    }){
                        HStack {
                            Text("New Assignment")
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                        }
                    }.padding().modifier(cursorForButtonStyleMod())
                }
                
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }.sheet(isPresented: $showForm){
            NewIdeaFormView(showThisForm: $showForm).environmentObject(self.listOfAssignments)
        }
    }
}
