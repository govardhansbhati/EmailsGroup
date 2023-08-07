//
//  AddEmailView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 02/08/23.
//

import SwiftUI

struct AddEmailButton: View {
    
    @Binding var isTapped: Bool
    @ObservedObject private var addEmailVM = AddEmailViewModel()
    @FocusState private var focus: Bool
    var callBack: ()->()
    var body: some View {
        HStack {
            if isTapped {
                TextField("Email", text: $addEmailVM.email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    
                    .focused($focus)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white, lineWidth: 1)
                    )
            }
                
                Button {
                    withAnimation {
                        if isTapped && addEmailVM.isEmailValid(){
                            let id = EmailStore.shared.insert(mail: addEmailVM.email)
                            if id != nil {
                                callBack()
                            }
                        }
                        
                        isTapped.toggle()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            focus = isTapped
                        }
                        
                    }
                    
                } label: {
                    HStack{
                        if !isTapped {
                            Text("Add New Email")
                                .fontWeight(.bold)
                                .foregroundColor(Color.main)
                        }
                        
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color.main)
                            .font(.system(size: 25))
                            .rotationEffect(Angle.degrees(isTapped ? -45 : 0))
                            .rotationEffect(Angle.degrees((addEmailVM.emailPrompt == "") ? -45 : 0))
                    
                    }
                }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .shadowModifier()
        .animation(.easeInOut(duration: 0.3), value: isTapped)
    }
}
