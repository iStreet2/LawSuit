//
//  SubscriptionPlansView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 24/10/24.
//

import SwiftUI

struct SubscriptionPlansView: View {
	
	@EnvironmentObject var dataViewModel: DataViewModel
	@EnvironmentObject var planManager: PlanManager
	
	var body: some View {
		ZStack {
			
//			Color.secondary
//			Image("ArqionBackgroundPattern")
//				.resizable(resizingMode: .tile)
			Image("clientEmptyStateBackground")
				.resizable()
			
			VStack {
				Text("Escolha o seu plano")
					.font(.largeTitle)
					.bold()
				
				Text("Otimize o seu escritório")
					.font(.largeTitle)
					.foregroundStyle(.secondary)
					.padding(.bottom, 30)
				
				HStack(alignment: .top) {
					Spacer()
					
					freePlanView
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.shadow(radius: 10)
					
					Spacer()
					
					SubscriptionPlanView()
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.shadow(radius: 10)
					
					Spacer()
				}
			}
		}
	}
}

#Preview {
	SubscriptionPlansView()
}

extension SubscriptionPlansView {
	
	private var freePlanView: some View {
		VStack(alignment: .leading) {
			Text("Free")
				.font(.title2)
				.foregroundStyle(.wine)
				.bold()
				.padding(.horizontal)
			
			Text("Experimente o Arqion")
				.foregroundStyle(.secondary)
				.padding(.horizontal)
			
			Text("R$0")
				.font(.largeTitle)
				.bold()
				.padding(.horizontal)
				.padding(.top, 1)
			
			VStack(alignment: .leading, spacing: 11) {
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("10 ").bold()
						Text("clientes cadastrados")
					}
				}
				
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Processos ")
						Text("ilimitados").bold()
					}
				}
				
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Processos monitorados ")
						Text("ilimitados").bold()
					}
				}
				
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Armazenamento: ")
						Text("Local").bold()
					}
					Spacer()
				}
			}
			.padding()
			.background(.secondary.opacity(0.1))
			
			HStack {
				Spacer()
				
				if planManager.isFreePlan() {
					Text("Seu plano atual")
						.bold()
						.padding(.top, 7)
				} else {
					Button {
						planManager.updatePlan(to: .free, for: dataViewModel.context)
					} label: {
						Text("Voltar para o plano Free")
					}
					.buttonStyle(BorderedProminentButtonStyle())
					.tint(.black)
					.padding(.top, 3)
				}
				
				Spacer()
			}
		}
		.padding(.vertical)
		.background(.white)
		.frame(width: 307)
		.fixedSize(horizontal: true, vertical: true)
	}
}
