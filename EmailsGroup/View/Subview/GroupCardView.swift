//
//  GroupCardView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 05/08/23.
//

import SwiftUI

struct GroupCardView: View {
    var group: GroupModel
    
    var body: some View {
        HStack {
            Text(group.name)
                .fontWeight(.semibold)
                .foregroundColor(Color.main)
            Spacer()
            fetchButton(isSend: true)
            Spacer().frame(width: 5)
            fetchButton()
            

        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .shadowModifier()
    }
    
    
    func fetchButton(isSend: Bool = false) -> some View {
            Button {
                let mailID = group.email.map({$0.mail})
                EmailController.shared.sendEmail(subject: "Hello", body: "test", to: mailID)
            } label: {
                Image(systemName: isSend ? "paperplane" : "pencil")
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
}

//enum 
