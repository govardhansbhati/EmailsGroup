//
//  EmailViewModel.swift
//  EmailsGroup
//
//  Created by govardhan singh on 03/08/23.
//

import Combine
import Contacts
class EmailViewModel: ObservableObject {
    @Published var error: Error? = nil
    @Published var contactEmails: [EmailModel] = []
    @Published var newAddedEmails: [EmailModel] = []
    @Published var latestEmails: [EmailModel] = []
    
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchContactEmails()
        fetchNewAddedEmails()
    }
    
    func fetchContactEmails() {
        print("Fetching contacts")
        
        do {
            let store = CNContactStore()
            let keysToFetch = [CNContactEmailAddressesKey as CNKeyDescriptor]
            print("Fetching contacts: now")
            let containerId = store.defaultContainerIdentifier()
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            print("Fetching contacts: succesfull with count = %d", contacts.count)
            contactEmails = contacts.flatMap({ $0.emailAddresses.compactMap { EmailModel(mail: $0.value as String) } })
        } catch {
            print("Fetching contacts: failed with %@", error.localizedDescription)
            self.error = error
        }
    }
    
    func fetchNewAddedEmails() {
        newAddedEmails = EmailStore.shared.getAllEmails()
    }
    
    func fetchAllEmail(){
        latestEmails = [contactEmails, newAddedEmails].flatMap({$0})
    }
    
    func onButtonSelect(email: EmailModel) {
        var selectedEmail = email
        selectedEmail.isSelected.toggle()
        let count = latestEmails.filter({$0.isSelected == false}).count
        latestEmails = latestEmails.filter { $0.id != email.id }
        let index = selectedEmail.isSelected ? 0 : latestEmails.firstIndex { $0.isSelected == false }
        count  == 0 ? latestEmails.append(selectedEmail) : latestEmails.insert(selectedEmail, at: index ?? 0)
    }
    
}

extension CNContact: Identifiable {
    var name: String {
        return [givenName, middleName, familyName].filter{ $0.count > 0}.joined(separator: " ")
    }
}
