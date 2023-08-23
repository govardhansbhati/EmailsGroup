//
//  ContentView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 29/07/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: GroupViewModel
    @EnvironmentObject var emailVM: EmailViewModel
    @State private var isPresentCreatView: Bool = false
    @State private var selectedGroup: GroupModel? = nil

    var body: some View {
        NavigationView {
            VStack(spacing:SizeConstant.zero){
                if viewModel.groups.count > 0{
                    List {
                        ForEach(viewModel.groups, id: \.id) { (group) in
                            GroupCardView(group: group) {
                                emailVM.updatedEmails(emails: group.email)
                                selectedGroup = group
                                isPresentCreatView.toggle()
                            }
                        }
                        .onDelete(perform: viewModel.deleteTask(at:))
                        .listRowBackground(Color.background)
                        .listRowInsets(EdgeInsets(top: SizeConstant.padding_5, leading: SizeConstant.padding_10, bottom: SizeConstant.padding_5, trailing: SizeConstant.padding_10))
                    }
                }
                
                HStack {
                    Spacer()
                    addButton()
                    Spacer()
                }
                .padding(.bottom, SizeConstant.padding_5)
            }
            
            .navigationDestination(isPresented: $isPresentCreatView) {
                CreateGroupView(group:selectedGroup)
                    .environmentObject(emailVM)
                    .environmentObject(viewModel)
            }
            .navigationTitle(StringConstant.emailGroups)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
        .ignoresSafeArea()
        .scrollContentBackground(.hidden)
    }
    
    private func addButton()-> some View {
        Button {
            selectedGroup = nil
            isPresentCreatView.toggle()
        } label: {
            HStack{
                Text(StringConstant.createNewGroup)
                    .fontWeight(.bold)
                    .foregroundColor(Color.main)
                
                Image.add
                    .buttonImageModifier()
            }
        }
        .padding(.horizontal, SizeConstant.padding_20)
        .padding(.vertical, SizeConstant.padding_10)
        .shadowModifier()
    }
}

