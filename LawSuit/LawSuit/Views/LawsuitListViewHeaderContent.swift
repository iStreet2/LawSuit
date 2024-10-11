//
//  LawsuitListViewHeaderContent.swift
//  LawSuit
//
//  Created by Giovanna Micher on 04/09/24.
//

import SwiftUI

struct LawsuitListViewHeaderContent: View {
	
	//MARK: Variáveis de estado
	@State var lawsuitClient: Client?
	var lawsuits: FetchedResults<Lawsuit>
	@EnvironmentObject var navigationViewModel: NavigationViewModel
	
	//MARK: CoreData
	@EnvironmentObject var dataViewModel: DataViewModel
	@Environment(\.managedObjectContext) var context
	
	var body: some View {
		
		GeometryReader { geo in
			HStack {
				Text("Nome e Número")
					.frame(width: geo.size.width * 0.27, alignment: .leading)
				
				Text("Tipo")
					.frame(width: geo.size.width * 0.12, alignment: .leading)
				
				Text("Última Movimentação")
					.frame(width: geo.size.width * 0.17, alignment: .leading)
				
				Text("Cliente")
					.frame(width: geo.size.width * 0.17, alignment: .leading)
				
				Text("Advogado Responsável")
				
			}
			.padding(.horizontal, 20)
		}
		.frame(minWidth: 777)
		.frame(height: 13)
		.font(.footnote)
		.bold()
		.foregroundStyle(Color(.gray))
		
		Divider()
		
		ScrollView {
			VStack(spacing: 0) {
				ForEach(Array(lawsuits.enumerated()), id: \.offset) { index, lawsuit in
					NavigationLink {
						DetailedLawSuitView(lawsuit: lawsuit, lawsuitCategory: TagType(s: lawsuit.category)!)
						
					} label: {
						if let lawsuitClient = self.lawsuitClient {
							LawsuitCellComponent(client: lawsuitClient, lawyer: lawsuit.parentLawyer!, lawsuit: lawsuit)
								.background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))
						}
						else {
							Text("Carregando")
								.onAppear {
									//Se o cliente do processo estiver no autor
									if lawsuit.authorID.hasPrefix("client:") {
										if let author = dataViewModel.coreDataManager.clientManager.fetchFromId(id: lawsuit.authorID) {
											self.lawsuitClient = author
										}
										//Se o cliente do processo estiver no reu
									} else {
										if let defendant = dataViewModel.coreDataManager.clientManager.fetchFromId(id: lawsuit.defendantID){
											self.lawsuitClient = defendant
										}
									}
								}
						}
					}
				}
				.buttonStyle(PlainButtonStyle())
			}
		}
	}
}


