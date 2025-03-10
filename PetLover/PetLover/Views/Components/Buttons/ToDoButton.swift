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
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1)
                            .foregroundStyle( Color.AppColors.secondary60BlueishGray)
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.AppColors.primary20NearWhite)
                    }
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(lineWidth: 1)
                    .foregroundStyle( Color.AppColors.secondary60BlueishGray)
            }
        }
        
    }
}

#Preview {
    ToDoButton() {}
}
