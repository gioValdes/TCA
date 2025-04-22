//
//  ContentView.swift
//  ZodiacProject
//
//  Created by Geovanny Valdes on 24/03/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        let homeStore = Store(
                initialState: HomeState(), // Estado inicial
                reducer: homeReducer,      // El reducer que definimos
                environment: HomeEnvironment() // El entorno (vacío en este caso)
            )
        HomeView(store: homeStore)
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
