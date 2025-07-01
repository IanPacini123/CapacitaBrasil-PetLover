//
//  PetListCardDetail.swift
//  PetLover
//
//  Created by Ian Pacini on 27/05/25.
//

import SwiftUI
import QuickLook

struct PetListCardDetail: View {
    @Environment(\.modelContext) private var context
    
    @State var pet: Pet
    
    var petGender: String {
        switch pet.gender {
        case .female:
            return "Feminino"
        case .male:
            return "Masculino"
        }
    }
    
    var petCastrationStatus: String {
        switch pet.castrationStatus {
        case .yes:
            return "Castrado"
        case .no:
            return "Não Castrado"
        case .unknown:
            return "Sem informação"
        }
    }
    
    @State private var isImporterPresented = false
    
    @State private var tempURL: URL?
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Divider()
                
                HStack {
                    Text("Nasc:")
                        .appFontDarkerGrotesque(darkness: .Black, size: 22)
                    Text(pet.birthDate.formatted(date: .numeric, time: .omitted))
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 22)
                    Spacer()
                    Text("\(pet.petAge) ANOS")
                }
                .padding(.top, 20)
                
                HStack {
                    Text("Raça: ")
                        .appFontDarkerGrotesque(darkness: .Black, size: 22)
                    Text(pet.breed)
                }
                
                HStack {
                    Text("Genero: ")
                        .appFontDarkerGrotesque(darkness: .Black, size: 22)
                    Text(petGender)
                }
                
                Divider()
                
                HStack {
                    Text("Castração: ")
                        .appFontDarkerGrotesque(darkness: .Black, size: 22)
                    Text(petCastrationStatus)
                }
                
                HStack {
                    Text("Peso: ")
                        .appFontDarkerGrotesque(darkness: .Black, size: 22)
                    Text("\(numberFormatter.string(from: pet.weight as NSNumber) ?? "0.0") kg")
                }
                
                
                Text("Informações adicionais: ")
                    .appFontDarkerGrotesque(darkness: .Black, size: 22)
                Text("\(pet.infos)")
                
                Divider()
                
                HStack {
                    Text("Documentos")
                        .appFontDarkerGrotesque(darkness: .Black, size: 22)
                    
                    Spacer()
                    
                    Button {
                        isImporterPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(pet.petDocuments) { document in
                            DocumentPreviewButton(pet: $pet, document: document)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .foregroundStyle(Color.AppColors.secondary60BlueishGray)
            .font(.appFontDarkerGrotesque(darkness: .SemiBold, size: 22))
            .padding(.horizontal, 32)
            .background {
                CustomRoundedRectangle(topRadius: 0, bottomRadius: 20)
                    .foregroundStyle(Color.AppColors.primary20NearWhite)
            }
            .fileImporter(
                isPresented: $isImporterPresented,
                allowedContentTypes: [.pdf, .image, .plainText, .data],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    tempURL = urls.first
                    
                    let document = PetDocument(title: tempURL!.lastPathComponent, fileURL: tempURL!)
                    
                    pet.petDocuments.append(document)
                    
                    let viewModel = PetViewModel.shared
                    viewModel.updatePet(context: context, pet: pet)
                case .failure(let error):
                    print("Erro na importação: \(error.localizedDescription)")
                }
            }
            .padding(.horizontal, 2)
            .padding(.bottom, 2)
            .background {
                CustomRoundedRectangle(topRadius: 0, bottomRadius: 20)
                    .foregroundStyle(Color.AppColors.secondary60BlueishGray)
            }
        }
    }
}

struct DocumentPreviewButton: View {
    @Environment(\.modelContext) private var context
    
    @State private var showPreview = false
    
    @State private var isShowingNewNameAlert: Bool = false
    @State private var isShowingExcludingAlert: Bool = false
    
    @State private var newName: String = ""
    
    @State private var isImporterPresented = false
    @State private var tempURL: URL?
    
    @Binding var pet: Pet
    var document: PetDocument
    
    var body: some View {
        Button {
            showPreview.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.AppColors.documentLightGray)
                .frame(width: 112, height: 100)
                .overlay {
                    VStack {
                        Image(systemName: "paperclip")
                            .font(.system(size: 40))
                            .bold()
                        
                        Text(document.title)
                            .appFontDarkerGrotesque(darkness: .Regular, size: 13)
                            .lineLimit(1)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                }
        }
        
        .sheet(isPresented: $showPreview) {
            NavigationStack {
                DocumentPreview(url: document.fileURL)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                showPreview.toggle()
                            } label: {
                                Text("Voltar")
                            }
                            
                        }
                        ToolbarItem(placement: .principal) {
                            Text(document.title)
                                .appFontDarkerGrotesque(darkness: .Bold, size: 24)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button("Mudar documento") {
                                    isImporterPresented.toggle()
                                }
                                Button("Editar nome do documento") {
                                    isShowingNewNameAlert.toggle()
                                }
                                Button("Excluir documento") {
                                    isShowingExcludingAlert.toggle()
                                }
                                .foregroundStyle(.red)
                            } label: {
                                Text("Editar")
                            }
                            
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .alert("Novo nome para o documento", isPresented: $isShowingNewNameAlert) {
                        TextField("Nome do documento", text: $newName)
                        Button("OK", action: {
                            let index = pet.petDocuments.firstIndex(where: { $0 == document})
                            
                            pet.petDocuments[index!].title = newName
                            
                            savePet()
                        })
                    }
                    .alert("Excluir documento", isPresented: $isShowingExcludingAlert) {
                        Button("Cancelar", role: .cancel) {
                            isShowingExcludingAlert.toggle()
                        }
                        .foregroundStyle(.gray)
                        
                        Button(role: .destructive) {
                            let index = pet.petDocuments.firstIndex(where: { $0 == document})
                            
                            pet.petDocuments.remove(at: index!)
                            
                            savePet()
                        } label: {
                            Text("Excluir")
                        }
                    } message: {
                        Text("Tem certeza que deseja excluir o documento?")
                    }
                    .fileImporter(
                        isPresented: $isImporterPresented,
                        allowedContentTypes: [.pdf, .image, .plainText, .data],
                        allowsMultipleSelection: false
                    ) { result in
                        switch result {
                        case .success(let urls):
                            tempURL = urls.first
                            
                            let document = PetDocument(title: tempURL!.lastPathComponent, fileURL: tempURL!)
                            
                            let index = pet.petDocuments.firstIndex(where: { $0 == self.document})
                            
                            pet.petDocuments.remove(at: index!)
                            pet.petDocuments.insert(document, at: index!)
                            
                            savePet()
                        case .failure(let error):
                            print("Erro na importação: \(error.localizedDescription)")
                        }
                    }
            }
        }
    }
    
    func savePet() {
        let viewModel = PetViewModel.shared
        viewModel.updatePet(context: context, pet: pet)
    }
}

struct DocumentPreview: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ controller: QLPreviewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }
    
    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let url: URL
        
        init(url: URL) {
            self.url = url
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return url as QLPreviewItem
        }
    }
}

#Preview {
    PetListCardDetail(pet: .init(name: "Fotossintese",
                                 birthDate: .now,
                                 specie: .dog,
                                 breed: "Demonio",
                                 castrationStatus: .yes,
                                 weight: 6.90,
                                 infos: "De oliveira",
                                 gender: .male))
}
