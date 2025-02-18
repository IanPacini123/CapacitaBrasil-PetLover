//
//  TabHome.swift
//  Petlover
//
//  Created by Ian Pacini on 11/02/25.
//

import SwiftUI

struct TabHome: View {
    var body: some View {
        TabView {
            Tab {
                Text("Home")
            } label: {
                Text("Test2")
            }
            Tab {
                Text("2")
            } label: {
                Text("Test")
            }
        }
    }
}

#Preview {
    TabHome()
}
