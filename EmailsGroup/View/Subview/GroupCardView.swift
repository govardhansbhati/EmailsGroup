//
//  GroupCardView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 05/08/23.
//

import SwiftUI

struct GroupCardView: View {
    var group: GroupModel
    var back: ()->()
    
    var editButton: some View {
        Image.edit
            .circularButtonModifier()
            .onTapGesture {
                back()
            }
    }
    
    // open email app
    var sendButton: some View {
        Image.send
            .circularButtonModifier()
            .onTapGesture {
                let mailID = group.email.map({$0.mail})
                EmailController.shared.sendEmail(subject: "write your subject", body: "write your body message", to: mailID)
            }
    }
    
    var body: some View {
        HStack {
            Text(group.name)
                .fontWeight(.semibold)
                .foregroundColor(Color.main)
            Spacer()
            sendButton
            Spacer()
                .frame(width: SizeConstant.padding_15)
            editButton
        }
        .padding(.horizontal, SizeConstant.padding_20)
        .padding(.vertical, SizeConstant.padding_10)
        .shadowModifier()
    }
}
