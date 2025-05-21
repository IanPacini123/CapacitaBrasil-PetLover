//
//  PetHomeView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/05/25.
//
import SwiftUI

struct PetHomeView: View {
    @Binding var path: NavigationPath
    @Environment(\.modelContext) private var context
    var viewModel = PetViewModel.shared
    
    @State private var selectedDate: Date = Date()
    @State var currentPet: Pet?
    @State private var selectedReminder: Reminder?
    @State private var selectedPetIndex = 0
    
    @State private var showAddReminderSheet: Bool = false
    @State private var showReminderSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                Color.AppColors.nearNeutralLightLightGray.ignoresSafeArea()
                
                RoundedCorner()
                    .fill(Color.white)
                    .frame(maxHeight: geometry.size.width * 0.9)
                    .ignoresSafeArea(.all)
                
                VStack {
                    Text("Love My Pet")
                        .appFontDarkerGrotesque(darkness: .Black, size: 32)
                        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                    
                    HStack {
                        if !(PetViewModel.shared.pets.isEmpty) {
                            Button(action: {
                                previousPetIndex()
                            }, label: {
                                Image("IconChevronRight")
                                    .rotationEffect(Angle(degrees: 180))
                                    .foregroundStyle(selectedPetIndex == 0 ? Color.AppColors.nearNeutralGrayGray : Color.AppColors.secondary60BlueishGray)
                            })
                        }
                        
                        VStack(spacing: 2) {
                            PetIdentifier(isEmpty: PetViewModel.shared.pets.isEmpty, petName: currentPet?.name ?? "", petImageData: currentPet?.photo, action: {
                                path.append(Destination.petBasicInfo)
                            })
                            .id(currentPet)
                            .padding(.horizontal, 100)
                            
                            if !(PetViewModel.shared.pets.isEmpty) {
                                IndicatorBar(numberOfPages: PetViewModel.shared.pets.count, currentPage: $selectedPetIndex)
                            }
                        }
                        
                        if !(PetViewModel.shared.pets.isEmpty) {
                            Button(action: {
                                nextPetIndex()
                            }, label: {
                                Image("IconChevronRight")
                                    .foregroundStyle((selectedPetIndex + 1) == PetViewModel.shared.pets.count ? Color.AppColors.nearNeutralGrayGray : Color.AppColors.secondary60BlueishGray)
                                
                            })
                        }
                    }
                    .padding(.horizontal)
                    
                    InlineCalendar(selectedDate: $selectedDate)
                        .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Lembretes")
                                .appFontDarkerGrotesque(darkness: .Black, size: 28)
                            Spacer()
                            Button(action: {
                                showAddReminderSheet = true
                            }, label: {
                                Image("IconPlus")
                            })
                        }
                        .padding(.horizontal)
                        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                        
                        if !viewModel.pets.isEmpty && selectedPetIndex < viewModel.pets.count {
                            let remindersForToday = viewModel.pets[selectedPetIndex].reminders.filter {
                                isSameDay($0.date, selectedDate)
                            }
                                if remindersForToday.isEmpty {
                                    Button(action: {
                                        showAddReminderSheet = true
                                    }, label: {
                                        EmptyStateNoReminders()
                                        .padding(.horizontal)
                                    })
                                } else {
                                    ScrollView(.vertical, showsIndicators: true) {
                                        VStack(spacing: 12) {
                                            ForEach(remindersForToday) { reminder in
                                                Button(action: {
                                                    selectedReminder = reminder
                                                    showReminderSheet = true
                                                       
                                                }, label: {
                                                    ReminderCard(reminder: reminder)
                                                })
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                        } else {
                            Button(action: {
                                path.append(Destination.petBasicInfo)
                            }, label: {
                                EmptyStateNoPets()
                                .padding(.horizontal)
                            })
                        }
                        
                    }
                }
            }
        }
        .onAppear {
            PetViewModel.shared.fetchPets(context: context)
            
            if !PetViewModel.shared.pets.isEmpty {
                currentPet = PetViewModel.shared.pets[selectedPetIndex]
            }
        }
        .sheet(isPresented: $showAddReminderSheet) {
            AddReminderSheet(isShowing: $showAddReminderSheet)
        }
        .sheet(item: $selectedReminder) { reminder in
            if let pet = currentPet {
                ModalLembrete(
                    path: $path,
                    context: context,
                    reminderViewModel: ReminderViewModel.shared,
                    pet: pet,
                    reminder: reminder
                )
                .presentationDetents([.fraction(0.6)])
            } else {
                Text("Pet não encontrado")
            }
        }

    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    private func previousPetIndex() {
        if selectedPetIndex > 0 {
            selectedPetIndex -= 1
            currentPet = PetViewModel.shared.pets[selectedPetIndex]
        }
    }
    
    private func nextPetIndex() {
        if selectedPetIndex < PetViewModel.shared.pets.count - 1 {
            selectedPetIndex += 1
            currentPet = PetViewModel.shared.pets[selectedPetIndex]
        }
    }
    
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: .init(x: rect.minX, y: rect.minY))
        
        path.addLine(to: .init(x: rect.maxX, y: rect.minY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY/2))
        
        path.addQuadCurve(to: .init(x: rect.midX, y: rect.maxY), control: .init(x: rect.maxX, y: rect.maxY))
        
        path.addQuadCurve(to: .init(x: rect.minX, y: rect.midY), control: .init(x: rect.minX, y: rect.maxY))
        
        path.addLine(to: .init(x: rect.minX, y: rect.minY))
        
        
        return Path(path.cgPath)
    }
}

struct EmptyStateNoPets: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text("Nenhum lembrete por aqui!")
                    .appFontDarkerGrotesque(darkness: .Bold, size: 18)
                Text("Adicione seu pet para começar.")
                    .appFontDarkerGrotesque(darkness: .Medium, size: 18)
            }
            
            Spacer()
            
            Image(systemName: "plus")
        }
        .padding(.horizontal)
        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
        .frame(height: 95)
        .background(Color.AppColors.primary30Beige)
        .cornerRadius(10)
    }
}

struct EmptyStateNoReminders: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text("Nenhum lembrete por aqui!")
                    .appFontDarkerGrotesque(darkness: .Bold, size: 18)
                Text("Adicione seu pet para começar.")
                    .appFontDarkerGrotesque(darkness: .Medium, size: 18)
            }
            
            Spacer()
            
            Image(systemName: "plus")
        }
        .padding(.horizontal)
        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
        .frame(height: 95)
        .background(Color.AppColors.primary30Beige)
        .cornerRadius(10)
    }
}
