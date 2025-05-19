//
//  ReminderCard.swift
//  PetLover
//
//  Created by Izadora Montenegro on 29/04/25.
//

import SwiftUI

struct ReminderCard: View {
    @State var reminder: Reminder
    
    var body: some View {
        
            HStack(spacing: 0) {
                Color.AppColors.secondary60BlueishGray
                    .frame(width: 12)
                    .clipShape(Rectangle())
                
                HStack(spacing: 16) {
                    ToDoButton(action: {
                        reminder.isCompleted.toggle()
                    })
                    .frame(width: 23, height: 23)
                    VStack(alignment: .leading) {
                        Text(reminder.title)
                            .appFontDarkerGrotesque(darkness: .Bold, size: 18)
                        
                        categoryTag(category: reminder.category)
                        
                        HStack {
                            HStack(spacing: 2) {
                                Image("IconClock")
                                    .resizable()
                                    .scaledToFit()
                                Text("\(formattedTime(reminder.startTime))")
                                    .appFontDarkerGrotesque(darkness: .Bold, size: 11)
                            }
                            
                            if reminder.endTime != nil {
                                HStack(spacing: 2) {
                                    Image("IconClock")
                                        .resizable()
                                        .scaledToFit()
                                    Text("\(formattedTime(reminder.endTime!))")
                                        .appFontDarkerGrotesque(darkness: .Bold, size: 11)
                                }
                            }
                        }
                    }
                    Spacer()
                    Image("IconChevronRight")
                        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                }
                .padding(20)
                .background(Color.white)
            }
            .frame(height: 95)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.AppColors.secondary60BlueishGray, lineWidth: 1)
            )
    }
}


private func formattedTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

private struct categoryTag: View {
    var category: ReminderCategory
    var body: some View {
        Text(category.displayText)
            .appFontDarkerGrotesque(darkness: .Regular, size: 11)
            .padding(.horizontal, 5)
            .padding(.bottom, 2)
            .background(Color.AppColors.primary30Beige)
            .cornerRadius(40)
    }
}

#Preview {
    ReminderCard(
        reminder: Reminder(
            petId: UUID(), title: "Vacina Raiva",
            date: Date(),
            category: .saude,
            repeatDays: [.domingo, .quarta],
            startTime: Date(),
            endTime: Date()
        )
    )
    .padding(.horizontal)
}
