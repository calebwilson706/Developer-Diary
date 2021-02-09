//
//  ListOfIdeasView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
import SwiftUI

struct ListOfIdeasView : View {
    //main list
    @ObservedObject var listOfAssignments = ListOfAssignments()
    
    //form
    @State var showForm = false
    
    //edit mode variables
    @State var editmodeOn = false
    @State var editingHoverer = -1
    
    //search bar strings
    @State var searchBarText : String = ""
    
    var ListViewOfAssignmentsAndTheirLink : some View {
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
        
    }
    var newAssignmentButton : some View {
        Button(action: {
            self.showForm = true
        }){
            HStack {
                Text("New Assignment")
                Spacer()
                Image(systemName: "plus.circle.fill")
            }
        }.padding(.leading).modifier(cursorForButtonStyleMod())
    }
    
    var editModebuttonEnterOrExit : some View {
        Button(action: {
            if !self.listOfAssignments.assignments.isEmpty {
                withAnimation {
                    self.editmodeOn.toggle()
                }
            }
        }){
            if self.editmodeOn {
                Text("Exit")
            } else {
                Image(systemName: "trash").padding(.bottom,2)
            }
        }.padding( editmodeOn ? .all : .trailing, editmodeOn ? 5 : 12)
        .buttonStyle(ExitButtonEditModeStyle(isEditModeOn: self.editmodeOn))
    }
    var footer : some View {
        HStack{
            Spacer()
            newAssignmentButton
            Spacer()
            editModebuttonEnterOrExit
        }.padding(.vertical)
    }
    var body: some View {
        ZStack{
            if !editmodeOn {
                NavigationView {
                     VStack {
                        SearchBarView(theSearchString: $searchBarText)
                        ListViewOfAssignmentsAndTheirLink
                        footer
                     }.animation(.none)
                }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            } else {
                editView
            }
            
        }.sheet(isPresented: $showForm){
            NewIdeaFormView(showThisForm: $showForm).environmentObject(self.listOfAssignments)
        }
    }
    
    
    var editView : some View {
        HStack{
            VStack(alignment: .center){
                List {
                    editModebuttonEnterOrExit
                    listInEditModeWithActions
                }
            }
        }
    }
    
    var listInEditModeWithActions : some View {
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
                    if (self.listOfAssignments.assignments.isEmpty) {
                        self.editmodeOn = false
                    }
                }
                Spacer()
            }.font(.custom("Montserrat-Regular", size: 18))
            .foregroundColor((editingHoverer == listOfAssignments.assignments.firstIndex(where: {$0.id == idea.id})) ? Color.red : Color.gray)
        }
    }
}




