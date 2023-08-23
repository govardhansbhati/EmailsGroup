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

struct CircularButtonModifier: ViewModifier {
    func body(content:Content) -> some View {
        content
            .foregroundColor(Color.main)
            .padding()
            .frame(width: 30, height: 30)
            .background(
                Circle()
                    .fill(Color.background)
                    .shadow(color: Color.main, radius: 0, x: 3, y: 3)
            )
            .overlay {
                Circle()
                    .stroke(Color.main, lineWidth: 2)
            }
    }
}

struct ButtonImageModifier: ViewModifier {
    func body(content:Content) -> some View {
        content
            .foregroundColor(Color.main)
            .font(.system(size: 25))
    }
}

extension View {
    public func shadowModifier() -> some View {
        modifier(ShadowModifier())
    }
    
    public func circularButtonModifier() -> some View {
        modifier(CircularButtonModifier())
    }
    
    public func buttonImageModifier() -> some View {
        modifier(ButtonImageModifier())
    }
}
