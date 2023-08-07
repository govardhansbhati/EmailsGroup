//
//  SplashView.swift
//  EmailsGroup
//
//  Created by govardhan singh on 01/08/23.
//

import SwiftUI

struct SplashView: View {
    @State private var showMessage = false
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    let date = Date.now
    @State private var isPresentHome: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image(systemName: showMessage ? "envelope.open.fill" : "envelope.fill")
                        .font(.system(size: 120))
                        .foregroundStyle(Color.yellow.gradient)
                    Image(systemName: "doc.plaintext.fill")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .foregroundStyle(.gray.gradient)
                        .offset(y: showMessage ? -60 : 0)
                        .opacity(showMessage ? 1 : 0.0)
                        .animation(.spring(dampingFraction: 0.5), value: showMessage)
                }
                
            }
            .navigationDestination(isPresented: $isPresentHome) {
                CreateGroupView(store: EmailViewModel())
                    .environmentObject(GroupViewModel())
            }
        }
        
        .onReceive(timer) { firedDate in
            showMessage.toggle()
            if Int(firedDate.timeIntervalSince(date)) == 10 {
                timer.upstream.connect().cancel()
                isPresentHome.toggle()
            }
        }
        
    }
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
