//
//  GroupModel.swift
//  EmailsGroup
//
//  Created by govardhan singh on 05/08/23.
//

import Foundation
struct GroupModel: Identifiable {
    var id = UUID()
    var name: String
    var email: [EmailModel]
}

extension GroupModel: Equatable {}
