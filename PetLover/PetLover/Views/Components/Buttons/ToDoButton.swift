//
//  ToDoButton.swift
//  PetLover
//
//  Created by Izadora Montenegro on 10/03/25.
//

import SwiftUI

struct ToDoButton: View {
    @State var isCompleted: Bool
    var action: () -> Void
    
    init(isCompleted: Bool = false, action: @escaping () -> Void) {
        self.isCompleted = isCompleted
        self.action = action
    }
    
    var body: some View {
        Button {
            isCompleted.toggle()
            action()
        } label: {
            if isCompleted {
                RoundedRectangle(cornerRadius: 4)
                    .fill( Color.AppColors.helperSuccessGreen)
                    .overlay {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(lineWidth: 1)
                                .foregroundStyle( Color.accent)
                            Image("IconCheck")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.AppColors.primary20NearWhite)
                                .padding(5)
                        }
                    }
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color.accent)
            }
        }
        
    }
}

#Preview {
    ToDoButton() {}
}
