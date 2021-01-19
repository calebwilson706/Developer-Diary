//
//  SecretCodeClass.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 19/01/2021.
//

import Foundation
import SwiftUI

class SecretText : ObservableObject {
    @Published var english : String
    @Published var greek : String
    
    init(plain : String) {
        let dictOfChars : [Character:Character] = [
            "a" : "Γ",
            "b" : "β",
            "c" : "γ",
            "d" : "δ",
            "e" : "ε",
            "f" : "ζ",
            "g" : "η",
            "h" : "θ",
            "i" : "Ξ",
            "j" : "ι",
            "k" : "κ",
            "l" : "λ",
            "m" : "μ",
            "n" : "ν",
            "o" : "ξ",
            "p" : "π",
            "q" : "ο",
            "r" : "ρ",
            "s" : "Σ",
            "t" : "τ",
            "u" : "υ",
            "v" : "φ",
            "w" : "χ",
            "x" : "ψ",
            "y" : "Ψ",
            "z" : "ω"
        ]
        self.english = plain
        self.greek = (plain.lowercased().map {dictOfChars[$0] ?? $0}).reduce("", {acc,char in
            acc + String(char)
        })
    }
}

struct SecretTextView : View {
    @Binding var isSecret : Bool
    @ObservedObject var theSetOfStrings : SecretText
    var body : some View {
        Text(isSecret ? theSetOfStrings.greek : theSetOfStrings.english)
    }
}
