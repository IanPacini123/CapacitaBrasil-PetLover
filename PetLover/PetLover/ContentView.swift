//
//  ContentView.swift
//  PetLover
//
//  Created by Ian Pacini on 26/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .font(.system(size: 64))
            Text("Hello, world!")
                .font(.custom("DarkerGrotesque", size: 64))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


