//
//  ModalLembrete.swift
//  PetLover
//
//  Created by Izadora Montenegro on 30/04/25.
//

import SwiftUI
import SwiftData

struct ModalLembrete: View {
    @Environment(\.dismiss) private var dismiss

    var context: ModelContext
    var reminderViewModel: ReminderViewModel
    
    var pet: Pet
    var reminder: Reminder
    
    @State var selectedDays: Set<WeekDays> = []
    @State var isMenuVisible: Bool = false
    
    
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()
    
    let hourFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()


    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center) {
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("IconExit")
                    })
                    
                    Spacer()
                    
                    Text("Lembrete")
                        .appFontDarkerGrotesque(darkness: .Black, size: 32)
                        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                    
                    Spacer()
                    
                    Button(action: {
                        isMenuVisible.toggle()
                    }, label: {
                        Image("IconMenu")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 3)
                            .background(
                                isMenuVisible ? Color.AppColors.primary20NearWhite :  Color.clear
                            )
                            .cornerRadius(10)
                        
                    })
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(reminder.title)
                            .appFontDarkerGrotesque(darkness: .Black, size: 32)
                        
                        HStack {
                            Image("IconClock")
                            Text(hourFormatter.string(from: reminder.startTime))
                                .appFontDarkerGrotesque(darkness: .Medium, size: 19)
                        }
                        
                        if (reminder.endTime != nil) {
                            HStack {
                                Image("IconClock")
                                Text(hourFormatter.string(from: reminder.endTime ?? Date())) .appFontDarkerGrotesque(darkness: .Medium, size: 19)
                            }
                        }
                        
                        HStack {
                            Image("IconCalendar")
                            Text(formatter.string(from: reminder.date))
                                .appFontDarkerGrotesque(darkness: .Medium, size: 19)
                        }
                        
                        Divider()
                            .background(Color.AppColors.nearNeutralLightLightGray)
                    }
                    
                   
                        Text("Categoria")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                        
                        Text(reminder.category.displayText)               .appFontDarkerGrotesque(darkness: .Bold, size: 17)
                            .foregroundStyle(Color.AppColors.nearNeutralLightLightGray)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 12)
                            .background(
                                Color.AppColors.secondary40Blue
                            )
                            .cornerRadius(8)
                    
                    ReminderRepeaterList(selectedDays: $selectedDays)
                }
            }
            
            if isMenuVisible {
                VStack(alignment: .leading, spacing: 8) {
                    Button(action: {
                        // fazer ele ir pra tela de adicionar lembrete
                        isMenuVisible = false
                    }, label: {
                        Text("Editar")
                            .appFontDarkerGrotesque(darkness: .Bold, size: 17)
                            .foregroundStyle(Color.AppColors.secondary70DarkBlue)
                    })
                    
                    Rectangle()
                        .frame(width: 113, height: 1)
                    
                    Button(action: {
                        reminderViewModel.deleteReminder(context: context, pet: pet, reminder: reminder)
                        isMenuVisible = false
                    }, label: {
                        Text("Excluir")
                            .appFontDarkerGrotesque(darkness: .Bold, size: 17)
                            .foregroundStyle(Color.AppColors.secondary70DarkBlue)
                    })
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                }
                .padding(.top, 60)
            }
        }
        .padding()
    }
}
