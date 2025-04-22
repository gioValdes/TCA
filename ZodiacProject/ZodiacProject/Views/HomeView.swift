//
//  HomeView.swift
//  ZodiacProject
//
//  Created by Geovanny Valdes on 24/03/25.
//

import SwiftUI

struct HomeView: View {
    private struct Constants {
        static let topPadding: CGFloat = 30
        static let shadowRadius: CGFloat = 3
        static let shadowX: CGFloat = 1
        static let shadowY: CGFloat = 1
        static let sheetFractionSmall: Double = 0.3
        static let sheetFractionLarge: Double = 0.9
        static let sheetInteractionHeight: CGFloat = 300
    }
    @ObservedObject var store: Store<HomeState, HomeAction, HomeEnvironment>
    //@State private var isSheetPresented = true
    
    private func sheetBinding() -> Binding<Bool> {
        store.binding(
            get: { $0.isSheetPresented }, // Lee el estado del sheet desde el store
            send: { HomeAction.setSheet(isPresented: $0) } // Envía la acción .setSheet cuando el binding cambia
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.background
                    .ignoresSafeArea()

                Image("cangue")
                    .resizable()
                    .offset(x:-50)
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    
                VStack {
                    //MARK: Tab Bar
                    TabBarView(action: {
                        //isSheetPresented.toggle()
                        store.send(.tabBarLeftButtonTapped)
                    }, navigationDestination: AllSignsView())
                    //.ignoresSafeArea(.container, edges: .top)
                    Spacer()
                }
                .frame(maxWidth: 400)
                .ignoresSafeArea(.keyboard)
                
                VStack {
                    Spacer()
                    CurrentSignDateView()
                        .padding(.bottom, 100)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .sheet(isPresented: sheetBinding()) {
                AllSignsView()
                    .presentationDetents([
                        .fraction(Constants.sheetFractionSmall),
                        .fraction(Constants.sheetFractionLarge)
                    ])
                    .presentationBackground(.clear)
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(Constants.sheetInteractionHeight)))
                    .interactiveDismissDisabled(true)
            }
             .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct CurrentSignDateView: View {
    
    private struct ViewConstants {
        static let dayFontSize: CGFloat = 80
        static let shadowRadius: CGFloat = 3
        static let shadowX: CGFloat = 1
        static let shadowY: CGFloat = 1
        static let topPadding: CGFloat = 30
    }

    // Date
    private var attributedDateString: AttributedString {
        let now = Date()
        let dayString = now.formatted(.dateTime.day(.twoDigits))
        let monthString = now.formatted(.dateTime.month(.wide))

        var attributedString = AttributedString(dayString + "\n" + monthString)

        // Style day
        if let dayRange = attributedString.range(of: dayString) {
            attributedString[dayRange].font = .system(size: ViewConstants.dayFontSize, weight: .thin)
            attributedString[dayRange].foregroundColor = .primary
        }

        // Style month
        if let monthRange = attributedString.range(of: monthString) {
            attributedString[monthRange].font = .title2.weight(.semibold)
            attributedString[monthRange].foregroundColor = .secondary
        }

        return attributedString
    }

    var body: some View {
        VStack {
            Text("Hoy en Cancer")
                .font(.largeTitle)

            Text(attributedDateString)
                .multilineTextAlignment(.center)
        }
        .shadow(color: .black.opacity(0.5),
                radius: ViewConstants.shadowRadius,
                x: ViewConstants.shadowX,
                y: ViewConstants.shadowY)
    }
}


// --- Extensión necesaria para el Binding Helper en Store ---
// (Asegúrate de tener esta extensión o una similar junto a tu definición de Store)
extension Store {
    @MainActor // Asegura que el acceso y la modificación ocurran en el hilo principal
    func binding<Value>(
        get: @escaping (State) -> Value,
        send action: @escaping (Value) -> Action
    ) -> Binding<Value> {
        Binding(
            get: { get(self.state) },
            set: { newValue in self.send(action(newValue)) }
        )
    }
}

#Preview { 
    // 1. Crea una instancia del Store para el Preview
    let previewStore = Store(initialState: HomeState(),
                             reducer: homeReducer,
                             environment: HomeEnvironment())

    // 2. Pasa la instancia del Store a la HomeView
    return HomeView(store: previewStore)
        .preferredColorScheme(.dark)
}

