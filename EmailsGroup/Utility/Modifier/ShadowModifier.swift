//
//  ShadowModifier.swift
//  EmailsGroup
//
//  Created by govardhan singh on 02/08/23.
//

import SwiftUI

struct ShadowModifier: ViewModifier {
    func body(content:Content) -> some View {
        content
            .background(
                Color.background
                    .cornerRadius(5)
                    .shadow(color: Color.main, radius: 0, x: 4, y: 4)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.main, lineWidth: 2)
            }
    }
}

extension View {
    public func shadowModifier() -> some View {
        modifier(ShadowModifier())
    }
}
