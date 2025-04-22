//
//  ReducerHome.swift
//  ZodiacProject
//
//  Created by Geovanny Valdes on 3/04/25.
//

import Foundation
import Combine

@MainActor func homeReducer(state: inout HomeState, action: HomeAction, environment: HomeEnvironment) -> [EffectTask<HomeAction>] {
    switch action {
    case .tabBarLeftButtonTapped: state.isSheetPresented.toggle(); return []
    case .setSheet(let isPresented): state.isSheetPresented = isPresented; return []
    }
}

/// Representa una unidad de trabajo (generalmente asíncrona)
/// que se ejecuta como un efecto secundario y puede, opcionalmente,
/// devolver una Acción para ser enviada de nuevo al Store.
struct EffectTask<Action>: Hashable {
    /// Un identificador único para esta tarea de efecto.
    /// Podría usarse para cancelación si implementaras esa lógica,
    /// y es necesario para la conformidad con Hashable (útil si guardas efectos en un Set).
    let id: UUID

    /// La operación (closure) asíncrona que realiza el trabajo del efecto.
    /// Puede devolver una Acción (`Action?`) que se reenviará al Store,
    /// o `nil` si el efecto no necesita generar una acción de vuelta.
    let operation: () async -> Action?

    /// Inicializador privado para controlar la creación a través del factory `run`.
    private init(id: UUID = UUID(), operation: @escaping () async -> Action?) {
        self.id = id
        self.operation = operation
    }

    // --- Conformidad con Hashable ---

    /// Compara dos EffectTasks basándose únicamente en su ID.
    static func == (lhs: EffectTask<Action>, rhs: EffectTask<Action>) -> Bool {
        lhs.id == rhs.id
    }

    /// Proporciona un hash basado en el ID.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // --- Factory Method ---

    /// Método conveniente para crear una instancia de `EffectTask`.
    /// Toma una operación asíncrona y la envuelve en la estructura.
    ///
    /// - Parameter operation: El closure `async` que define el trabajo del efecto.
    /// - Returns: Una nueva instancia de `EffectTask`.
    static func run(_ operation: @escaping () async -> Action?) -> EffectTask {
        EffectTask(operation: operation)
    }

    /// Un helper conceptual para indicar que no hay efecto.
    /// Nota: En la práctica, simplemente devuelves un array vacío `[]` del reducer.
    /// Esto es más una ayuda semántica si la encuentras útil.
    static var none: [EffectTask] { [] } // Devuelve un array vacío
}
