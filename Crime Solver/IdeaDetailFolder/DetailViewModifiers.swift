//
//  DetailViewModifiers.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 08/02/2021.
//

import Foundation
import SwiftUI

struct DetailsBodyFont : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.custom("Montserrat-Regular", size: 14))
            .multilineTextAlignment(.leading)
    }
}
struct TitleDetailText : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.custom("SourceCodePro-Light", size: 35))
            .foregroundColor(Color("LimeGreenWelcome"))
    }
}
