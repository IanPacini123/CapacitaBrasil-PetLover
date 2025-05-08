//
//  PetHomeView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/05/25.
//

import SwiftUI

enum PetFlowDestination: Hashable {
    case petDocuments
    case petMedicalConditions
    case petProfile
    case petBasicInfo
    case reminders
}

struct PetHomeView: View {
    @State var path = NavigationPath()
    @StateObject var petCreationViewModel = PetCreationViewModel()
    var petViewModel = PetViewModel.shared
    @State var currentPet: Pet?
    @State var currentPetIndex = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                
                // colocar um ontap pra clicar e mudar o pet, ter um index e o pet atual pra trocar pro proximo
                
                PetIdentifier(isEmpty: petViewModel.pets.isEmpty, petName: petViewModel.pets.first?.name ?? "")
                
                
                
                InlineCalendar()
                
                VStack {
                    HStack {
                        Text("Lembretes")
                            .appFontDarkerGrotesque(darkness: .Black, size: 28)
                        Spacer()
                        Image("IconPlus")
                    }
                    .padding(.horizontal)
                    .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                }
            }
            .onAppear {
                currentPet = petViewModel.pets.first
            }
            .navigationDestination(for: PetFlowDestination.self) { destination in
                switch destination {
                case .petDocuments:
                    PetDocumentsView(petCreationViewModel: petCreationViewModel, path: $path, petViewModel: petViewModel)
                case .petMedicalConditions:
                    PetMedicalConditionsView(petCreationViewModel: petCreationViewModel, path: $path)
                case .petProfile:
                    PetProfileView(petCreationViewModel: petCreationViewModel, path: $path)
                case .petBasicInfo:
                    PetBasicInfoView(petCreationViewModel: petCreationViewModel, path: $path
                    )
                case .reminders:
                    ReminderView()
                }
            }
        }
    }
}

#Preview {
    PetHomeView()
}

//struct FluxoAjdicionarPet: View {
//   
//    
//    var body: some View {
//        NavigationStack(path: $path) {
//                VStack {
//                    Button(action: {
//                        path.append(PetFlowDestination.petBasicInfo)
//                    }) {
//                        Text("Adicionar Pet")
//                            .font(.title)
//                            .padding()
//                            .background(Color.AppColors.primary30Beige)
//                    }
//                    
//                    Button(action: {
//                        path.append(PetFlowDestination.reminders)
//                    }) {
//                        Text("Adicionar lembrete")
//                            .font(.title)
//                            .padding()
//                            .background(Color.AppColors.primary30Beige)
//                    }
//                    
//                    if petViewModel.pets.isEmpty {
//                        Text("Nenhum pet cadastrado.")
//                            .padding()
//                    } else {
//                        ForEach(petViewModel.pets, id: \.self) { pet in
//                            HStack {
//                                VStack(alignment: .leading, spacing: 8) {
//                                    Text(pet.name)
//                                    Text("Data de nascimento: \(pet.birthDate.formatted(date: .abbreviated, time: .omitted))")
//                                    Text("Espécie: \(pet.specie.rawValue)")
//                                    Text("Raça: \(pet.breed)")
//                                    Text("Castrado: \(pet.castrationStatus.rawValue)")
//                                    Text(String(format: "Peso: %.2f kg", pet.weight))
//                                    Text("Informações: \(pet.infos)")
//                                    Text("Sexo: \(pet.gender.rawValue)")
//                                    Text("Documentos: \(pet.petDocuments.count) documento(s)")
//                                }
//                                if let photoData = pet.photo,
//                                   let uiImage = UIImage(data: photoData) {
//                                    Image(uiImage: uiImage)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(height: 100)
//                                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                                }
//                            }
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                        }
//                    }
//                }
//                
//        }
//    }
//}
