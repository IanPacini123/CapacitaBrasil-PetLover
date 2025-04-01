//
//  DayInlineCalendar.swift
//  PetLover
//
//  Created by Ian Pacini on 27/03/25.
//

import SwiftUI

struct DayInlineCalendar: View {
    var date: Date
    var isSelected = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text(date.formatted(.dateTime .month(.abbreviated)))
                .appFontDarkerGrotesque(darkness: .Bold, size: 14)
            
            Text(date.formatted(.dateTime .day(.twoDigits)))
                .appFontDarkerGrotesque(darkness: .ExtraBold, size: 20)
        }
        .foregroundStyle(isSelected ? .white : .AppColors.secondary60BlueishGray)
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.orange)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                }
            }
        }
    }
    
    func selected(_ isSelected : Bool) -> Self {
        DayInlineCalendar(date: self.date, isSelected: isSelected)
    }
}

#Preview {
    @Previewable @State var isSelected = false
    Button {
        isSelected.toggle()
    } label: {
        DayInlineCalendar(date: .now)
            .selected(isSelected)
    }
}
