//
//  CreateGroupView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 29/07/23.
//

import SwiftUI
import Contacts

struct CreateGroupView: View {
    
    @EnvironmentObject var store: EmailViewModel
    @EnvironmentObject var groupVM: GroupViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAddingEmail = false
    @State private var isAddingGroup = false
    @State private var showingAlert = false
    @State private var alertMsg: String = ""
    
    var group : GroupModel?
    
    var backButton: some View {
        Button {
            store.refreshEmail()
            dismiss.callAsFunction()
        } label: {
            Image.back
                .circularButtonModifier()
        }
    }
    
    var updateButton: some View {
        Button {
            guard let group = group else { return }
            let selectedMails = store.latestEmails.filter({ $0.isSelected })
            let updated = groupVM.updateGroup(name: group.name, id: group.id, mails: selectedMails)
            if updated {
                groupVM.fetchAllGroup()
                dismiss.callAsFunction()
            }
        } label: {
            HStack {
                Text("Update \(group?.name ?? "")")
                    .fontWeight(.bold)
                    .foregroundColor(Color.main)
                    .padding(.horizontal)
            }
            
        }
    }
    
    var body: some View {
        VStack(spacing: SizeConstant.zero){
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
                    .listRowInsets(EdgeInsets(top: SizeConstant.padding_5,
                                              leading: SizeConstant.padding_10,
                                              bottom: SizeConstant.padding_5,
                                              trailing: SizeConstant.padding_10))
                }
                
            } else {
                Text("error: \(store.error!.localizedDescription)")
            }
            
            HStack {
                // Create Group Button
                if ((!isAddingEmail || isAddingGroup) && store.latestEmails.filter({$0.isSelected}).count > 0 && group == nil){
                    CreateGroupButton(isTapped: $isAddingGroup) { name in
                        let isExist = groupVM.groups.contains(where: {$0.name == name})
                        
                        if isExist {
                            self.alertMsg = "Group with name \(name) is already exist"
                            showingAlert.toggle()
                        } else {
                            let selectedMails = store.latestEmails.filter({ $0.isSelected })
                            if let _ =  groupVM.createGroup(name: name, mails: selectedMails) {
                                DispatchQueue.main.async {
                                    groupVM.fetchAllGroup()
                                    dismiss.callAsFunction()
                                }
                            }
                        }
                    }
                }
                
                // Add Email Button
                if (isAddingEmail || !isAddingGroup){
                    AddEmailButton(isTapped: $isAddingEmail) {
                        store.fetchNewAddedEmails()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                            store.fetchAllEmail()
                        }
                    }
                }
                
                // Update Email Button
                if (group != nil && !isAddingEmail){
                    updateButton
                        .frame(height: SizeConstant.size_37)
                        .padding(.horizontal, SizeConstant.padding_10)
                        .shadowModifier()
                }
            }
            .padding(.horizontal, SizeConstant.padding_5)
            .padding(.bottom, SizeConstant.padding_5)
        }
        .alert(alertMsg, isPresented: $showingAlert) {
            Button(StringConstant.ok, role: .cancel) { }
        }
        .navigationBarTitle(StringConstant.selectEmail)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .scrollContentBackground(.hidden)
    }
}
