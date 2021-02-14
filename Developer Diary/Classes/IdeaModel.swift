//
//  IdeaModel.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
//enum Difficulty : String {
//    case EASY = "easy",
//         MEDIUM = "medium",
//         HARD = "hard"
//}
//struct Feature {
//    private var difficulty : Difficulty
//    private var feature : String
//}
class Assignment : ObservableObject,Codable {
    enum CodingKeys : CodingKey {
        case title, description, features,completedFeatures, tags, dateOfCreation, id
    }
    
    @Published var title : String
    @Published var description : String
    
    @Published var features : [String]
    @Published var completedFeatures : [String]
    
    @Published var tags : [String]
    @Published var dateOfCreation : Date
    @Published var id : UUID
    
    init(title : String,description : String, features : [String], tags : [String],completedFeatures : [String]) {
        self.title = title
        self.description = description
        self.features = features
        self.completedFeatures = completedFeatures
        self.tags = tags
        self.dateOfCreation = Date()
        self.id = UUID()
    }
    
    func addFeature(feature : String){
        self.features.append(feature)
    }
    func addTag(tag : String){
        self.tags.append(tag)
    }
    func moveFeatureToCompleted(feature : String){
        self.completedFeatures.append(feature)
        self.features.removeAll {$0 == feature}
    }
    //Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        features = try container.decode([String].self, forKey: .features)
        tags = try container.decode([String].self, forKey: .tags)
        dateOfCreation = try container.decode(Date.self, forKey: .dateOfCreation)
        id = try container.decode(UUID.self, forKey: .id)
        completedFeatures = try container.decode([String].self, forKey: .completedFeatures)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(features,forKey: .features)
        try container.encode(tags,forKey: .tags)
        try container.encode(dateOfCreation,forKey: .dateOfCreation)
        try container.encode(id, forKey: .id)
        try container.encode(completedFeatures, forKey: .completedFeatures)
    }
}

class ListOfAssignments : ObservableObject {
    @Published var assignments = [Assignment]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(assignments) {
                UserDefaults.standard.set(encoded, forKey: "AssignmentListStorage")
            }
        }
    }
    
    init() {
        if let myAssignments = UserDefaults.standard.data(forKey: "AssignmentListStorage") {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([Assignment].self, from: myAssignments){
                self.assignments = decoded
                return
            }
        }
        
        self.assignments = []
    }
}
