//
//  MainView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 10/10/24.
//

import SwiftUI

struct MainView: View {
	
	@EnvironmentObject var eventManager: EventManager
	@EnvironmentObject var dataViewModel: DataViewModel
	@State var authenticationStatus: Bool = false
	@State var shouldTransitionToContentView: Bool = false
	
	@State var transitionProgress: Double = 0
	
//	@State var viewToShow: MainViewCases = .isAuthenticating
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				
				
				
				if authenticationStatus && shouldTransitionToContentView {
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
					ZStack {
						
						Color.white
						
						Image("ArqionBackgroundPattern")
							.resizable(resizingMode: .tile)
							.opacity(0.4)
//						.offset(x: transitionProgress == 1 ? -(NSScreen.main?.visibleFrame.width ?? -500) / 2 : 0)
						
						HStack {
							Spacer()
							UsernameView(shouldGoToContentView: $shouldTransitionToContentView)
								.offset(x: transitionProgress == 1 ? geometry.size.width / 3 : geometry.size.width)
						}
						
						AuthenticationView(authenticationStatus: $authenticationStatus, transitionProgress: $transitionProgress)
//					.onChange(of: authenticationStatus) { newValue in
//						if newValue { // Se for autenticado -> True
//							withAnimation(.easeIn(duration: 3)) {
//								transitionProgress
//							}
//						}
//					}
					}
				}
				
			}
		}
		.onAppear {
			shouldTransitionToContentView = dataViewModel.checkAccountStatus()
		}
	}
}

#Preview {
	MainView()
}

enum MainViewCases {
	case isAuthenticating
	case didAuthenticate
	case didCreateAccount
}
