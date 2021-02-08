//
//  IdeasFormModifiers.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
import SwiftUI

struct SaveButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background((configuration.isPressed ? Color("LimeGreenWelcome") : Color.gray).cornerRadius(10))
            .foregroundColor(configuration.isPressed ? Color.gray : Color.white)
            .font(.custom("SourceCodePro-SemiBold", size: 18))
            .modifier(cursorForButtonStyleMod())
    }
}

struct CloseButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("SourceCodePro-SemiBold", size: 13))
            .background(EmptyView())
            .foregroundColor(configuration.isPressed ? Color.primary : Color.secondary)
            .modifier(cursorForButtonStyleMod())
    }
}

struct cursorForButtonStyleMod : ViewModifier {
    func body(content: Content) -> some View {
        return content.onHover { inside in
            if inside {
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



