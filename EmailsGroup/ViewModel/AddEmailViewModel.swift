//
//  EmaiViewModel.swift
//  EmailsGroup
//
//  Created by govardhan singh on 30/07/23.
//

import SwiftUI

class AddEmailViewModel: ObservableObject {
    @Published var email = ""
    
    // MARK: - Validation prompt string
     var emailPrompt: String {
        isEmailValid() ? "" : "Enter a valid email."
    }
    
    // MARK: - Validation
    
    func isEmailValid() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
}
