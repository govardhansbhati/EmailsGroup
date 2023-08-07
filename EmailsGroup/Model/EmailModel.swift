//
//  EmailModel.swift
//  EmailsGroup
//
//  Created by govardhan singh on 31/07/23.
//

import SwiftUI
struct EmailModel: Identifiable, Codable {
    var id = UUID()
    var mail: String
    var isSelected: Bool = false
}

extension EmailModel: Equatable {}
