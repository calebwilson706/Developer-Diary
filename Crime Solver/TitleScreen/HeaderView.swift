//
//  HeaderView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 18/01/2021.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Group{
                Image("SpyIconHead").resizable().scaledToFit()
            }.frame(height : 50, alignment: .center)
            Spacer()
        }.padding(.all)
    }
}
struct HeaderImage : View {
    var body : some View {
        Group{
            Image("SpyIconHead").resizable().scaledToFit()
        }.frame(height : 50, alignment: .center)
    }
}
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
