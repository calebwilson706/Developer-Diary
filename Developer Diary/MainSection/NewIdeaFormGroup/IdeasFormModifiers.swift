//
//  IdeasFormModifiers.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
import SwiftUI

struct SaveButtonStyle : ButtonStyle {
    var background : Color
    var foreground : Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background((configuration.isPressed ? Color("LimeGreenWelcome") : background).cornerRadius(10))
            .foregroundColor(configuration.isPressed ? Color.black : foreground)
            .font(.custom("SourceCodePro-SemiBold", size: 18))
            .modifier(cursorForButtonStyleMod())
    }
}

struct CloseButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(BaseForCloseButtonStyle())
            .modifier(cursorForButtonStyleMod())
    }
}

struct BaseForCloseButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("SourceCodePro-SemiBold", size: 13))
            .background(EmptyView())
            .foregroundColor(configuration.isPressed ? Color.primary : Color.secondary)
    }
}

struct cursorForButtonStyleMod : ViewModifier {
    var disableThisFeature = false
    func body(content: Content) -> some View {
        return content.onHover { inside in
            if inside && !disableThisFeature {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}


struct HeaderFormFont : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.custom("SourceCodePro-Light", size: 15))
            .foregroundColor(Color("LimeGreenWelcome"))
    }
}
struct MiniHeaderFormFont : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.custom("SourceCodePro-Light", size: 11))
            .foregroundColor(Color("LimeGreenWelcome"))
    }
}

struct ManualTextFieldAnimationCursor : ViewModifier {
    func body(content: Content) -> some View {
        return content.onHover { inside in
            if inside {
                NSCursor.iBeam.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}


struct ExitButtonEditModeStyle : ButtonStyle {
    var isEditModeOn : Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isEditModeOn ? (configuration.isPressed ? Color.white : Color("LimeGreenWelcome")) : (configuration.isPressed ? Color.primary : Color.secondary))
            .background(Color.clear)
            .font(.custom("SourceCodePro-SemiBold", size: (isEditModeOn ? 20 : 15)))
            
    }
}


