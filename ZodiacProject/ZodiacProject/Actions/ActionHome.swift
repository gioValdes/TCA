//
//  ActionHome.swift
//  ZodiacProject
//
//  Created by Geovanny Valdes on 3/04/25.
//

import Foundation

// MARK: - Action
enum HomeAction: Equatable {
    // Acción cuando se pulsa el botón izquierdo del TabBar
    case tabBarLeftButtonTapped
    // Acción para controlar explícitamente el estado del sheet (útil para bindings)
    case setSheet(isPresented: Bool)
    // Podrías añadir acciones para navegación si quisieras controlarla desde el reducer
    // case tabBarRightButtonTapped // Por ahora, usamos NavigationLink directamente
}

// MARK: - Environment
struct HomeEnvironment {
    // De momento, no parece haber dependencias externas directas para HomeView
    // Si CurrentSignDateView necesitara datos o APIs, se añadirían aquí.
}
