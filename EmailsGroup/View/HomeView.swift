//
//  ContentView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 29/07/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: GroupViewModel
    @State private var isPresentCreatView: Bool = false
    var body: some View {
        NavigationStack {
            VStack(spacing:0){
                if viewModel.groups.count > 0{
                        List {
                            ForEach(viewModel.groups, id: \.id) { (group) in
                                    Button(action: {
                                        withAnimation {
                                            
                                        }
                                    }) {
                                        GroupCardView(group: group)
                                    }.buttonStyle(.automatic)
                                }
                            .listRowBackground(Color.background)
                            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        }
                
                    }
                
                HStack {
                    Spacer()
                    addButton()
                    Spacer()
                }
                }
            
            .navigationTitle("Email Groups")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isPresentCreatView) {
                CreateGroupView(store: EmailViewModel())
                    .environmentObject(viewModel)
            }
            
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.fetchAllGroup()
        }
    }
    
    private func addButton()-> some View {
        Button {
            
                isPresentCreatView.toggle()
           
        } label: {
            HStack{
                    Text("Create New Group")
                        .fontWeight(.bold)
                        .foregroundColor(Color.main)
                
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color.main)
                    .font(.system(size: 25))
            
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .shadowModifier()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(GroupViewModel())
    }
}
