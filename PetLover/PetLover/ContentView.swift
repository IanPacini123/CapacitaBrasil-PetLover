//
//  ContentView.swift
//  PetLover
//
//  Created by Ian Pacini on 26/02/25.
//

import SwiftUI

enum Destination: Hashable {
    case petDocuments
    case petMedicalConditions
    case petProfile
    case petBasicInfo
}

struct ContentView: View {
    @State var path = NavigationPath()
    @StateObject var petCreationViewModel = PetCreationViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            TabView {
                PetHomeView(path: $path)
                    .tabItem {
                        Label("Início", systemImage: "house")
                    }
                
                PetHomeView(path: $path)
                    .tabItem {
                        Label("Pets", image: "IconPaw")
                    }
                
                PetHomeView(path: $path)
                    .tabItem {
                        Label("Ajustes", image: "IconGear")
                    }
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .petDocuments:
                    PetDocumentsView(petCreationViewModel: petCreationViewModel, path: $path)
                case .petMedicalConditions:
                    PetMedicalConditionsView(petCreationViewModel: petCreationViewModel, path: $path)
                case .petProfile:
                    PetProfileView(petCreationViewModel: petCreationViewModel, path: $path)
                case .petBasicInfo:
                    PetBasicInfoView(petCreationViewModel: petCreationViewModel, path: $path)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}


