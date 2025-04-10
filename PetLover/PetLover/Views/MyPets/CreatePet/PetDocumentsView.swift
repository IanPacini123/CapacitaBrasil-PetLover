//
//  PetDocumentsView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/04/25.
//

import SwiftUI

struct PetDocumentsView: View {
    @Binding var path: NavigationPath
    var body: some View {
            VStack {
                Text("Informacoes")
        }
    }
}

#Preview {
    PetDocumentsView(
        path: .constant(NavigationPath())
    )
}
