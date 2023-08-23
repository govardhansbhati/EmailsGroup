//
//  SplashView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 01/08/23.
//

import SwiftUI
import Contacts

struct SplashView: View {
    
    @EnvironmentObject var emailVM: EmailViewModel
    @EnvironmentObject var groupVM: GroupViewModel
    
    @State private var isPresentHome: Bool = false
    @State private var showMessage = false
    
   
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image(showMessage ? .messageOpen : .message)
                        .font(.system(size: SizeConstant.size_120))
                        .foregroundStyle(Color.yellow.gradient)
                    Image.doc
                        .resizable()
                        .frame(width: SizeConstant.size_110, height: SizeConstant.size_110)
                        .foregroundStyle(.gray.gradient)
                        .offset(y: showMessage ? -60 : 0)
                        .opacity(showMessage ? 1 : 0.0)
                        .animation(.spring(dampingFraction: 0.5), value: showMessage)
                }
            }
            .alert(isPresented: self.$emailVM.invalidPermission) {
                  Alert(
                    title: Text("Alert"),
                    message: Text("Please go to Settings and turn on the permissions"),
                    primaryButton: .cancel(Text("Cancel")),
                    secondaryButton: .default(Text("Settings"), action: {
                      if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                      }
                    }))
                }
            .navigationDestination(isPresented: $isPresentHome) {
                HomeView()
                    .environmentObject(groupVM)
                    .environmentObject(emailVM)
                    .navigationBarBackButtonHidden()

            }
        }
        .onReceive(groupVM.$count, perform: { counter in
            if counter == 6 {
                groupVM.invalidateTimer()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isPresentHome.toggle()
                }
            } else {
                withAnimation {
                    showMessage.toggle()
                }
            }
        })
        .onAppear {
            DispatchQueue.main.async {
                self.groupVM.runTimer()
                self.emailVM.fetchEmails()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                emailVM.fetchAllEmail()
                groupVM.fetchAllGroup()
            }
        }
        
    }
    
}
