//
//  AddReminderSheet.swift
//  PetLover
//
//  Created by Ian Pacini on 08/04/25.
//

import SwiftUI

struct AddReminderSheet: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            HStack {
                
            }
        }
    }
}

#Preview {
    @Previewable @State var isShowing = true
    
    Button("Abrir sheet") {
        isShowing = true
    }
    .sheet(isPresented: $isShowing) {
        AddReminderSheet(isShowing: $isShowing)
    }
}
