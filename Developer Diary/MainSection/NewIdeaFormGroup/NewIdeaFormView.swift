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
    @State var listOfTempCompFeatures = [String]()
    @State var listOfTempTags = [String]()
    
    @State private var tempNewFeatureInField = ""
    @State private var featureHoveringOver = -1
    @State private var tempNewTagInField = ""
    @State private var tagHoveringOver = -1
    
    @State private var showErrorMsg = false
    
    @State var isNewAssignment = true
    @State var theUUIDToFind : UUID? = nil
    
    @State private var newTags = [String]()
    
    @State var saveButtonBackground = Color.gray
    @State var savebuttonForeground = Color.black
    
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
    
    var tagsSection : some View {
        VStack(spacing : 5){
            FormTitlesViews(str: "Tags:")
            List{
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
            }.listStyle(PlainListStyle())
            newTagTextField
            suggestedTagsAreas
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
                if (key.word.contains(tagValidation(str: self.tempNewTagInField))){
                    Text(key.word + ",").padding()
                        .onTapGesture {
                            self.tempNewTagInField = key.word
                            handleNewTagSequence()
                        }.modifier(cursorForButtonStyleMod())
                        .background(
                            (self.myKeywordsLists.keywords.firstIndex {$0.word.contains(tagValidatedContainerForTextFieldValue())} == index)
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
            }.buttonStyle(SaveButtonStyle(background: self.saveButtonBackground, foreground: self.savebuttonForeground))
             .onHover { inside in
                self.saveButtonBackground  = inside ? Color.white : Color.gray
                self.savebuttonForeground = inside ? Color.black : Color.white
             }
            
            .padding(.bottom,6)
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
                FeatureView(title: "Completed Features:", listOfTempFeatures: self.$listOfTempCompFeatures, isNewFeatureList: false, move: moveFeatureUp).padding(.bottom,5)
                FeatureView(title: "New Features:", listOfTempFeatures: self.$listOfTempFeatures, isNewFeatureList: true,move : moveFeatureUp).padding(.bottom,5)
                tagsSection.padding(.bottom,5)
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
                self.listOfTempTags.append(tagValidatedContainerForTextFieldValue())
                self.newTags.append(tagValidatedContainerForTextFieldValue())
            }
            self.tempNewTagInField = ""
        }
    }
    
    func handleTagTextFieldExit() {
        self.tempNewTagInField = (self.myKeywordsLists.keywords.first {$0.word.contains(tagValidatedContainerForTextFieldValue())}?.word) ?? self.tempNewTagInField
        handleNewTagSequence()
    }
    func handleSavePressed() {
        let newAssignment = Assignment(title: self.titleTemp, description: self.descriptionTemp, features: self.listOfTempFeatures, tags: self.listOfTempTags, completedFeatures: self.listOfTempCompFeatures)
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
        self.myKeywordsLists.keywords.sort {$0.usage > $1.usage}
    }
    func tagValidatedContainerForTextFieldValue() -> String {
        return tagValidation(str: self.tempNewTagInField)
    }
    
    func moveFeatureUp(index : Int){
        let str = self.listOfTempFeatures.remove(at: index)
        self.listOfTempCompFeatures.append(str)
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


func tagValidation(str : String) -> String {
    var temp = str
        .lowercased()
        .replacingOccurrences(of: " ", with: "-")
        .filter {$0 != ","}
    if temp.first == "-" {
        temp.removeFirst()
    }
    if temp.last == "-" {
        temp.removeLast()
    }
    return temp
}


struct FeatureView : View {
    var title : String
    
    @Binding var listOfTempFeatures : [String]
    @State var featureHoveringOver = -1
    @State var tempNewFeatureInField = ""
    @State var overButton = false
    
    var isNewFeatureList : Bool
    let move : (Int) -> Void
    
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
    
    var body : some View {
        VStack(spacing: 4){
            FormTitlesViews(str: title)
            List {
                ForEach(Array(listOfTempFeatures.enumerated()), id: \.offset){ index, feature in
                    HStack(spacing: 0) {
                        Text("-> ")
                        Text(feature)
                            .strikethrough((featureHoveringOver == index) && !overButton)
                            .onTapGesture {
                                if !overButton {
                                    self.listOfTempFeatures.remove(at: index)
                                }
                            }
                            .padding(.trailing,5)
                        
                        if isNewFeatureList {
                            Button(action: {
                                move(index)
                            }){
                                Image(systemName: (((self.featureHoveringOver == index) && overButton) ? "arrow.up.circle.fill" : "arrow.up.circle"))
                            }.buttonStyle(BaseForCloseButtonStyle())
                            .onHover { inside in
                                self.overButton = inside
                            }
                        }
                        Spacer()
                    }.onHover { inside in
                        featureHoveringOver = inside ? index : -1
                    }
                    
                }
            }
            newFeatureTextField
        }.padding(.horizontal)
        
    }
    
    func handleNewFeatureSequence() {
        if self.tempNewFeatureInField != "" {
            self.listOfTempFeatures.append(self.tempNewFeatureInField)
            self.tempNewFeatureInField = ""
        }
    }
    
}


