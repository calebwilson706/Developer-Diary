//
//  IdeaModel.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
enum Difficulty : String {
    case EASY = "easy",
         MEDIUM = "medium",
         HARD = "hard"
}
struct Feature {
    private var difficulty : Difficulty
    private var feature : String
}
class Assignment : ObservableObject {
    @Published private var title : String
    @Published private var description : String
    @Published private var features : [Feature]
    @Published private var tags : [String]
    @Published private var dateOfCreation : Date
    
    init(title : String,description : String, features : [Feature], tags : [String]) {
        self.title = title
        self.description = description
        self.features = features
        self.tags = tags
        self.dateOfCreation = Date()
    }
    
    func addFeature(feature : Feature){
        self.features.append(feature)
    }
    func addTag(tag : String){
        self.tags.append(tag)
    }
}

class ListOfAssignments : ObservableObject {
    var assignments = [Assignment]()
}
