//
//  AllSignsView.swift
//  ZodiacProject
//
//  Created by Geovanny Valdes on 24/03/25.
//

import SwiftUI

struct AllSignsView: View {
    var body: some View {
        
        VStack(alignment: .leading, content: {
            Text("🦀 (21 de junio - 22 de julio)")
                .bold()
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            
            Text("Emocional, intuitivo y protector. Suelen ser muy familiares y hogareños, pero también pueden ser sensibles y cambiantes. Son leales, empáticos y buscan seguridad en sus relaciones.")
                .lineLimit(7)
                .fixedSize(horizontal: false, vertical: true)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            
            ScrollView{
                
            }
        })
        .padding()
        //.background(Color.bottomSheetBackground.opacity(0.3))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 40, height: 40)))
        .background(.thinMaterial)
        
    }
    
}

#Preview {
    AllSignsView()
        .background(Color.background)
        .preferredColorScheme(.dark)
}
