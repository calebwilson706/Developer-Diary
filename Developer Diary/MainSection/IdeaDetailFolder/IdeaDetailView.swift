//
//  IdeaDetailView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
import SwiftUI
import PDFKit

struct IdeaDetailView : View {
    @ObservedObject var idea : Assignment
    @EnvironmentObject var localListOfAssignemntsForediting : ListOfAssignments
    @State var isEditMode = false
    
    @State var hoveveringOverFeature : String? = nil
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
    
    var featuresToImplement : some View {
        VStack {
            DetailsTitlesViews(str: "New Features:")
            VStack {
                ForEach(idea.features, id : \.self){ new in
                    HStack(spacing : 0){
                        Text("-> ")
                        Text(new)
                            .padding(.trailing)
                        Button(action: {
                            self.moveFeature(feature: new)
                        }){
                            Image(systemName: (self.hoveveringOverFeature == new ? "checkmark.circle.fill" : "checkmark.circle"))
                        }.buttonStyle(BaseForCloseButtonStyle())
                         .onHover { inside in
                             self.hoveveringOverFeature = inside ? new : nil
                         }
                        Spacer()
                    }
                }
            }
        }
    }
    var titleBar : some View {
        ZStack {
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
    }
    
    var body : some View {
        VStack(spacing : 5){
            if isEditMode {
                NewIdeaFormView(showThisForm: $isEditMode,descriptionTemp : idea.description, titleTemp : idea.title,listOfTempFeatures : idea.features, listOfTempCompFeatures : self.idea.completedFeatures, listOfTempTags: idea.tags, isNewAssignment : false,theUUIDToFind: idea.id).environmentObject(self.localListOfAssignemntsForediting)
            } else {
                titleBar
                descriptionStack
                ListOfCompletedFeaturesAndTags(string: getListOfStringsAsOne(list: idea.completedFeatures, isTagList: false), isTagView: false)
                featuresToImplement
                ListOfCompletedFeaturesAndTags(string: getListOfStringsAsOne(list: idea.tags, isTagList: true), isTagView: true)
                Spacer()
            }
        }.padding(.horizontal)
    }
    
    func getListOfStringsAsOne(list : [String],isTagList : Bool) -> String {
        return list.reduce("", {acc, str in
            acc + (isTagList ? "#" : "-> ") + str + "\n"
        })
    }
    
    func moveFeature(feature : String){
        let myIndex = self.localListOfAssignemntsForediting.assignments.firstIndex {$0.id == idea.id}
        self.idea.moveFeatureToCompleted(feature: feature)
        
        if (myIndex != nil) {
            self.localListOfAssignemntsForediting.assignments[myIndex!] = idea
        }
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


struct ListOfCompletedFeaturesAndTags : View {
    var string : String
    var isTagView : Bool
    
    var body : some View {
        VStack(alignment : .leading, spacing : 3){
            DetailsTitlesViews(str: isTagView ? "Tags:" : "Completed Features:")
            Text(string).multilineTextAlignment(.leading)
        }
    }
}
