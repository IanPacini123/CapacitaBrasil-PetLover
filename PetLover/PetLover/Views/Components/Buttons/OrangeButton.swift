//
//  OrangeButton.swift
//  PetLover
//
//  Created by Ian Pacini on 11/03/25.
//

import SwiftUI

struct OrangeButton: View {
    var text: () -> Text
    var icon: () -> Image
    
    var type: ButtonType
    var enabled: Bool
    
    var action: () -> Void
    
    init(type: ButtonType = .primary, enabled: Bool = true,
         @ViewBuilder text: @escaping () -> Text, @ViewBuilder icon: @escaping () -> Image, action: @escaping () -> Void) {
        self.type = type
        self.enabled = enabled
        
        self.text = text
        self.icon = icon
        
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
                        HStack {
                            text()
                            icon()
                                .frame(width: 24, height: 24)
                        }
                        .foregroundStyle(Color.white)
                    }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 4)
                    .fill(enabled ? Color.accentColor : Color.AppColors.lightGray)
                    .overlay {
                        HStack {
                            text()
                            icon()
                                .frame(width: 24, height: 24)
                        }
                        .foregroundStyle(enabled ? Color.accentColor : Color.AppColors.lightGray)
                        
                    }
            }
        }
        .font(.custom("DarkerGrotesque", size: 17))
        .disabled(!enabled)
    }
    
    func secondary() -> Self {
        OrangeButton(type: .secondary, enabled: self.enabled, text: self.text, icon: self.icon, action: self.action)
    }
    
    func disabled() -> Self {
        OrangeButton(type: self.type, enabled: false, text: self.text, icon: self.icon, action: self.action)
    }
}

#Preview {
    OrangeButton {
        Text("testing")
    } icon: {
        Image(systemName: "figure.archery")
    } action: {
        print("testing")
    }
//    .disabled()
    .secondary()

}
