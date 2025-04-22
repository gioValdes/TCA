//
//  ShapesView.swift
//  ZodiacProject
//
//  Created by Geovanny Valdes on 24/03/25.
//

import SwiftUI

struct Arc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX - 1, y: rect.minY))
        path.addQuadCurve(to:
                            CGPoint(x: rect.maxX + 1, y: rect.minY),
                          control:
                            CGPoint(x: rect.midX, y: rect.midY))
        
        path.addLine(to: CGPoint(x: rect.maxX + 1, y: rect.maxY + 1))
        path.addLine(to: CGPoint(x: rect.minX - 1, y: rect.maxY + 1))
        path.closeSubpath()
        
        let transform = CGAffineTransform(scaleX: 1, y: -1)
                .translatedBy(x: 0, y: -rect.height + 10)
            return path.applying(transform)
    }
}
