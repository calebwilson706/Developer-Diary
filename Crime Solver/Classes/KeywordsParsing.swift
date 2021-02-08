//
//  KeywordsParsing.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation

struct KeywordRelations : Codable {
    var word : String
    var usage : Int
}
struct ParseableKeys : Codable {
    var theTags : [KeywordRelations]
}
class KeyWordList : ObservableObject {
    @Published var keywords = [KeywordRelations]()
    
    init() {
        let text = getText()
        print(text)
        let components = text.split(separator: "\n")
        for item in components {
            let parsed = item.split(separator: ":")
            keywords.append(KeywordRelations(word: String(parsed[0]), usage: Int(parsed[1]) ?? 0))
        }
    
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func getText() -> String {
        let path = getDocumentsDirectory().appendingPathComponent("keywordsDictionary.txt")
        
        do {
            let myData = try String(contentsOf: path)
            return myData
        } catch {
            if error.localizedDescription == "The file “keywordsDictionary.txt” couldn’t be opened because there is no such file." {
                FileManager().createFile(atPath: path.absoluteString, contents: "".data(using: .utf8))
            }
        }
        
        return ""
    }
    
    func addKeyWord(word : String){
        let path = getDocumentsDirectory().appendingPathComponent("keywordsDictionary.txt")
        let indexOfWord = self.keywords.firstIndex(where: {$0.word == word.lowercased()})
        if indexOfWord != nil {
            self.keywords[indexOfWord!].usage += 1
            var newFileString = ""
            for item in keywords {
                newFileString.append("\(item.word):\(item.usage)\n")
            }
            do {
                try newFileString.write(to: path,atomically: true,encoding: .utf8)
            } catch {
                print(error)
            }
        } else {
            self.keywords.append(KeywordRelations(word: word.lowercased(), usage: 1))
            do {
                let str = word.lowercased() + ":0\n"
                try str.write(to: path, atomically: true, encoding: .utf8)
            } catch {
                print(error)
            }
        }
    }
    
    func clearFile(){
        let path = getDocumentsDirectory().appendingPathComponent("keywordsDictionary.txt")
        do {
            try "".write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}


