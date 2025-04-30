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
    @ObservedObject var petCreationViewModel: PetCreationViewModel
    var petViewModel: PetViewModel
    @Binding var path: NavigationPath

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State private var buttonPressed: Bool = false
    @State private var isImporterPresented = false

    @State private var tempTitle: String = ""
    @State private var tempURL: URL?

    var showBottomButton: Bool {
        !(petCreationViewModel.petDocuments.count >= 2 ||
          (petCreationViewModel.petDocuments.count >= 1 && tempURL != nil))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 16) {
                    PetFormHeader(title: "Documentos", text: """
Falta pouco! Adicione aqui informações a respeito do peso, alergias, e tudo o que achar relevante.

Clique no card para selecionar o arquivo
""", totalPages: 4, currentPage: 4)
                    
                    //                    VStack(alignment: .leading, spacing: 8) {
                    //                        Text("Título")
                    //                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                    //                            .padding(.leading)
                    //                        SinglelineTextField(text: $tempTitle, buttonPressed: $buttonPressed, label: "Qual o título desse documento?")
                    //                    }
                    
                    if petCreationViewModel.petDocuments.isEmpty {
                        SelectFileButton(tempURL: tempURL) {
                            isImporterPresented = true
                        }
                    } else {
                        VStack {
                            TempDocumentPreview(tempURL: tempURL)
                            ForEach(petCreationViewModel.petDocuments, id: \.id) { document in
                                DocumentCardView(title: document.title, fileName: document.fileURL.lastPathComponent)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if petCreationViewModel.petDocuments.isEmpty {
                        SaveButton(tempTitle: tempTitle, tempURL: tempURL) {
                            let newDoc = PetDocument(title: tempTitle, fileURL: tempURL!)
                            petCreationViewModel.petDocuments.append(newDoc)
                            tempTitle = ""
                            tempURL = nil
                        }
                    } else {
                        SaveOrSelectButton(
                            tempTitle: tempTitle,
                            tempURL: tempURL,
                            canShow: showBottomButton,
                            saveAction: {
                                let newDoc = PetDocument(title: tempTitle, fileURL: tempURL!)
                                petCreationViewModel.petDocuments.append(newDoc)
                                tempTitle = ""
                                tempURL = nil
                            },
                            selectAction: {
                                isImporterPresented = true
                            }
                        )
                    }
                    
                    Spacer()
                }
                .padding(.top, 40)
            }
            
            SaveOrSelectButton(
                tempTitle: tempTitle,
                tempURL: tempURL,
                canShow: !showBottomButton,
                saveAction: {
                    let newDoc = PetDocument(title: tempTitle, fileURL: tempURL!)
                    petCreationViewModel.petDocuments.append(newDoc)
                    tempTitle = ""
                    tempURL = nil
                },
                selectAction: {
                    isImporterPresented = true
                }
            )
            .padding(.bottom)
        }
        .background(
            Color.AppColors.nearNeutralLightLightGray
                .ignoresSafeArea()
        )
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
                                           birthDate: petCreationViewModel.birthDate ?? Date(),
                                           specie: petCreationViewModel.specie ?? .dog,
                                           breed: petCreationViewModel.breed,
                                           photo: petCreationViewModel.photo,
                                           castrationStatus: petCreationViewModel.castrationStatus ?? .unknown,
                                           weight: petCreationViewModel.weight,
                                           infos: petCreationViewModel.infos,
                                           petDocuments: petCreationViewModel.petDocuments,
                                           gender: petCreationViewModel.gender ?? .male)
                    petCreationViewModel.clear()
                    path = NavigationPath()
                }) {
                    Text("Finalizar")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 17)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

private struct SelectFileButton: View {
    var tempURL: URL?
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Text((tempURL == nil ? "Selecionar arquivo" : tempURL?.lastPathComponent)!)
                    .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                    .foregroundStyle(.black)
                    .underline(true, color: .black)
                Image("IconClip")
                    .resizable()
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
        }
        .padding(.horizontal)
    }
}

private struct TempDocumentPreview: View {
    var tempURL: URL?

    var body: some View {
        if let tempURL = tempURL {
            VStack {
                Text(tempURL.lastPathComponent)
                    .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                    .foregroundStyle(.black)
                    .underline(true, color: .black)
                Image("IconClip")
                    .resizable()
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
        }
    }
}

private struct DocumentCardView: View {
    var title: String
    var fileName: String

    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                .foregroundStyle(.black)
                .underline(true, color: .black)
            VStack {
                Image("IconClip")
                    .resizable()
                    .frame(width: 58, height: 58)
                    .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                    .padding(.top, 20)
                Text(fileName)
                    .appFontDarkerGrotesque(darkness: .Regular, size: 13)
                    .foregroundStyle(.black)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.AppColors.documentLightGray)
            )
            .padding(.horizontal, 45)
        }
        .frame(maxWidth: .infinity, minHeight: 166)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundStyle(.black)
        )
    }
}

private struct SaveOrSelectButton: View {
    var tempTitle: String
    var tempURL: URL?
    var canShow: Bool
    var saveAction: () -> Void
    var selectAction: () -> Void

    var body: some View {
        if canShow {
            if tempURL == nil {
                LargeButton(label: "Selecionar novo arquivo", type: .primary, action: selectAction)
                    .padding(.horizontal)
                    .frame(height: 44)
            } else {
                LargeButton(label: "Salvar", type: .primary, action: saveAction)
                    .disabled(tempTitle.isEmpty || tempURL == nil)
                    .padding(.horizontal)
                    .frame(height: 44)
            }
        }
    }
}

private struct SaveButton: View {
    var tempTitle: String
    var tempURL: URL?
    var action: () -> Void

    var body: some View {
        LargeButton(label: "Salvar", type: .primary, action: action)
            .disabled(tempTitle.isEmpty || tempURL == nil)
            .padding(.horizontal)
            .frame(height: 44)
    }
}
