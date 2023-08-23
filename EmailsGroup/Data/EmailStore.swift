//
//  ContactStore.swift
//  EmailsGroup
//
//  Created by govardhan singh on 29/07/23.
//

import SwiftUI
import SQLite

class EmailStore {
    
    static let DIR_EMAIL_DB = "EmailDB"
    static let STORE_NAME = "email.sqlite3"

    private let emails = Table("emails")

    private let id = Expression<Int64>("id")
    private let email = Expression<String>("email")
    private let isSelected = Expression<Bool>("isSelected")

    static let shared = EmailStore()

    private var db: Connection? = nil
    
    
    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_EMAIL_DB)

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                createTable()
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            db = nil
        }
    }

    
    private func createTable() {
        guard let database = db else {
            return
        }
        do {
            try database.run(emails.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(email)
                table.column(isSelected)
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }
    
    
    func insert(mail: String) -> Int64? {
        guard let database = db else { return nil }

        let insert = emails.insert(self.email <- mail,
                                  self.isSelected <- false)

        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }

    func getAllEmails() -> [EmailModel] {
        var mails: [EmailModel] = []
        guard let database = db else { return [] }
        
        do {
            for mail in try database.prepare(self.emails) {
                mails.append(EmailModel(id: mail[id], mail: mail[email], isSelected: mail[isSelected]))
            }
        } catch {
            print(error)
        }
        return mails
    }


    func findTask(emailID: Int64) -> EmailModel? {
        var mail: EmailModel = EmailModel(id: emailID, mail: "", isSelected: false)
        guard let database = db else { return nil }

        let filter = self.emails.filter(id == emailID)
        do {
            for t in try database.prepare(filter) {
                mail.mail = t[email]
                mail.isSelected = t[isSelected]
            }
        } catch {
            print(error)
        }
        return mail
    }

    func update(id: Int64, mail: String, status: Bool = false) -> Bool {
        guard let database = db else { return false }

        let mails = emails.filter(self.id == id)
        do {
            let update = mails.update([
                email <- mail,
                self.isSelected <- status
            ])
            if try database.run(update) > 0 {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }

    func delete(id: Int64) -> Bool {
        guard let database = db else {
            return false
        }
        do {
            let filter = emails.filter(self.id == id)
            try database.run(filter.delete())
            return true
        } catch {
            print(error)
            return false
        }
    }
    
}
