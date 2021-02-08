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
    @State var editmodeOn = false
    
    @State var editingHoverer = -1
    var body: some View {
        ZStack{
            if !editmodeOn {
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
                        HStack{
                            Spacer()
                            Button(action: {
                                self.showForm = true
                            }){
                                HStack {
                                    Text("New Assignment")
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                }
                            }.padding(.leading).modifier(cursorForButtonStyleMod())
                            Spacer()
                            Button(action: {
                                self.editmodeOn = true
                            }){
                                Image(systemName: "trash").padding(.trailing)
                            }.buttonStyle(CloseButtonStyle())
                        }.padding(.vertical)
                        
                     }
                    
                }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            } else {
                VStack(alignment: .center){
                    editView
                }
            }
            
        }.sheet(isPresented: $showForm){
            NewIdeaFormView(showThisForm: $showForm).environmentObject(self.listOfAssignments)
        }
    }
    
    
    var editView : some View {
        HStack{
            VStack(alignment: .center){
                List {
                    Button(action: {
                        self.editmodeOn = false
                    }){
                        Text("Exit").padding(.all,5)
                    }.buttonStyle(ExitButtonEditModeStyle())
                    ForEach(listOfAssignments.assignments, id: \.id){ idea in
                        HStack(spacing: 0) {
                            Spacer()
                            Group {
                                Text("Delete -------> ")
                                Text(idea.title).underline().bold()
                            }.onHover(perform: { inside in
                                editingHoverer = inside ? listOfAssignments.assignments.firstIndex(where: {$0.id == idea.id})! : -1
                            })
                            .onTapGesture {
                                self.listOfAssignments.assignments.removeAll(where: {idea.id == $0.id })
                            }
                            Spacer()
                        }.font(.custom("Montserrat-Regular", size: 18))
                        .foregroundColor((editingHoverer == listOfAssignments.assignments.firstIndex(where: {$0.id == idea.id})) ? Color.red : Color.gray)
                    }
                }
            }
        }
    }
}




