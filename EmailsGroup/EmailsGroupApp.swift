//
//  EmailsGroupApp.swift
//  EmailsGroup
//
//  Created by govardhan singh on 29/07/23.
//

import SwiftUI

@main
struct EmailsGroupApp: App {
    var body: some Scene {
        WindowGroup {
//            SplashView()
//            CreateGroupView(store: EmailViewModel())
            HomeView()
                .environmentObject(GroupViewModel())
        }
    }
}
