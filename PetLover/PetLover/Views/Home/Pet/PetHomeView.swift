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
    
    @State private var hasLoadedPets = false
    @State private var selectedDate: Date = Date()
    @State private var currentPet: Pet?
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
                
                VStack(spacing: 8) {
                    Text("Love My Pet")
                        .appFontDarkerGrotesque(darkness: .Black, size: 32)
                        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                    
                    HStack {
                        if !(PetViewModel.shared.pets.isEmpty) {
                            Button(action: {
                                if selectedPetIndex > 0 {
                                    selectedPetIndex -= 1
                                    currentPet = PetViewModel.shared.pets[selectedPetIndex]
                                }
                                print(selectedPetIndex)
                            }, label: {
                                Image("IconChevronRight")
                                    .rotationEffect(Angle(degrees: 180))
                                    .foregroundStyle(selectedPetIndex == 0 ? Color.AppColors.nearNeutralGrayGray : Color.AppColors.secondary60BlueishGray)
                            })
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 2) {
                            PetIdentifier(isEmpty: PetViewModel.shared.pets.isEmpty, petName: currentPet?.name ?? "", petImageData: currentPet?.photo, action: {
                                path.append(PetFlowDestination.petBasicInfo)
                            })
                            .id(currentPet)
                            .frame(width: geometry.size.width * 0.8)
                            
                            if !(PetViewModel.shared.pets.isEmpty) {
                                IndicatorBar(numberOfPages: PetViewModel.shared.pets.count, currentPage: $selectedPetIndex)
                            }
                        }

                        
                        Spacer()
                        
                        if !(PetViewModel.shared.pets.isEmpty) {
                            Button(action: {
                                print(selectedPetIndex)
                                if selectedPetIndex < PetViewModel.shared.pets.count - 1 {
                                    selectedPetIndex += 1
                                    currentPet = PetViewModel.shared.pets[selectedPetIndex]
                                }
                                
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

                            VStack(alignment: .leading, spacing: 8) {
                                if remindersForToday.isEmpty {
                                    Text("Sem lembretes para hoje")
                                        .foregroundStyle(.blue)
                                        .padding()
                                } else {
                                    ScrollView(.vertical, showsIndicators: true) {
                                        VStack(spacing: 12) {
                                            ForEach(remindersForToday) { reminder in
                                                ReminderCard(reminder: reminder)
                                            }
                                        }
                                        .padding()
                                    }
                                }
                            }
                            .frame(height: geometry.size.height * 0.3)
                        }
                        
                    }
                }
            }
        }
        .onAppear {
            PetViewModel.shared.fetchPets(context: context)
            
            if !PetViewModel.shared.pets.isEmpty {
                currentPet = PetViewModel.shared.pets[selectedPetIndex]
                print(currentPet?.name)
            }
        }
        .sheet(isPresented: $showAddReminderSheet) {
            AddReminderSheet(isShowing: $showAddReminderSheet)
        }
    }
    
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
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


