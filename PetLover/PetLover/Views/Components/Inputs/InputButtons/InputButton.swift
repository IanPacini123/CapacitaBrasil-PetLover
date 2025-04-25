//
//  InputButton.swift
//  PetLover
//
//  Created by Ian Pacini on 17/03/25.
//

import SwiftUI

struct InputButton: View {
    var label: String
    var isSelected: Bool
    var action: () -> Void
    
    init(label: String, isSelected: Bool, action: @escaping () -> Void) {
        self.label = label
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .foregroundStyle(isSelected ? .white : .black)
                .padding(.vertical, 10)
                .padding(.horizontal, 42)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.AppColors.secondary40Blue)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(.black)
                    }
                    
                }
        }
    }
}

#Preview {
    @Previewable @State var isSelected = false
    
    InputButton(label: "Testing", isSelected: $isSelected.wrappedValue) {
        print("teste")
    }
}
