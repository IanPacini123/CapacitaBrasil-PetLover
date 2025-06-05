//
//  AddReminderSheet.swift
//  PetLover
//
//  Created by Ian Pacini on 08/04/25.
//

import SwiftUI

struct AddReminderSheet: View {
    var petViewModel = PetViewModel.shared
    var reminderViewModel = ReminderViewModel.shared

    @Environment(\.modelContext) private var context
    
    @State var selectedpet: Pet? = nil {
        didSet {
            if let uuid = selectedpet?.id {
                self.petId = uuid
            }
        }
    }
    
    @State var petId: UUID?
    @State var title: String = ""
    @State var date: Date = .now
    @State var category: ReminderCategory?
    @State var repeatDays: Set<WeekDays> = []
    @State var startTime: Date
    @State var endTime: Date
    
    @Binding var isShowing: Bool
    @State private var error: [reminderSheetErrorCase] = []
    @State var shownDate: Date? = nil
    
    
    init(isShowing: Binding<Bool>) {
        self._isShowing = isShowing
        
        var components = DateComponents()
        components.hour = 12
        components.minute = 0
        components.second = 0
        let date = Calendar.current.date(from: components) ?? .now
        
        self.startTime = date
        self.endTime = date
    }
    
    var body: some View {
        VStack {
            formHeader
            
            Form {
                Group {
                    Section {
                        PetSelectorList(pets: petViewModel.pets, selectedPet: $selectedpet)
                    } header: {
                        Text("Selecione o seu pet")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                            .textCase(nil)
                            .foregroundStyle(.black)
                    }
                    
                    Section {
                        SinglelineTextField(text: $title, buttonPressed: .constant(false), isOptional: false, label: "Título", fieldTitle: "")
                    } header: {
                        Text("Título do Lembrete")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                            .textCase(nil)
                            .foregroundStyle(.black)
                    }
                    
                    Section {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                InputButton(label: "Eventos", isSelected: $category.wrappedValue == .eventos) {
                                    if self.category == .eventos {
                                        
                                    } else {
                                        self.category = .eventos
                                    }
                                }
                                InputButton(label: "Cuidados diários", isSelected: $category.wrappedValue == .cuidadosDiarios) {
                                    self.category = .cuidadosDiarios
                                }
                                InputButton(label: "Saúde", isSelected: $category.wrappedValue == .saude) {
                                    self.category = .saude
                                }
                            }
                            .padding(4)
                        }
                        .font(.appFontDarkerGrotesque(darkness: .Bold, size: 17))
                    } header: {
                        Text("Categoria")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                            .textCase(nil)
                            .foregroundStyle(.black)
                    }
                    
                    Section {
                        TimeSelect(startingDate: $startTime, endingDate: $endTime)
                    } header: {
                        Text("Horário")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                            .textCase(nil)
                            .foregroundStyle(.black)
                    }
                    
                    Section {
                        HStack {
                            Text(shownDate?.formatted(date: .abbreviated, time: .omitted) ?? "para qual data?")
                                .appFontDarkerGrotesque(darkness: .Medium, size: 14)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                                .foregroundStyle(.black)
                        }
                        .overlay {
                            HStack {
                                DatePicker("",
                                           selection: $date,
                                           displayedComponents: .date)
                                DatePicker("",
                                           selection: $date,
                                           displayedComponents: .date)
                            }
                            .blendMode(.destinationOver)
                        }
                    } header: {
                        Text("Data")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                            .textCase(nil)
                            .foregroundStyle(.black)
                    }

                    
                    Section {
                        ReminderRepeaterList(selectedDays: $repeatDays)
                    }
                }
                .listRowInsets(.init(top:4, leading: 4, bottom: 4, trailing: 4))
            }
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            petViewModel.fetchPets(context: context)
        }
        .onChange(of: date) { _, _ in
            shownDate = date
        }
    }
    
    private var formHeader: some View {
        HStack {
            Button {
                isShowing = false
            } label: {
                Image(systemName: "multiply")
                    .font(.custom("", size: 30))
            }
            
            Spacer()
            
            Button {
                // TODO: Logica de adicionar reminder nos dados do usuario.
                do {
                    guard let pet = selectedpet else {
                        throw reminderSheetErrorCase.selectPet
                    }
                    guard let category = category else {
                        throw reminderSheetErrorCase.addCategory
                    }
                    if title == "" {
                        throw reminderSheetErrorCase.addTitle
                    }
                    
                    reminderViewModel.createReminder(context: context,
                                                     pet: pet,
                                                     title: title,
                                                     date: date,
                                                     category: category,
                                                     startTime: startTime)
                } catch {
                    checkFields()
                }
            } label: {
                Text("Concluir")
                    .appFontDarkerGrotesque(darkness: .SemiBold, size: 17)
                    .foregroundStyle(hasFieldMissing() ?
                                     Color.AppColors.secondary60BlueishGray :
                                        Color.AppColors.secondary40Blue)
            }
            .disabled(hasFieldMissing())
        }
        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
        .padding(.horizontal, 18)
        .padding(20)
        .overlay {
            Text("Adicionar")
                .appFontDarkerGrotesque(darkness: .Black, size: 32)
                .foregroundStyle(Color.AppColors.secondary60BlueishGray)
        }
    }
    
    private func checkFields() {
        self.error = []
        if checkHasPet() {
            self.error.append(.selectPet)
        }
        if checkHasCategory() {
            self.error.append(.addCategory)
        }
        if checkHasTitle() {
            self.error.append(.addTitle)
        }
    }
    
    private func hasErrorCase() -> Bool {
        checkFields()
        
        if self.error.isEmpty { return false }
        
        return true
    }
    
    private func hasFieldMissing() -> Bool {
        return (!checkHasPet() || !checkHasTitle() || !checkHasCategory())
    }
    
    private func checkHasPet() -> Bool {
        return self.selectedpet != nil
    }
    
    private func checkHasTitle() -> Bool {
        self.title != ""
    }
    
    private func checkHasCategory() -> Bool {
        self.category != nil
    }
    
    private func generateReminder() -> Reminder? {
        guard let category = self.category else {
            return nil
        }
        let newReminder = Reminder(petId: petId ?? UUID(),
                                   title: title,
                                   date: startTime,
                                   category: category,
                                   startTime: startTime)
        
        return newReminder
    }
    
    private enum reminderSheetErrorCase: Error {
        case selectPet, addTitle, addCategory
    }
}

#Preview {
    @Previewable @State var isShowing = true
    
    VStack {
        Button("Abrir sheet") {
            isShowing = true
        }
    }
    .sheet(isPresented: $isShowing) {
        AddReminderSheet(isShowing: $isShowing)
    }
}
