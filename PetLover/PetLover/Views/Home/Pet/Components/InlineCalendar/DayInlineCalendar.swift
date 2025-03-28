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
        VStack(spacing: 16) {
            Text(date.formatted(.dateTime .month(.abbreviated)))
                .appFontDarkerGrotesque(darkness: .Bold, size: 13)
            
            Text(date.formatted(.dateTime .day(.twoDigits)))
                .appFontDarkerGrotesque(darkness: .ExtraBold, size: 17)
        }
        .foregroundStyle(isSelected ? .white : .AppColors.secondary60BlueishGray)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.orange)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundStyle(Color.AppColors.secondary60BlueishGray)
            }
        }
    }
    
    func selected(_ isSelected : Bool) -> Self {
        DayInlineCalendar(date: self.date, isSelected: isSelected)
    }
}

#Preview {
    DayInlineCalendar(date: .now)
}
