//
//  IdeaDetailView.swift
//  Crime Solver
//
//  Created by Caleb Wilson on 07/02/2021.
//

import Foundation
import SwiftUI

struct IdeaDetailView : View {
    @ObservedObject var idea : Assignment
    @EnvironmentObject var localListOfAssignemntsForediting : ListOfAssignments
    var body : some View {
        VStack{
            Text("hello world")
        }
    }
}
