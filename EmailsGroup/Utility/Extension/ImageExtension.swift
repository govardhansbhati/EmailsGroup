//
//  ImageExtension.swift
//  EmailsGroup
//
//  Created by govardhan singh on 23/08/23.
//

import SwiftUI

extension Image {
    enum SFSymbol: String {
        case add = "plus.circle.fill"
        case edit = "pencil"
        case send = "paperplane"
        case back = "chevron.backward"
        case select = "checkmark.circle.fill"
        case messageOpen = "envelope.open.fill"
        case message = "envelope.fill"
        case doc = "doc.plaintext.fill"
    }
    
    init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
    
    static var add: Image {
        Image(.add)
    }
    
    static var edit: Image {
        Image(.edit)
    }
    
    static var send: Image {
        Image(.send)
    }
    
    static var back: Image {
        Image(.back)
    }
    
    static var select: Image {
        Image(.select)
    }
    
    static var messageOpen: Image {
        Image(.messageOpen)
    }
    
    static var doc: Image {
        Image(.doc)
    }
}
