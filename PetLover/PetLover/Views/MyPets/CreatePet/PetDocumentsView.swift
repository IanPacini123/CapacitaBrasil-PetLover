//
//  PetDocumentsView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/04/25.
//

import SwiftUI

struct PetDocumentsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Informacoes")
                NavigationLink(destination: PetInfosView(), label: {
                    Text("Ir")
                })
            }
        }
    }
}

#Preview {
    PetDocumentsView()
}
