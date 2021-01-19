//
//  ContentView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 18/01/2021.
//

import SwiftUI

struct TitleScreenView: View {
    @State var myWelcometext = "..."
    
    var welcometextAnimated : some View {
        Text(myWelcometext)
            .modifier(WelcomeText())
            .onAppear {
                self.loadWelcome(desiredEndString: "Welcome Agent...")
            }
    }
    var body: some View {
        ZStack {
            Color.black
            VStack {
                HeaderView()
                Spacer()
                welcometextAnimated
                Spacer()
                FooterView()
            }
        }
    }
    
    func loadWelcome(desiredEndString : String){
        self.myWelcometext = ""
        DispatchQueue.global(qos: .userInteractive).async {
            for char in desiredEndString {
                DispatchQueue.main.async {
                    myWelcometext += "\(char)"
                }
                Thread.sleep(forTimeInterval: 0.2)
            }
        }
    }
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView()
    }
}
