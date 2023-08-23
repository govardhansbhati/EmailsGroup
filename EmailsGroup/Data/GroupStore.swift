//
//  GroupStore.swift
//  EmailsGroup
//
//  Created by govardhan singh on 05/08/23.
//

import Foundation
import SwiftUI
import SQLite

class GroupStore {
    
    static let DIR_GROUP_DB = "GroupDB"
    static let STORE_NAME = "group.sqlite3"

    private let groups = Table("groups")

    private let id = Expression<Int64>("id")
    private let name = Expression<String>("groupName")
    private let emails = Expression<String>("emails")

    static let shared = GroupStore()

    private var db: Connection? = nil
    
    
    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_GROUP_DB)

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
            try database.run(groups.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
                table.column(emails)
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }
    private func encodeEmails(emails: [EmailModel]) -> String? {
        do {
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(emails)
            return String(data: data, encoding: .utf8)
        } catch {
            print(error)
            return nil
        }
    }

    private func decodeEmails(emails: String) -> [EmailModel]? {
        do {
            let jsonDecoder = JSONDecoder()
            let data = Data(emails.utf8)
            return try jsonDecoder.decode([EmailModel].self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    
    func genrateID() -> Int64 {
//        let randomID = UInt64.random(in: 0...UInt64.max) - 1
        var random64 = Int64(arc4random()) + (Int64(arc4random()) << 32)
    
        return random64
    }
    
    
    
    func insert(name: String, mails: [EmailModel]) -> Int64? {
        guard let database = db else { return nil }
        guard let mail = encodeEmails(emails: mails) else { return nil }
        let insert = groups.insert(
            self.name <- name,
            self.emails <- mail)
        
        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }

    func getAllGroups() -> [GroupModel] {
        var g: [GroupModel] = []
        guard let database = db else { return [] }
        
        do {
            for group in try database.prepare(self.groups) {
                
                guard let email = decodeEmails(emails: group[emails]) else {
                     print("error")
                    return []
                }
                g.append(GroupModel(id: group[id], name: group[name], email: email))
            }
        } catch {
            print(error)
        }
        return g
    }

//
//    func findTask(groupID: UUID) -> EmailModel? {
//        var group: GroupModel = GroupModel(id: groupID, name: "", email: [])
//        guard let database = db else { return nil }
//
//        let filter = self.groups.filter(id == groupID)
//        do {
//            for t in try database.prepare(filter) {
//                group.name = t[name]
//                group.email = t[emails]
//            }
//        } catch {
//            print(error)
//        }
//        return mail
//    }

    func update(id: Int64, name: String,mailIDs: [EmailModel]) -> Bool  {
        guard let database = db else { return false }
        guard let mail = encodeEmails(emails: mailIDs) else { return false }
        let mails = groups.filter(self.id == id)
        do {
            
            let update = mails.update([
                self.name <- name,
                self.emails <- mail
            ])
            if try database.run(update) > 0 {
                print("updated")
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
            let filter = groups.filter(self.id == id)
            try database.run(filter.delete())
            return true
        } catch {
            print(error)
            return false
        }
    }
    
}

