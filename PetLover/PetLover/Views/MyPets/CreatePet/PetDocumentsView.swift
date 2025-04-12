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
    @ObservedObject var petCreationViewModel = PetCreationViewModel()
    @ObservedObject var petViewModel = PetViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Binding var path: NavigationPath
    
    @State private var buttonPressed: Bool = false
    @State private var isImporterPresented = false
    
    @State private var tempTitle: String = ""
    @State private var tempURL: URL?

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Documentos")
                    .appFontDarkerGrotesque(darkness: .SemiBold, size: 24)
                Text("Falta pouco! Adicione aqui informações a respeito do peso, alergias, e tudo o que achar relevante.")
                    .appFontDarkerGrotesque(darkness: .Regular, size: 17)
                    .multilineTextAlignment(.center)
                Text("Insira o título e selecione o documento")
                    .appFontDarkerGrotesque(darkness: .Regular, size: 17)
                    .padding(.top)
                PageProgressBar(totalPages: 5, currentPage: 1)
                    .padding(.horizontal, 70)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Título do documento")
                    .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                    .padding(.leading)
                SinglelineTextField(text: $tempTitle, buttonPressed: $buttonPressed, label: "Ex: Alergias, Carteira de vacinação...")
            }

            Button(action: {
                isImporterPresented = true
            }, label: {
                VStack {
                    Text(tempURL == nil ? "Selecionar arquivo" : "Arquivo selecionado ✅")
                        .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                        .foregroundStyle(.black)
                        .underline(true, color: .black)
                    Image("IconClip")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 58, height: 58)
                        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                        .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, minHeight: 166)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.black)
                )
            })
            .padding(.horizontal)

            if tempURL != nil && !tempTitle.isEmpty {
                Button("Adicionar documento") {
                    let newDoc = PetDocument(title: tempTitle, fileURL: tempURL!)
                    petCreationViewModel.petDocuments.append(newDoc)
                    tempTitle = ""
                    tempURL = nil
                }
//                .appFontDarkerGrotesque(darkness: .Regular, size: 17)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            }

            if !petCreationViewModel.petDocuments.isEmpty {
                Text("Documentos adicionados")
                    .appFontDarkerGrotesque(darkness: .SemiBold, size: 18)
                    .padding(.top)

                List {
                    ForEach(petCreationViewModel.petDocuments, id: \.id) { document in
                        VStack(alignment: .leading) {
                            Text(document.title)
                                .font(.headline)
                            Text(document.fileURL.lastPathComponent)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 200)
            }
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.pdf, .image, .plainText, .data],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                tempURL = urls.first
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
                                           castrationStatus: petCreationViewModel.castrationStatus,
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
