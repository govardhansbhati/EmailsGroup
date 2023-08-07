//
//  CreateGroupView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 29/07/23.
//

import SwiftUI
import Contacts

struct CreateGroupView: View {
    @StateObject var store: EmailViewModel
    @State private var isAddingEmail = false
    @State private var isAddingGroup = false
    @EnvironmentObject var groupVM: GroupViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
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
    
    var body: some View {
        NavigationStack {
            VStack(spacing:0){
                    if store.error == nil {
                        List {
                            ForEach(store.latestEmails, id: \.id) { (email) in
                                    Button(action: {
                                        withAnimation {
                                            store.onButtonSelect(email: email)
                                        }
                                    }) {
                                        EmailCardView(email: email)
                                    }.buttonStyle(.automatic)
                                }
                            .listRowBackground(Color.background)
                            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        }
                
                    } else {
                        Text("error: \(store.error!.localizedDescription)")
                    }
                
                HStack {
                    if ((!isAddingEmail || isAddingGroup) && store.latestEmails.filter({$0.isSelected}).count > 0){
                        CreateGroupButton(isTapped: $isAddingGroup) { name in
                            let selectedMails = store.latestEmails.filter({ $0.isSelected })
                            if let _ =  groupVM.createGroup(name: name, mails: selectedMails) {
                                DispatchQueue.main.async {
                                    groupVM.fetchAllGroup()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                    
                    
                    if (isAddingEmail || !isAddingGroup){
                        AddEmailButton(isTapped: $isAddingEmail) {
                            store.fetchNewAddedEmails()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                                store.fetchAllEmail()
                            }
                        }
                    }
                    
                }
                .padding(.horizontal, 5)
                }
            .navigationBarTitle("Select Emails")
        
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .scrollContentBackground(.hidden)
        .onAppear {
            store.fetchAllEmail()
        }
        
    }
    
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView(store: EmailViewModel())
            .environmentObject(GroupViewModel())
    }
}

