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
    @Published var count: Int = 0
    
    var timer: Timer?
    
    func fetchAllGroup() {
        groups = GroupStore.shared.getAllGroups()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.count += 1
        })
    }
    
    func invalidateTimer() {
        timer?.invalidate()
    }
    
    func createGroup(name: String,mails: [EmailModel]) -> Int64? {
        return  GroupStore.shared.insert(name: name, mails: mails)
    }
    
    func updateGroup(name:String, id:Int64, mails: [EmailModel]) -> Bool {
        return GroupStore.shared.update(id: id, name: name, mailIDs: mails)
        
    }
    
    func deleteTask(at indexSet: IndexSet) {
        let id = indexSet.map { self.groups[$0].id }.first
        if let id = id {
            let delete = GroupStore.shared.delete(id: id)
            if delete {
                fetchAllGroup()
            }
        }
    }
}
