//
//  EmailModel.swift
//  EmailsGroup
//
//  Created by govardhan singh on 31/07/23.
//

import SwiftUI
struct EmailModel:  Codable {
    var id : Int64
    var mail: String
    var isSelected: Bool = false
}

extension EmailModel: Equatable {}
