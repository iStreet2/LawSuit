//
//  ProcessDistributedView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI

struct LawsuitDistributedView: View {
    
    //MARK: Variáveis de Ambiente
    @Environment(\.dismiss) var dismiss
    
    @State var textInput = ""
    @State var tagType: TagType = .trabalhista
    @State var selectTag = false
    
    //MARK: Variáveis de estado
    @Binding var lawsuitNumber: String
    @Binding var lawsuitCourt: String
    @Binding var lawsuitParentAuthorName: String
    @Binding var lawsuitDefendant: String
    @Binding var lawsuitActionDate: Date
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context

    var body: some View {
        VStack{
            LabeledTextField(label: "Nº do processo", placeholder: "Nº do processo", textfieldText: $lawsuitNumber)
        }
        VStack{
            LabeledTextField(label: "Vara", placeholder: "Vara", textfieldText: $lawsuitCourt)
        }
        HStack(alignment: .top){
            VStack(alignment: .leading){
                EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Autor", lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefendant, defendantOrClient: "client")
                TextField("", text: $lawsuitParentAuthorName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
                Text("Área")
                    .bold()
                TagViewComponent(tagType: tagType)
                    .onTapGesture {
                        selectTag.toggle()
                    }
            }
            Spacer()
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Réu", lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefendant, defendantOrClient: "defendant")
                    TextField("", text: $lawsuitDefendant)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }
                Text("Data de distribuição ")
                    .bold()
                DatePicker(selection: $lawsuitActionDate, in: ...Date.now, displayedComponents: .date) { }
                    .datePickerStyle(.field)
            }
        }
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Cancelar")
            }
            Button {
                let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", lawsuitParentAuthorName)
                do {
                    let fetchedClients = try context.fetch(fetchRequest)
                    if let client = fetchedClients.first {
                        let category = TagTypeString.string(from: tagType)
                        //MARK: Advogado temporário
                        let lawyer = Lawyer(context: context)
                        lawyer.name = "Você"
                        coreDataViewModel.lawsuitManager.createLawsuit(name: "\(lawsuitParentAuthorName) X \(lawsuitDefendant)", number: lawsuitNumber, court: lawsuitCourt, category: category, lawyer: lawyer, defendant: lawsuitDefendant, author: client, actionDate: lawsuitActionDate)
                        dismiss()
                    } else {
                        print("Cliente não encontrado")
                    }
                } catch {
                    print("Erro ao buscar cliente: \(error.localizedDescription)")
                }
            } label: {
                Text("Criar")
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $selectTag, content: {
            VStack {
                Spacer()
                TagViewPickerComponentV1(currentTag: $tagType)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        selectTag.toggle()
                    }, label: {
                        Text("Salvar")
                    })
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
            .frame(minWidth: 200, minHeight: 250)
        })
    }
}

