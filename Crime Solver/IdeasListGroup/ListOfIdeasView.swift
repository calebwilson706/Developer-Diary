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
    
    @State var selectedID : UUID? = nil
    var body: some View {
        ZStack{
            NavigationView {
                 VStack {
                    List {
                        ForEach(listOfAssignments.assignments, id: \.id){ idea in
                            NavigationLink(destination:
                                    IdeaDetailView(idea : idea).environmentObject(self.listOfAssignments)
                            ){
                                HStack{
                                    Text(idea.title)
                                        .font(.custom("Montserrat-Regular", size: 18))
                                    Spacer()
                                }
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
