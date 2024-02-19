//
//  AccountBookTableRepository.swift
//  SeSACWallet
//
//  Created by Madeline on 2/16/24.
//

import Foundation
import RealmSwift

final class AccountBookTableRepository {
    
    let realm = try! Realm()
    
    // CRUD
    // CREATE
    func createItem(_ item: AccountBookTable) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    // READ
    func fetchItem(_ category: String) -> Results<AccountBookTable> {
        realm.objects(AccountBookTable.self).where {
            $0.category == category
        }.sorted(byKeyPath: "money", ascending: true)
    }
    
    func fetch() -> Results<AccountBookTable> {
        return realm.objects(AccountBookTable.self)
    }
    
    // UPDATE
    func updateItem(id: ObjectId, money: Int, category: String) {
        do {
            try realm.write {
                realm.create(AccountBookTable.self,
                             value: ["id": id, "money": money, "favorite": true],
                             update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func updateMoney(value: Int, key: String) {
        do {
            try realm.write {
                realm.objects(AccountBookTable.self).setValue(value, forKey: key)
            }
        } catch {
            
        }
    }
    
    func updateFavorite(_ record: AccountBookTable) {
        do {
            try realm.write {
                record.isFavorite.toggle()
            }
        } catch {
            print(error)
        }
    }
}
