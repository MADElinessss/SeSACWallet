//
//  AddViewController.swift
//  SeSACWallet
//
//  Created by Madeline on 2/14/24.
//

import RealmSwift
import SnapKit
import UIKit

// 값 전달 4. protocol
protocol PassDataDelegate {
    func memoReceived(text: String)
}

class AddViewController: BaseViewController {
    
    let moneyButton = UIButton()
    let categoryButton = UIButton()
    let memoButton = UIButton()
    
    let repository = AccountBookTableRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 값 전달 3. notification center로 전달 받기
        NotificationCenter.default.addObserver(self, selector: #selector(categoryReceivedNotificationObserved), name: NSNotification.Name("CategoryReceived"), object: nil)
    }
    
    // 값 전달 3. notification center로 전달 action
    @objc func categoryReceivedNotificationObserved(notification: NSNotification) {
        // Any -> String으로 타입캐스팅
        if let value = notification.userInfo?["category"] as? String {
            categoryButton.setTitle(value, for: .normal)
        }
        
    }
    
    override func configureHierarchy() {
        view.addSubview(moneyButton)
        view.addSubview(categoryButton)
        view.addSubview(memoButton)
    }
    
    override func configureConstraints() {
        moneyButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(moneyButton.snp.bottom).offset(24)
            make.centerX.equalTo(view)
            make.width.equalTo(300)
            make.height.equalTo(48)
        }
        
        memoButton.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(24)
            make.centerX.equalTo(view)
            make.width.equalTo(300)
            make.height.equalTo(48)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        // MARK: 🐶 Realm 데이터베이스 실습
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        moneyButton.setTitle("금액", for: .normal)
        moneyButton.setTitleColor(.white, for: .normal)
        moneyButton.backgroundColor = .orange
        moneyButton.addTarget(self, action: #selector(moneyButtonTapped), for: .touchUpInside)
        
        categoryButton.setTitle("Category", for: .normal)
        categoryButton.setTitleColor(.white, for: .normal)
        categoryButton.backgroundColor = .systemOrange
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
        memoButton.setTitle("MEMO", for: .normal)
        memoButton.setTitleColor(.white, for: .normal)
        memoButton.backgroundColor = .systemOrange
        memoButton.addTarget(self, action: #selector(memoButtonTapped), for: .touchUpInside)
    }
    
    // MARK: 🐶 Realm 데이터베이스 실습
    @objc func saveButtonTapped() {
        
        // Realm에 Record 추가하기: CREATE
        // 1. Realm을 찾는다!
//        let realm = try! Realm()
//        
//        print(realm.configuration.fileURL)
//        
//        // 2. Record에 Create될 내용을 구성한다!
//        
        let money = Int.random(in: 100...5000)*10
        
        let data = AccountBookTable(money: money, category: "study", memo: nil, registerationDate: Date(), usageDate: Date(), isDeposit: false)
        
        repository.createItem(data)
        
        
        
        
        // 3. 레코드를 Realm에 추가한다!
//        try! realm.write {
//            realm.add(data)
//            print("REALM CREATED")
//        }
    }

    @objc func moneyButtonTapped() {
        let vc = MoneyViewController()
        
        // 값 전달 1. 프로퍼티로 전달
        vc.money = "7,000"
        
        // 값 전달 2. 클로저로 전달
        vc.getMoney = { newValue in
            self.moneyButton.setTitle(newValue, for: .normal)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func categoryButtonTapped() {
        let vc = CategoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func memoButtonTapped() {
        let vc = MemoViewController()
        
        // 값 전달 3. 노티 근데 이건 안된다의 예시,,,
        NotificationCenter.default.post(name: NSNotification.Name("MemoPost"), object: nil, userInfo: ["Name":"여기에 한 줄 메모를 입력해주세요.🐶"])
        
        // 값 전달 4. 프로토콜
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// 값 전달 4. 프로토콜
// 메모 버튼 클릭 시 실행되는 프로토콜 값 전달
extension AddViewController: PassDataDelegate {
    func memoReceived(text: String) {
        memoButton.setTitle(text, for: .normal)
    }
}
