//
//  ColorExtension.swift
//  EmailsGroup
//
//  Created by govardhan singh on 02/08/23.
//

import SwiftUI
public extension Color {
    
    private static let defaultMainColor = ColorKit.colorType(red: 0.00, green: 0.00, blue: 0.00)
    private static let defaultDarkColor = ColorKit.colorType(red: 1.00, green: 1.00, blue: 1.00)
    
     static var main: Color {
        ColorKit.color(light: defaultMainColor, dark: defaultDarkColor)
    }
     static var background: Color {
        ColorKit.color(light: defaultDarkColor, dark: defaultMainColor)
    }
}

public struct ColorKit {
    public enum ColorSchemeType {
        case auto, light , dark
    }
    
    public static var colorSchemeType: ColorSchemeType = .auto
    
    public typealias ColorType = UIColor
    public static func colorType(red: CGFloat, green: CGFloat, blue: CGFloat) -> ColorType {
        .init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    public static func color(light: ColorType, dark: ColorType) -> Color {
        switch ColorKit.colorSchemeType {
        case .light:
            return Color(light)
        case .dark:
            return Color(dark)
        case .auto:
            return Color(.init{ $0.userInterfaceStyle == .light ? light : dark })
        }
    }
}
