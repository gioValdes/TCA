//
//  StoreHome.swift
//  ZodiacProject
//
//  Created by Geovanny Valdes on 3/04/25.
//

import Foundation

@MainActor // Asegura que todas las operaciones del Store ocurran en el hilo principal
final class Store<State: Equatable, Action, Environment>: ObservableObject {
    @Published private(set) var state: State
    private let reducer: @MainActor (inout State, Action, Environment) -> [EffectTask<Action>]
    private let environment: Environment

    // Para mantener un registro de las tareas de efectos en curso (opcional, para cancelación)
    private var runningEffectTasks = Set<EffectTask<Action>>()

    init(
        initialState: State,
        reducer: @escaping @MainActor (inout State, Action, Environment) -> [EffectTask<Action>],
        environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ action: Action) {
        // Ejecuta el reducer para obtener el nuevo estado y los efectos
        // Se ejecuta en @MainActor porque tanto el Store como el reducer están marcados
        let effects = reducer(&state, action, environment)

        // Ejecuta cada efecto devuelto
        for effect in effects {
            // Evita lanzar el mismo efecto si ya está corriendo (simplificación básica)
            guard !runningEffectTasks.contains(effect) else { continue }
            runningEffectTasks.insert(effect)

            // Lanza una nueva Task de Swift Concurrency para ejecutar la operación asíncrona del efecto
            Task { [weak self] in // Captura débil para evitar ciclos de retención
                // Ejecuta la operación asíncrona del efecto
                guard let resultingAction = await effect.operation() else {
                    // Si no hay acción resultante, elimina la tarea del registro y termina
                    self?.runningEffectTasks.remove(effect)
                    return
                }

                // Una vez que la operación termina y devuelve una acción,
                // envíala de vuelta al Store (en el hilo principal gracias a @MainActor)
                self?.send(resultingAction)

                // Elimina la tarea del registro después de completarla
                self?.runningEffectTasks.remove(effect)
            }
        }
    }
}
