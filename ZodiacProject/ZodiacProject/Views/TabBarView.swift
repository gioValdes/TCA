//
//  TabBarView.swift
//  ZodiacProject
//
//  Created by Geovanny Valdes on 24/03/25.
//

import SwiftUI

struct TabBarView<Destination: View>: View {
    var action: () -> Void
    var navigationDestination: Destination
    
    var body: some View {
        ZStack {
            Arc()
                .fill(.ultraThinMaterial)
                .frame(height: 88)
            
            HStack {
                //MARK: button Sheet
                Button { action() } label: {
                    Image(systemName: "figure.wave")
                        .frame(width: 50, height: 50)
                }
                
                Spacer()
                
                //MARK: button Nav
                NavigationLink(destination: navigationDestination) {
                    Image(systemName: "figure.dance")
                        .frame(width: 50, height: 50)
                }
            }
            .font(.title2)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.bottom, 14)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TabBarView(action: {}, navigationDestination: AllSignsView())
        .preferredColorScheme(.dark)
}
