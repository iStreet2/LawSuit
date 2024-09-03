//
//  ProcessNotDistributedView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI

struct LawsuitNotDistributedView: View {
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    
    //MARK: Variáveis de estado
    @State var selectTag = false
    @State var tagType: TagType = .civel
    @Binding var lawsuitNumber: String
    @Binding var lawsuitCourt: String
    @Binding var lawsuitParentAuthorName: String
    @Binding var lawsuitDefendant: String
    @Binding var lawsuitActionDate: Date
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Área")
                .bold()
            TagViewComponent(tagType: tagType)
                .onTapGesture {
                    selectTag.toggle()
                }
            HStack(spacing: 70) {
                VStack(alignment: .leading) {
                    EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Autor", lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefendant, defendantOrClient: "client", attributedClient: .constant(true), attributedDefendant: .constant(false))
                    Text(lawsuitParentAuthorName)
                }
                LabeledTextField(label: "Réu", placeholder: "Adicionar réu ", textfieldText: $lawsuitDefendant)
            }
        }
        Spacer()
        VStack {
            Spacer()
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
                            coreDataViewModel.lawsuitManager.createLawsuitNonDistribuited(name: "\(lawsuitParentAuthorName) X \(lawsuitDefendant)", number: lawsuitNumber, category: category, lawyer: lawyer, defendant: lawsuitDefendant, author: client, actionDate: lawsuitActionDate)
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

//#Preview {
//    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
//    @State var processMock = ProcessMock(processNumber: "", court: "", defendant: "")
//    return ProcessNotDistributedView(clientMock: clientMock, processMock: processMock)
//}
