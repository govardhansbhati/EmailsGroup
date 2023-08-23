//
//  EmailCardView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 05/08/23.
//

import SwiftUI

struct EmailCardView: View {
    var email: EmailModel
    var body: some View {
        HStack {
            Text(email.mail)
                .fontWeight(.semibold)
                .foregroundColor(Color.main)
            Spacer()
            if email.isSelected {
                Image.select
                    .foregroundColor(Color.main)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .shadowModifier()
    }
}

