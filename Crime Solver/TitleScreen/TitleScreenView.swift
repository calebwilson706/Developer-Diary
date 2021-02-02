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
    
    @State private var currSubViewIndex = 0
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
                        self.currSubViewIndex = 1
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
            Color.black
            VStack {
                
                StackNavigationView (
                        currentSubviewIndex : self.$currSubViewIndex,
                        showingSubview : self.$nextViewShows,
                        subviewByIndex: { index in
                            subView(for: index)
                        }
                    ){
                    VStack(spacing : 0){
                        HeaderView()
                            Spacer()
                            welcometextAnimated
                            introText.transition(.move(edge: .bottom))
                            Spacer()
                        }
                    }
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
            withAnimation(.easeInOut(duration : 1.1)) {
                self.showIntroText.toggle()
            }
            self.cementTitleInPlace = true
        }
        
    }
    
    func subView(for index : Int) -> AnyView {
        switch index {
          case 1: return AnyView(Text("View 1").frame(maxWidth: .infinity, maxHeight: .infinity))
          default: return AnyView(Text("error").frame(maxWidth: .infinity, maxHeight: .infinity))
        }
    }
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView()
    }
}
