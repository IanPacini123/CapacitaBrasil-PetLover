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
    var body: some View {
        TabView {
            PetHomeView()
                .tabItem {
                    Label("Início", systemImage: "house")
                }
                        
            PetList()
                .tabItem {
                    Label("Pets", image: "IconPaw")
                }
            
            
            ConfigView()
                .tabItem {
                    Label("Ajustes", image: "IconGear")
                }
        }
    }
}

#Preview {
    ContentView()
}


