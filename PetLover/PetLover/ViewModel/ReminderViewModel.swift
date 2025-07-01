//
//  ReminderViewModel.swift
//  PetLover
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 03/04/25.
//

import SwiftData
import Foundation
import SwiftUI

@Observable
class ReminderViewModel {
    var reminders = [Reminder]()
    
    static var shared: ReminderViewModel = .init()
    
    private init() {}
    
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
            petId: UUID(),
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
    
    func updateReminder(
        context: ModelContext,
        reminder: Reminder,
        title: String? = nil,
        date: Date? = nil,
        category: ReminderCategory? = nil,
        repeatDays: Set<WeekDays>? = nil,
        startTime: Date? = nil,
        endTime: Date? = nil
    ) {
        reminder.title = title ?? reminder.title
        reminder.date = date ?? reminder.date
        reminder.category = category ?? reminder.category
        reminder.repeatDays = repeatDays ?? reminder.repeatDays
        reminder.startTime = startTime ?? reminder.startTime
        reminder.endTime = endTime ?? reminder.endTime

        do {
            try context.save()
        } catch {
            print("Erro ao atualizar lembrete: \(error.localizedDescription)")
        }
    }

    func deleteReminder(context: ModelContext, pet: Pet, reminder: Reminder) {
        pet.reminders.removeAll { $0.id == reminder.id }
        context.delete(reminder)

        do {
            try context.save()
        } catch {
            print("Erro ao remover lembrete: \(error.localizedDescription)")
        }
    }
}

private struct ReminderView: View {
    @Environment(\.modelContext) private var context
    private var viewModel = ReminderViewModel.shared
    private var petViewModel = PetViewModel.shared
    
    @State private var title: String = ""
    @State private var date = Date()
    @State private var category: ReminderCategory = .eventos
    @State private var startTime = Date()
    @State private var endTime: Date? = nil
    @State private var repeatDays: Set<WeekDays> = []
    @State private var selectedPet: Pet?
    @State private var endTimePresent: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Criar lembrete:")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Selecione um pet:")
                if !petViewModel.pets.isEmpty {
                    Picker("Pet", selection: $selectedPet) {
                        ForEach(petViewModel.pets, id: \.id) { pet in
                            Text(pet.name).tag(pet as Pet?)
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("Nenhum pet adicionado")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Text("Título do lembrete:")
                TextField("Título do lembrete", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                DatePicker("Data", selection: $date, displayedComponents: .date)
                DatePicker("Hora de início", selection: $startTime, displayedComponents: .hourAndMinute)
                
                Toggle("Hora de fim", isOn: $endTimePresent)
                
                if endTimePresent {
                    DatePicker("Hora de fim", selection: Binding(
                        get: { endTime ?? Date() },
                        set: { endTime = $0 }
                    ), displayedComponents: .hourAndMinute)
                }
                
                Picker("Categoria", selection: $category) {
                    ForEach(ReminderCategory.allCases, id: \.self) {
                        Text($0.displayText).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                
                ReminderRepeaterList(selectedDays: $repeatDays)
                
                Button("Salvar Lembrete") {
                    
                    guard let pet = selectedPet else { return }
                    
                    viewModel.createReminder(
                        context: context,
                        pet: pet,
                        title: title,
                        date: date,
                        category: category,
                        repeatDays: repeatDays,
                        startTime: startTime,
                        endTime: endTimePresent ? endTime : nil
                    )
                    
                    title = ""
                    date = Date()
                    startTime = Date()
                    endTime = nil
                    endTimePresent = false
                    repeatDays = []
                    
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Text("Lista de lembretes:")
                    .font(.title)
                    .fontWeight(.semibold)
                
                ForEach(petViewModel.pets, id: \.id) { pet in
                    if !pet.reminders.isEmpty {
                        VStack(alignment: .leading) {
                            Text(pet.name)
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            ForEach(pet.reminders, id: \.id) { reminder in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Título: \(reminder.title)")
                                        .font(.headline)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            petViewModel.fetchPets(context: context)
        }
    }
}

#Preview {
    ReminderView()
        .modelContainer(for: [Pet.self, Reminder.self], inMemory: true)
}
