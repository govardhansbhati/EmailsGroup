//
//  EmailsGroupApp.swift
//  EmailsGroup
//
//  Created by govardhan singh on 29/07/23.
//

import SwiftUI

@main
struct EmailsGroupApp: App {
    @StateObject var emailVM: EmailViewModel = EmailViewModel()
    @StateObject var groupVM: GroupViewModel = GroupViewModel()

    init() {
        emailVM.requestAccess()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(groupVM)
                .environmentObject(emailVM)
        }
    }
}
