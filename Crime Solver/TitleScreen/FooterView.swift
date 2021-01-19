//
//  Footerview.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 18/01/2021.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack {
            Text("Created By Caleb Wilson.").foregroundColor(.gray).font(.footnote)
            Spacer()
        }.padding(.all)
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView()
    }
}
