//
//  TitleScreenModifiers.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 18/01/2021.
//

import SwiftUI

struct WelcomeText : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.custom("SourceCodePro-Light", size: 20))
            .foregroundColor(Color("LimeGreenWelcome"))                  
    }
}
