//
//  LargeButton.swift
//  PetLover
//
//  Created by Ian Pacini on 06/03/25.
//

import SwiftUI


struct LargeButton: View {
    var label: String
    
    var type: ButtonType
    var enabled: Bool
    
    var action: () -> Void
    
    init(label: String, type: ButtonType = .primary, enabled: Bool = true, action: @escaping () -> Void) {
        self.label = label
        self.type = type
        self.enabled = enabled
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            if type == .primary {
                RoundedRectangle(cornerRadius: 8)
                    .fill(enabled ? Color.accentColor : Color.AppColors.lightGray)
                    .overlay {
                        Text(label)
                            .foregroundStyle(.white)
                    }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 4)
                    .overlay {
                        Text(label)
                    }
                    .foregroundStyle(enabled ? Color.AppColors.secondary60BlueishGray : Color.AppColors.lightGray)
            }
        }
        .font(.custom("DarkerGrotesque", size: 22))
    }
    
    func secondary() -> Self {
        LargeButton(label: self.label, type: .secondary, enabled: self.enabled, action: self.action)
    }
    
    func disabled() -> Self {
        LargeButton(label: self.label, type: self.type, enabled: false, action: self.action)
    }
}

enum ButtonType {
    case primary
    case secondary
}

#Preview {
    LargeButton(label: "Teste") {
        print("teste")
    }
//        .secondary()
//        .disabled()
}
