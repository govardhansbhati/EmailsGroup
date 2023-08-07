//
//  GroupViewModel.swift
//  EmailsGroup
//
//  Created by govardhan singh on 05/08/23.
//

import Combine
import Contacts

class GroupViewModel: ObservableObject {
    @Published var groups: [GroupModel] = []
    @Published var group = ""
    
    init() {
        CNContactStore.authorizationStatus(for: .contacts)
    }
    
    func fetchAllGroup() {
        groups = GroupStore.shared.getAllGroups()
    }
    
    func createGroup(name: String,mails: [EmailModel]) -> Int64? {
      return  GroupStore.shared.insert(name: name, mails: mails)
    }
}
