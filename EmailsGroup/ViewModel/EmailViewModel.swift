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
    
    var dispose = Set<AnyCancellable>()
    let contactStore = CNContactStore()
    @Published var invalidPermission: Bool = false
    
    var authorizationStatus: AnyPublisher<CNAuthorizationStatus, Never> {
        Future<CNAuthorizationStatus, Never> { promise in
            self.contactStore.requestAccess(for: .contacts) { (_, _) in
                let status = CNContactStore.authorizationStatus(for: .contacts)
                promise(.success(status))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - fetch emails from contacts & new added email
    func fetchEmails() {
        fetchContactEmails()
        fetchNewAddedEmails()
    }
    
    // MARK: - contact permission
    func requestAccess() {
        self.authorizationStatus
            .receive(on: RunLoop.main)
            .map { $0 == .denied || $0 == .restricted }
            .assign(to: \.invalidPermission, on: self)
            .store(in: &dispose)
    }
    
    // MARK: - fetch emails from contacts
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
            
            contactEmails = contacts.flatMap({ $0.emailAddresses.compactMap { EmailModel(id: genrateID(),mail: $0.value as String) } })
        } catch {
            print("Fetching contacts: failed with %@", error.localizedDescription)
            self.error = error
        }
    }
    
    func fetchNewAddedEmails() {
        newAddedEmails = EmailStore.shared.getAllEmails()
    }
    
    func genrateID() -> Int64 {
        let random64 = Int64(arc4random()) + (Int64(arc4random()) << 32)
        return random64
    }
    
    func fetchAllEmail(){
        latestEmails = [contactEmails, newAddedEmails].flatMap({$0})
    }
    
    func updatedEmails(emails: [EmailModel]){
        
        emails.forEach { mail in
            latestEmails.removeAll(where: {$0.mail == mail.mail})
        }
        latestEmails = [emails, latestEmails].flatMap({$0})
        print(latestEmails)
    }
    
    func onButtonSelect(email: EmailModel) {
        var selectedEmail = email
        selectedEmail.isSelected.toggle()
        let count = latestEmails.filter({$0.isSelected == false}).count
        latestEmails = latestEmails.filter { $0.id != email.id }
        let index = selectedEmail.isSelected ? 0 : latestEmails.firstIndex { $0.isSelected == false }
        count  == 0 ? latestEmails.append(selectedEmail) : latestEmails.insert(selectedEmail, at: index ?? 0)
    }
    
    func refreshEmail() {
        for (i,_) in latestEmails.enumerated() {
            latestEmails[i].isSelected = false
        }
    }
    
}

extension CNContact: Identifiable {
    var name: String {
        return [givenName, middleName, familyName].filter{ $0.count > 0}.joined(separator: " ")
    }
}
