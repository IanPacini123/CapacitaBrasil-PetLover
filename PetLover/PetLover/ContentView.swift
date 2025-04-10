//
//  ContentView.swift
//  PetLover
//
//  Created by Ian Pacini on 26/02/25.
//

import SwiftUI

enum PetFlowDestination: Hashable {
    case petDocuments
    case petMedicalConditions
    case petProfile
    case petBasicInfo
}

struct ContentView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Hello, world!")
                    .font(.system(size: 64))
                Text("Hello, world!")
                    .font(.custom("DarkerGrotesque", size: 64))
                Button(action: {
                    path.append(PetFlowDestination.petBasicInfo)
                }, label: {
                    Text("ir")
                        .font(.title)
                })
            }
            .padding()
            .navigationDestination(for: PetFlowDestination.self) { destination in
                switch destination {
                case .petDocuments:
                    PetDocumentsView(path: $path)
                case .petMedicalConditions:
                    PetMedicalConditionsView(path: $path)
                case .petProfile:
                    PetProfileView(path: $path)
                case .petBasicInfo:
                    PetBasicInfoView(path: $path)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
