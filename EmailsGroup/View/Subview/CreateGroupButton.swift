//
//  CreateGroupButton.swift
//  EmailsGroup
//
//  Created by govardhan singh on 02/08/23.
//

import SwiftUI

struct CreateGroupButton: View {
    
    @Binding var isTapped: Bool
    @ObservedObject private var groupVM = GroupViewModel()
    @FocusState private var focus: Bool
    var callBack: (String)->()
    
    var body: some View {
        HStack {
            
            if isTapped {
                TextField("Group Name", text: $groupVM.group)
                    .focused(self.$focus)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white, lineWidth: 1)
                    )
            }
            
            Button {
                withAnimation {
                    
                    if isTapped && groupVM.group != "" {
                        callBack(groupVM.group)
                    }
                    
                    isTapped.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        focus = isTapped
                    }
                }
                
            } label: {
                HStack{
                    if !isTapped {
                        Text("Create Group")
                            .fontWeight(.bold)
                            .foregroundColor(Color.main)
                    }
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.main)
                        .font(.system(size: 25))
                        .rotationEffect(Angle.degrees(isTapped ? -45 : 0))
                        .rotationEffect(Angle.degrees((groupVM.group != "") ? -45 : 0))
                    
                }
            }
            
            
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .shadowModifier()
        .animation(.easeInOut(duration: 0.3), value: isTapped)
    }
    
}
