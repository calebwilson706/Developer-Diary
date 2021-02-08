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
    
    @ObservedObject var myKeywordsLists = KeyWordList()
    
    @State private var descriptionTemp = "..."
    @State private var titleTemp = ""
    @State private var listOfTempFeatures = [String]()
    @State private var listOfTempTags = [String]()
    
    @State private var tempNewFeatureInField = ""
    @State private var featureHoveringOver = -1
    @State private var tempNewTagInField = ""
    @State private var tagHoveringOver = -1
    
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
                .font(.body)
                
        }.padding()
            
    }
    var titleTextField : some View {
        VStack(spacing : 5){
            FormTitlesViews(str: "Title:")
            TextField("Title Here", text: $titleTemp)
                .font(.title2)
        }.padding()
    }
    var featuresList : some View {
        VStack(spacing : 5){
            FormTitlesViews(str: "Features:")
            List {
                ForEach(Array(self.listOfTempFeatures.enumerated()), id : \.offset){ index, feature in
                    Text(feature)
                        .strikethrough(featureHoveringOver == index)
                        .onHover { inside in
                            featureHoveringOver = inside ? index : -1
                        }
                        .onTapGesture {
                            self.listOfTempFeatures.remove(at: index)
                        }
                }
                newFeatureTextField
            }.listStyle(PlainListStyle())
        }.padding()
    }
    var newFeatureTextField : some View {
        HStack{
            Button(action: {
                if self.tempNewFeatureInField != "" {
                    self.listOfTempFeatures.append(self.tempNewFeatureInField)
                    self.tempNewFeatureInField = ""
                }
            }){
                Image(systemName: "plus.circle.fill").imageScale(.medium)
            }.buttonStyle(CloseButtonStyle())
            
            TextField("New Feature...", text: $tempNewFeatureInField)
        }
    }
    var tagsSection : some View {
        VStack(spacing : 5){
            FormTitlesViews(str: "Tags:")
            List{
//                ForEach(Array(Self.listOfTempTags.enumerated()), id : \.self){ tag in
//                    Text("#" + tag).onHover { inside in
//                        if inside {
//                            self.hoveringOver == self.listOfTempTags.lastIndex(of: tag)
//                        }
//                    }
//                }
                ForEach(Array(self.listOfTempTags.enumerated()), id : \.offset){ index, key in
                    Text("#" + key)
                        .strikethrough(tagHoveringOver == index)
                        .onHover { inside in
                            self.tagHoveringOver = inside ? index : -1
                        }
                        .onTapGesture {
                            self.listOfTempTags.remove(at: index)
                        }
                        
                }
                newTagTextField
            }.listStyle(PlainListStyle())
            suggestedTagsAreas
        }.padding()
    }
    
    var newTagTextField : some View {
        HStack{
            Button(action: {
                handleNewTagSequence()
            }){
                Image(systemName: "plus.circle.fill").imageScale(.medium)
            }.buttonStyle(CloseButtonStyle())
            
            TextField("New Tag...",text : $tempNewTagInField)
        }
    }
    
    var suggestedTagsAreas : some View {
        HStack(spacing : 0){
            ForEach(self.myKeywordsLists.keywords, id: \.word){ key in
                if (key.word.contains(self.tempNewTagInField.lowercased())){
                    Text(key.word + ",").onTapGesture {
                        self.tempNewTagInField = key.word
                        handleNewTagSequence()
                    }.modifier(cursorForButtonStyleMod())
                }
            }
            Spacer()
        }
    }
    var body : some View {
        VStack(spacing : 5){
            headerCancelbar
            Form {
                titleTextField
                descriptiontextEditor
                featuresList
                tagsSection
                //save button here
            }.padding(.bottom)
        }.frame(minWidth: 500,minHeight: 500)
    }
    
    func handleNewTagSequence() {
        if self.tempNewTagInField != "" {
            if !self.listOfTempTags.contains(tempNewTagInField.lowercased()) {
                self.listOfTempTags.append(self.tempNewTagInField.lowercased().replacingOccurrences(of: " ", with: "-"))
            }
            self.tempNewTagInField = ""
        }
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



