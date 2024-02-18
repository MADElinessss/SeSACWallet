//
//  MainViewController.swift
//  SeSACWallet
//
//  Created by Madeline on 2/14/24.
//

import RealmSwift
import SnapKit
import UIKit

class MainViewController: BaseViewController {

    let tableView = UITableView()
    let dataList = ["만두", "터피", "커피"]
    
    var list: Results<AccountBookTable>!
    let repository = AccountBookTableRepository()
    
    let realm = try! Realm()
    
    // 얘는 한번만 실행돼
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Realm 데이터 불러오기
        // 1. Realm 위치에 접근
        // 위로 뺌
        
        // 2. Realm 중 특정 하나의 테이블 가지고 오기
//        list = realm.objects(AccountBookTable.self)
        
        // MARK: 정렬!
        // 데이터베이스 사용 -> 정렬을 해서 변수에 담음! 더 빠르다!
        // 금액 순으로 이미 정렬된 상태로 리스트에 담아보자 -> 쿼리!
        // 전체 데이터 정렬한 것
//        list = realm.objects(AccountBookTable.self).sorted(byKeyPath: "money", ascending: true)
        
        
        // 램 데이터가 변하면 list에서 알아서 반영된다! 그래서 테이블뷰 reload만 해주면 된다.
        
        // MARK: Filter!!!
//        list = realm.objects(AccountBookTable.self).where {
//            // $0.money >= 30000 // 3만원 이상 필터
//            $0.isDeposit == false // 입금만 필터
//            // $0.category == "study"
//        }.sorted(byKeyPath: "money", ascending: true)
        
        
        list = repository.fetchItem("study")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()

    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func configureView() {
        super.configureView() // BaseViewController의 내용도 실행해
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
        
        navigationItem.title = "용돈기입장"
        
        let item = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem = item
        
        // MARK: 데이터베이스 필터 기능 추가
        
        
    }
    
    @objc func rightBarButtonItemTapped() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell")!
        cell.textLabel?.text = "🥟\(list[indexPath.row].money)원 \(list[indexPath.row].category)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK: Realm Delete 삭제
        // 램 파일에서 제거!!
        // 위로 뺌
//        try! realm.write {
//            realm.delete(list[indexPath.row])
//        }
//        
//        tableView.reloadData()
        
        // MARK: Realm Update
        // 한 레코드에 특정 column값을 수정하고 싶은 경우
//        try! realm.write {
//            list[indexPath.row].category = "개발"
//        }
        
        let record = list[indexPath.row]
        repository.updateFavorite(record)
        
        // MARK: Realm Update 2
        // 한 레코드가 아니라 전체 column에 대한 값 수정
//        try! realm.write {
//            list.setValue(100000, forKey: "money")
//        }
        repository.updateMoney(value: 10000, key: "money")
        
        // MARK: Realm Update3
        // 한 레코드에서 여러 컬럼 정보를 수정하고 싶을 때
//        try! realm.write {
//            realm.create(AccountBookTable.self, value: ["id": list[indexPath.row].id, "money": 100, "favorite": true], update: .modified)
//        }
//        
        repository.updateItem(id: list[indexPath.row].id, money: 999, category: "develop")
        
        tableView.reloadData()
    }
}


//#Preview {
//    MainViewController()
//}
