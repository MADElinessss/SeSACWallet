//
//  RealmModel.swift
//  SeSACWallet
//
//  Created by Madeline on 2/15/24.
//

import Foundation
import RealmSwift

// MARK: 🐶 Realm 데이터베이스 실습
// MARK: 데이터베이스 테이블
class AccountBookTable: Object {
    // PK 설정
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var money: Int
    @Persisted var category: String
    @Persisted var memo: String?
    @Persisted var registerationDate: Date // 등록일
    @Persisted var usageDate: Date // 소비 날짜
    @Persisted var isDeposit: Bool // true: 입금 / false: 출금
    // 컬럼을 추가해보자!
    @Persisted var isFavorite: Bool
    
    // class initializer
    // convenience: 편의 생성자
    convenience init(money: Int, category: String, memo: String? = nil, registerationDate: Date, usageDate: Date, isDeposit: Bool) {
        self.init() // 초기화 내가 할거는 내가 할게
        self.money = money
        self.category = category
        self.memo = memo
        self.registerationDate = registerationDate
        self.usageDate = usageDate
        self.isDeposit = isDeposit
        self.isFavorite = false
    }
}
