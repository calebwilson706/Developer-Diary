//
//  IdeaDetailView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
import SwiftUI

struct IdeaDetailView : View {
    @ObservedObject var idea : Assignment
    @EnvironmentObject var localListOfAssignemntsForediting : ListOfAssignments
    @State var isEditMode = false
    

    var descriptionStack : some View {
        VStack(alignment : .center) {
            DetailsTitlesViews(str : "Description:")
            HStack {
                Text(idea.description)
                    .modifier(DetailsBodyFont())
                Spacer()
            }
        }
    }
    var titleBar : some View {
        HStack{
            Spacer()
            Text(idea.title).modifier(TitleDetailText())
            Spacer()
            Button(action: {
                self.isEditMode = true
            }){
                Text("edit")
            }.buttonStyle(CloseButtonStyle())
        }.padding(.top)
    }
    
    var body : some View {
        VStack(spacing : 5){
            if isEditMode {
                NewIdeaFormView(showThisForm: $isEditMode,descriptionTemp : idea.description, titleTemp : idea.title,listOfTempFeatures : idea.features, listOfTempTags: idea.tags, isNewAssignment : false,theUUIDToFind: idea.id).environmentObject(self.localListOfAssignemntsForediting)
            } else {
                titleBar
                descriptionStack
                ListOfFeaturesAndTags(string: getListOfStringsAsOne(list: idea.features, isTagList: false), isTagView: false)
                ListOfFeaturesAndTags(string: getListOfStringsAsOne(list: idea.tags, isTagList: true), isTagView: true)
                Spacer()
            }
        }.padding(.horizontal)
    }
    
    func getListOfStringsAsOne(list : [String],isTagList : Bool) -> String {
        return list.reduce("", {acc, str in
            acc + (isTagList ? "#" : "-> ") + str + "\n"
        })
    }
}


struct DetailsTitlesViews : View {
    var str : String
    var body : some View {
        HStack{
            Text(str).modifier(HeaderFormFont())
            Spacer()
        }
    }
}


struct ListOfFeaturesAndTags : View {
    var string : String
    var isTagView : Bool
    
    var body : some View {
        VStack(alignment : .leading, spacing : 3){
            DetailsTitlesViews(str: isTagView ? "Tags:" : "Features:")
            Text(string).multilineTextAlignment(.leading)
        }
    }
}
