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
            .font(.custom("SourceCodePro-Light", size: 45))
            .foregroundColor(Color("LimeGreenWelcome"))                  
    }
}

struct IntroText : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding(.all,5)
            .font(.custom("Montserrat-Italic", size: 20))
            .foregroundColor(Color("LimeGreenIntro"))
            
    }
}
struct NavLinkText : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.custom("Montserrat-Italic", size: 25))
            .padding(.horizontal,15)
    }
}

struct NavLinkButtonStyleTitlePage : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.black : Color("LimeGreenWelcome"))
            .background((configuration.isPressed ? Color("LimeGreenWelcome") : Color("DarkGreyNavLinkTitlePage")).cornerRadius(11.0))
    }
}
