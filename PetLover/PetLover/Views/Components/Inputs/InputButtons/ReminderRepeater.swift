//
//  ReminderRepeater.swift
//  PetLover
//
//  Created by Izadora Montenegro on 31/03/25.
//

import SwiftUI

struct ReminderRepeaterList: View {
    @Binding var selectedDays: Set<WeekDays>
    @State var isActive: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Toggle(isOn: $isActive) {
                Text("Repetir")
                    .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
            }
            
            HStack(spacing: 6) {
                ForEach(WeekDays.allCases, id: \.self) { dia in
                    ReminderRepeaterButton(selectedDays: $selectedDays, isActive: $isActive, dia: dia)
                }
            }
        }
        .onChange(of: isActive) {
            selectedDays.removeAll()
        }
    }
}

struct ReminderRepeaterButton: View {
    @Binding var selectedDays: Set<WeekDays>
    @Binding var isActive: Bool
    
    var dia: WeekDays
    
    var body: some View {
        Button(action: {
            if selectedDays.contains(dia) {
                selectedDays.remove(dia)
            } else {
                selectedDays.insert(dia)
            }
        }) {
            Text(dia.displayText)
                .appFontDarkerGrotesque(darkness: .ExtraBold, size: 17)
                .padding()
                .background((selectedDays.contains(dia) && isActive) ? Color.AppColors.primary50Orange : Color.white)
                .foregroundColor((selectedDays.contains(dia) && isActive) ? Color.white : Color.AppColors.secondary60BlueishGray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.AppColors.secondary60BlueishGray)
                }
        }
//        .frame(width: 44, height: 55)
        .disabled(!isActive)
        .buttonStyle(.borderless)
    }
}


#Preview {
    @Previewable @State var selectedDays: Set<WeekDays> = []
    Form {
        Section {
            ReminderRepeaterList(selectedDays: $selectedDays)
        }
    }
}
