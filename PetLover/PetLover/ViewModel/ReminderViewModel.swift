//
//  ReminderViewModel.swift
//  PetLover
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 03/04/25.
//

import SwiftData
import Foundation
import SwiftUI

class ReminderViewModel: ObservableObject {
    
    func createReminder(
        context: ModelContext,
        pet: Pet,
        title: String,
        date: Date,
        category: ReminderCategory,
        repeatDays: Set<WeekDays> = [],
        startTime: Date,
        endTime: Date? = nil
    ) {
        let newReminder = Reminder(
            title: title,
            date: date,
            category: category,
            repeatDays: repeatDays,
            startTime: startTime,
            endTime: endTime
        )
        
        pet.reminders.append(newReminder)
        context.insert(newReminder)
        
        do {
            try context.save()
        } catch {
            print("Erro ao salvar lembrete: \(error.localizedDescription)")
        }

    }
    
//    func fetchReminder(context: ModelContext) {
//        do {
//            let descriptor = FetchDescriptor<Pet>(sortBy: [SortDescriptor(\.name)])
//            pets = try context.fetch(descriptor)
//        } catch {
//            print("Pets não encontrados")
//        }
//    }
}


struct ReminderView: View {
    @StateObject var viewModel = ReminderViewModel()
    @StateObject var petViewModel = PetViewModel()
    @Environment(\ .modelContext) private var context
    @State var title: String = ""
    @State var date = Date()
    @State var category: ReminderCategory = .eventos
    @State var startTime = Date()
    @State var endTime = Date()
    @State var repeatDays: Set<WeekDays> = []
    @State var selectedPet: Pet?
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    ForEach(petViewModel.pets, id: \.id) { pet in
                        VStack {
                            Text(pet.name)
                            Text(pet.reminders.first?.title ?? "Sem lembrete")
                        }
                        
                    }
                }
                
                Text("Selecione um Pet")
                Picker("Pet", selection: $selectedPet) {
                    ForEach(petViewModel.pets, id: \..id) { pet in
                        Text(pet.name).tag(pet as Pet?)
                    }
                }
                .pickerStyle(.menu)
                
                TextField("Título do lembrete", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                DatePicker("Data", selection: $date, displayedComponents: .date)
                DatePicker("Hora de início", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("Hora de fim", selection: $endTime, displayedComponents: .hourAndMinute)
                
                Picker("Categoria", selection: $category) {
                    ForEach(ReminderCategory.allCases, id: \..self) {
                        Text($0.displayText).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                
                ReminderRepeaterList(selectedDays: $repeatDays)
                
                
            }
        }
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Selecione um Pet")
//                Picker("Pet", selection: $selectedPet) {
//                    ForEach(petViewModel.pets, id: \..id) { pet in
//                        Text(pet.name).tag(pet as Pet?)
//                    }
//                }
//                .pickerStyle(.menu)
//
//                TextField("Título do lembrete", text: $title)
//                    .textFieldStyle(.roundedBorder)
//
//                DatePicker("Data", selection: $date, displayedComponents: .date)
//                DatePicker("Hora de início", selection: $startTime, displayedComponents: .hourAndMinute)
//                DatePicker("Hora de fim", selection: $endTime, displayedComponents: .hourAndMinute)
//
//                Picker("Categoria", selection: $category) {
//                    ForEach(ReminderCategory.allCases, id: \..self) {
//                        Text($0.displayText).tag($0)
//                    }
//                }
//                .pickerStyle(.segmented)
//
//                ReminderRepeaterList(selectedDays: $repeatDays)
//
//                Button("Salvar Lembrete") {
//                  //
//                }
//                .buttonStyle(.borderedProminent)
//                .padding(.top)
//
//                Divider()
//
//                ForEach(petViewModel.pets, id: \..id) { pet in
//                    VStack(alignment: .leading) {
//                        Text(pet.name).font(.headline)
//                        ForEach(pet.reminders, id: \..id) { reminder in
//                            HStack {
//                                Text(reminder.title)
//                                Spacer()
//                                Text(reminder.date, style: .date)
//                            }
//                            .padding(.vertical, 2)
//                        }
//                    }
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                }
//            }
//            .padding()
//        }
    }
}

#Preview {
    ReminderView()
}
