//
//  ProcessView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/08/24.
//

import Foundation
import SwiftUI

struct DetailedLawSuitView: View {
	
    @EnvironmentObject var folderViewModel: FolderViewModel
    @State var editLawSuit = false
    
    @Binding var lawsuit: ProcessMock
	@State var lawsuitCategory: TagType? = nil
	
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Personaliza o formato da data
        return formatter
    }

    
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
	
	var body: some View {
		VStack {
			
			HStack(alignment: .top, spacing: 22) {
				mainBlock
					.frame(maxHeight: .infinity)
				
				VStack(spacing: 10) {

					movimentationBlock
						.frame(maxHeight: .infinity)
					
					audienceBlock
						.frame(maxHeight: .infinity)
					
				}
				.frame(maxHeight: .infinity)
				.fixedSize(horizontal: false, vertical: true)
//				.frame(maxWidth: .infinity)
				
			}
			.fixedSize(horizontal: false, vertical: true)
			.frame(minHeight: 220, maxHeight: 280)
			.frame(minWidth: 620)
			
						
			VStack {
				HStack {
					Text("Arquivos do Processo")
						.font(.title3)
						.bold()
					Spacer()
					
				}
				
				// MARK: - View/Grid de Pastas
                DocumentGridView()
			}
			Spacer()
		}
        .sheet(isPresented: $editLawSuit, content: {
            EditLawSuitView(lawsuit: $lawsuit)
        })
		.padding()
		.onAppear {
            //Selecionar uma pasta aberta do primeiro cliente do CoreData
            folderViewModel.openFolder(folder: clients[0].rootFolder)
            
            lawsuitCategory = .trabalhista
            //TagType(s: lawsuit.tagType ?? .trabalhista)
			dateFormatter.dateFormat = "dd/MM/yyyy"
		}
		
		
	}
}

extension DetailedLawSuitView {
	private var mainBlockHeader: some View {
		HStack {
			TagViewComponent(tagType: lawsuitCategory ?? .trabalhista)
			Spacer()
			Button {
				// editar
                editLawSuit.toggle()
			} label: {
				Image(systemName: "square.and.pencil")
					.resizable()
					.scaledToFit()
					.frame(height: 21)
					.foregroundStyle(.secondary)
			}
			.buttonStyle(PlainButtonStyle())
		}
	}
	
	private var mainBlockNumber: some View {
		HStack {
            Text(lawsuit.number)
				.font(.title3)
				.bold()
			Button {
				// copiar o número para o clipboard
			} label: {
				Image(systemName: "rectangle.portrait.on.rectangle.portrait")
					.resizable()
					.scaledToFit()
					.frame(height: 20)
					.foregroundStyle(.secondary)
			}
			.buttonStyle(PlainButtonStyle())
		}
	}
	
	private var mainBlock: some View {
		BoxView {
			VStack(alignment: .leading) {
				mainBlockHeader
				
				mainBlockNumber
				
				Text(lawsuit.court)
				
				Text("Distribuição da ação")
					.font(.subheadline)
					.foregroundStyle(.secondary)
					.bold()
//                Text(dateFormatter.string(from: lawsuit.actionDate))
                Text("\(lawsuit.actionDate, formatter: dateFormatter)")
//					.padding(.bottom, 60)
				
				Spacer()
				
				HStack {
					VStack(alignment: .leading) {
						Text("Autor")
							.font(.subheadline)
							.foregroundStyle(.secondary)
							.bold()
                        Text(lawsuit.client.name)
							.font(.subheadline)
							.bold()
					}
					Spacer()
					VStack(alignment: .leading) {
						Text("Réu")
							.font(.subheadline)
							.foregroundStyle(.secondary)
							.bold()
                        Text(lawsuit.defendant)
							.font(.subheadline)
							.bold()
					}
					Spacer()
				}
			}
		}
	}
	
	private var movimentationBlock: some View {
		BoxView {
			VStack(alignment: .leading) {
				HStack {
					Text("Última Movimentação")
						.font(.title2)
						.bold()
					Button {
						// ver todas as movimentações
					} label: {
						Text("Ver Todas")
							.font(.subheadline)
					}
					.buttonStyle(LinkButtonStyle())
					
					Spacer()
				}
				.padding(.bottom, 3)
				
				HStack {
					Text("Designação de Audiência")
						.font(.headline)
						.bold()
					Text("30/07/2024 - 14:35")
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
				.padding(.bottom, 1)
				
				Text("Audiência inicial designada para o dia 25/07/2024 às 9:00 horas.")
					.frame(height: 35)
					.lineLimit(nil)
				
			}
		}
	}
	
	private var audienceBlock: some View {
		BoxView {
			VStack(alignment: .leading) {
				HStack {
					Text("Audiência")
						.font(.title3)
						.bold()
					Spacer()
					Button {
						
					} label: {
						Image(systemName: "square.and.pencil")
							.resizable()
							.scaledToFit()
							.frame(height: 20)
							.foregroundStyle(.secondary)
					}
					.buttonStyle(PlainButtonStyle())
				}
				.padding(.bottom, 3)
				
				Text("Precatória")
					.font(.subheadline)
					.bold()
					.padding(.bottom, 4)
				
				HStack {
					Image(systemName: "calendar")
						.resizable().scaledToFit().frame(height: 16).foregroundStyle(.secondary)
					Text("23/08/2024")
				}
				HStack {
					Image(systemName: "clock")
						.resizable().scaledToFit().frame(height: 16).foregroundStyle(.secondary)
					Text("9:00")
				}
			}
		}
	}
}



//#Preview {
//    ProcessView(lawsuit:
//        LawsuitMock(actionDate: Date.now,
//                        category: "civel",
//                        defendant: "Abigail da Silva",
//                        id: "sID",
//                        name: "Nome do processo",
//                        number: "0001234-56.2024.5.00.0000",
//                        parentAutor: ClientMock(name: "Abigail da Silva",
//                                            occupation: "Desenvolvedora de Software",
//                                            rg: "123.456.789-0",
//                                            cpf: "123.456.789-00",
//                                            affiliation: "Afiliação",
//                                            maritalStatus: "Casada",
//                                            nationality: "Brasileira",
//                                            birthDate: Date.now,
//                                            cep: "04141900",
//                                            address: "Rua Da Sorte Lobinho",
//                                            addressNumber: "123",
//                                            neighborhood: "Lobo mau",
//                                            complement: "",
//                                            state: "São Jorge",
//                                            city: "Cidade Nacional do Brasil",
//                                            email: "abigail.silva@outlook.com.ru",
//                                            telephone: "(20)9345678123",
//                                            cellphone: "(20)0987654323",
//                                            age: 45),
//                        parentLawyer: LawyerMock(id: "ID",
//                                             name: "André Miguel da Silva",
//                                             oab: "12O34A56B",
//                                             photo: nil,
//                                             clients: [],
//                                             Lawsuit: [],
//                                             recordName: ""),
//                        rootFolder: FolderMock(),
//                        recordName: "",
//                        vara: "1 Vara do Trabalho de São Paulo"))
//}
