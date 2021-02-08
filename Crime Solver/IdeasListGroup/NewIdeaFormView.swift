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
    
    @State var descriptionTemp = "..."
    @State var titleTemp = ""
    @State var listOfTempFeatures = [String]()
    @State var listOfTempTags = [String]()
    
    @State private var tempNewFeatureInField = ""
    @State private var featureHoveringOver = -1
    @State private var tempNewTagInField = ""
    @State private var tagHoveringOver = -1
    
    @State private var showErrorMsg = false
    
    @State var isNewAssignment = true
    @State var theUUIDToFind : UUID? = nil
    
    @State private var newTags = [String]()
    var headerCancelbar : some View {
        HStack{
            Text(isNewAssignment ? "New Assignment" : titleTemp).modifier(HeaderFormFont())
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
                
        }.padding(.horizontal)
            
    }
    var titleTextField : some View {
        VStack(spacing : 5){
            FormTitlesViews(str: "Title:")
            TextField("Title Here", text: $titleTemp)
                .font(.title2).onChange(of: titleTemp, perform: { _ in
                    titleTemp = (titleTemp.first?.uppercased() ?? "") + titleTemp.dropFirst()
                })
                
                
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
        }.padding(.horizontal)
    }
    var newFeatureTextField : some View {
        HStack{
            Button(action: {
                handleNewFeatureSequence()
            }){
                Image(systemName: "plus.circle.fill").imageScale(.medium)
            }.buttonStyle(CloseButtonStyle())
            
            TextField("New Feature...", text: $tempNewFeatureInField,onCommit : {
                handleNewFeatureSequence()
            })
            .modifier(ManualTextFieldAnimationCursor())
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
                            self.newTags = self.newTags.filter {$0 != key}
                            self.listOfTempTags.remove(at: index)
                        }
                        
                }
                newTagTextField
                suggestedTagsAreas
            }.listStyle(PlainListStyle())
        }.padding(.horizontal)
    }
    
    var newTagTextField : some View {
        HStack{
            Button(action: {
                handleNewTagSequence()
            }){
                Image(systemName: "plus.circle.fill").imageScale(.medium)
            }.buttonStyle(CloseButtonStyle())
            
            TextField("New Tag...",text : $tempNewTagInField,onCommit : {
                handleTagTextFieldExit()
            })
            .modifier(ManualTextFieldAnimationCursor())
        }
    }
    
    var suggestedTagsAreas : some View {
        HStack(spacing : 0){
            ForEach(Array(self.myKeywordsLists.keywords.enumerated()), id: \.offset){ index, key in
                if (key.word.contains(self.tempNewTagInField.lowercased())){
                    Text(key.word + ",").padding()
                        .onTapGesture {
                            self.tempNewTagInField = key.word
                            handleNewTagSequence()
                        }.modifier(cursorForButtonStyleMod())
                        .background(
                            (self.myKeywordsLists.keywords.firstIndex {$0.word.contains(self.tempNewTagInField.lowercased())} == index)
                                ? Color.gray.cornerRadius(5) : Color.clear.cornerRadius(5)
                        )
                }
                
            }
            Spacer()
        }
    }
    
    var saveButton : some View {
        HStack {
            Spacer()
            Button(action:{
                if (titleTemp != "" && descriptionTemp != ""){
                    handleSavePressed()
                } else {
                    self.showErrorMsg = true
                }
            }){
                Text("\(self.isNewAssignment ? "create" : "edit") assignment").padding(.all,6)
            }.buttonStyle(SaveButtonStyle())
            Spacer()
        }
    }
    var body : some View {
        VStack(spacing : 0){
            Form {
                headerCancelbar
                if isNewAssignment {
                    titleTextField
                }
                descriptiontextEditor.frame(maxHeight: 150)
                featuresList.frame(maxHeight : 2000)
                tagsSection
                saveButton
            }
            //save button here
            Spacer()
        }.frame(minWidth: 500,minHeight: 500)
        .alert(isPresented: $showErrorMsg){
            Alert(title: Text("Invalid Input!"), message: Text("You either didnt fill in the description or title."), dismissButton: .default(Text("Dismiss")))
        }
    }
    
    func handleNewTagSequence() {
        if self.tempNewTagInField != "" {
            if !self.listOfTempTags.contains(tempNewTagInField.lowercased()) {
                self.listOfTempTags.append(self.tempNewTagInField.lowercased().replacingOccurrences(of: " ", with: "-"))
                self.newTags.append(self.tempNewTagInField.lowercased().replacingOccurrences(of: " ", with: "-"))
            }
            self.tempNewTagInField = ""
        }
    }
    
    func handleTagTextFieldExit() {
        self.tempNewTagInField = (self.myKeywordsLists.keywords.first {$0.word.contains(self.tempNewTagInField.lowercased())}?.word) ?? self.tempNewTagInField
        handleNewTagSequence()
    }
    func handleNewFeatureSequence() {
        if self.tempNewFeatureInField != "" {
            self.listOfTempFeatures.append(self.tempNewFeatureInField)
            self.tempNewFeatureInField = ""
        }
    }
    func handleSavePressed() {
        let newAssignment = Assignment(title: self.titleTemp, description: self.descriptionTemp, features: self.listOfTempFeatures, tags: self.listOfTempTags)
        updateTheTagsInStorage()
        
        if isNewAssignment {
            self.listOfCurrentAssignments.assignments.append(newAssignment)
        } else {
            let index = self.listOfCurrentAssignments.assignments.firstIndex(where: {$0.id == theUUIDToFind})
            (index != nil) ? self.listOfCurrentAssignments.assignments[index!] = newAssignment : print("error")
        }
        self.showThisForm = false
    }
    func updateTheTagsInStorage() {
        for item in self.newTags {
            self.myKeywordsLists.addKeyWord(word: item)
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



