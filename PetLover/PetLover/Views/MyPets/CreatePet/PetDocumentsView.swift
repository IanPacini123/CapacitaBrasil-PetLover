//
//  PetDocumentsView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/04/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct PetDocumentsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @ObservedObject var petCreationViewModel = PetCreationViewModel()
    @ObservedObject var petViewModel = PetViewModel()
    @Binding var path: NavigationPath
    
    
    @State private var isImporterPresented = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Adicione documento do seu pet")
                .font(.title2)
            
            Button("Selecionar Documento") {
                isImporterPresented = true
            }
            .buttonStyle(.borderedProminent)
            
            List(petCreationViewModel.petDocuments, id: \.id) { document in
                Text(document.title)
            }
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.pdf, .image, .plainText, .data],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                for url in urls {
                    let title = url.lastPathComponent
                    let newDoc = PetDocument(title: title, fileURL: url)
                    petCreationViewModel.petDocuments.append(newDoc)
                }
            case .failure(let error):
                print("Erro na importação: \(error.localizedDescription)")
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Adicionar")
                    .appFontDarkerGrotesque(darkness: .Black, size: 32)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    petViewModel.createPet(context: context,
                                           name: petCreationViewModel.name,
                                           birthDate: petCreationViewModel.birthDate,
                                           specie: petCreationViewModel.specie,
                                           breed: petCreationViewModel.breed,
                                           photo: petCreationViewModel.photo,
                                           castrationStatus:
                                            petCreationViewModel.castrationStatus,
                                           weight: petCreationViewModel.weight,
                                           infos: petCreationViewModel.infos,
                                           petDocuments: petCreationViewModel.petDocuments,
                                           gender: petCreationViewModel.gender)
                    petCreationViewModel.clear()
                    path.append(PetFlowDestination.home)
                }) {
                    Text("Finalizar")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 17)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    PetDocumentsView(path: .constant(NavigationPath()))
}
