//
//  ContentView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 18/01/2021.
//

import SwiftUI

struct TitleScreenView: View {
    @State private var myWelcometext = "..."
    @State private var showIntroText = false
    @State private var isSecretText = false
    @State private var cementTitleInPlace = false
    
    @State var nextViewShows = false
    
    @ObservedObject var navText = SecretText(plain: "YES")
    @ObservedObject var assignmentText = SecretText(plain: "Are You Ready For Your Assignement?")
    @ObservedObject var welcomeTextEncoded = SecretText(plain: "Welcome Agent...")
    var welcometextAnimated : some View {
        Group {
            if !cementTitleInPlace {
                Text(myWelcometext).onAppear {
                    self.loadWelcome(desiredEndString: "Welcome Agent...")
                }
            } else {
                SecretTextView(isSecret: $isSecretText, theSetOfStrings: welcomeTextEncoded)
            }
        }.modifier(WelcomeText())
    }
    var introText : some View {
        VStack {
            if showIntroText {
                SecretTextView(isSecret: $isSecretText, theSetOfStrings: assignmentText)
                    .modifier(IntroText())
                Group{
                    Button(action: {
                        self.nextViewShows.toggle()
                    }){
                        SecretTextView(isSecret: $isSecretText, theSetOfStrings: navText).modifier(NavLinkText())
                    }.buttonStyle(NavLinkButtonStyleTitlePage())
                }.onHover(perform: { hovering in
                    withAnimation(.easeIn(duration : 0.3)) {
                        self.isSecretText = hovering
                    }
                })
            }
        }.transition(.opacity)
    }
    var body: some View {
        ZStack {
            VStack {
                if !self.nextViewShows {
                    HeaderView()
                    Spacer()
                    welcometextAnimated
                    introText.transition(.move(edge: .bottom))
                    Spacer()
                    FooterView()
                } else {
                    ListOfIdeasView().edgesIgnoringSafeArea(.all)
                }
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
            withAnimation(.easeInOut(duration : 1.1)) {
                self.showIntroText.toggle()
            }
            self.cementTitleInPlace = true
        }
        
    }
    
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView()
    }
}
