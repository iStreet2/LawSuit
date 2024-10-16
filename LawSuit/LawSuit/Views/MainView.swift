//
//  MainView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 10/10/24.
//

import SwiftUI

struct MainView: View {
	
	@EnvironmentObject var eventManager: EventManager
	@State var authenticationStatus: Bool = false
	
	var body: some View {
		ZStack {
			if authenticationStatus {
				ContentView()
					.background(MaterialWindow().ignoresSafeArea())
					.toolbar(){
						 ToolbarItem(placement: .primaryAction){
							  Button(action: {
									eventManager.spotlightBarIsPresented.toggle()
							  }){
									Image(systemName: "magnifyingglass")
							  }
						 }
					}
			} else {
				AuthenticationView(authenticationStatus: $authenticationStatus)
			}
			
		}
	}
}

#Preview {
	MainView()
}
