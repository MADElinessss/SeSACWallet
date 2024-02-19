//
//  MainViewController.swift
//  SeSACWallet
//
//  Created by Madeline on 2/14/24.
//

import FSCalendar
import RealmSwift
import SnapKit
import UIKit

class MainViewController: BaseViewController {

    let tableView = UITableView()
    let calendar = FSCalendar()
    let dataList = ["만두", "터피", "커피"]
    
    var list: Results<AccountBookTable>!
    let repository = AccountBookTableRepository()
    
    let realm = try! Realm()
    let dateFormat = DateFormatter()
    
    
    // 얘는 한번만 실행돼
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormat.dateFormat = "yyyy년 MM월 dd일 hh시"
        
        print(realm.configuration.fileURL)
        
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
        
        
        // list = repository.fetch()
        list = repository.fetchItem("study")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()

    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(calendar)
    }
    
    override func configureConstraints() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(500)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView() // BaseViewController의 내용도 실행해
        
        // MARK: FSCalendar
        calendar.delegate = self
        calendar.dataSource = self
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
        
        navigationItem.title = "용돈기입장"
        
        let rightitem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem = rightitem
        
        // MARK: 날짜 기준 정렬 버튼
        let leftitem = UIBarButtonItem(title: "TODAY", style: .plain, target: self, action: #selector(todayBarButtonItemTapped))
        let allleftitem = UIBarButtonItem(title: "ALL", style: .plain, target: self, action: #selector(allBarButtonItemTapped))
        navigationItem.leftBarButtonItems = [leftitem, allleftitem]
        
        // MARK: 데이터베이스 필터 기능 추가
        
        
    }
    
    @objc func rightBarButtonItemTapped() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func todayBarButtonItemTapped() {
        // MARK: 오늘 날짜만 필터링해서 데이터 가져오고, -> list에 넣기
        // Date는 시, 분, 초로 끝나는게 아니라, 001Z 이런거 더 있음
        // 근데 거기까지 하기 쉽지 않으니까, 캘린더라는 구조체를 사용해서 비교하는게 좋음
        
//        print(Date())
        
        // 오늘 시작 날짜(시간)
        let start = Calendar.current.startOfDay(for: Date())
        
        // 오늘 끝나는 날짜(시간) == 내일 시작 날짜!
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        
        let predicate = NSPredicate(format: "registerationDate >= %@ && registerationDate < %@", start as NSDate, end as NSDate)
    
        list = realm.objects(AccountBookTable.self).filter(predicate)
        
        tableView.reloadData()
    }

    @objc func allBarButtonItemTapped() {
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell")!
        let row = list[indexPath.row]
        
        let result = dateFormat.string(from: row.registerationDate)
        print(row.registerationDate)
        
        cell.textLabel?.text = "\(result)🥟\(row.money)원 \(row.category)"
        
        
        // MARK: Document 폴더에 있는 이미지를 셀에 보여주기
        // Document 위치 찾기 > 경로 완성 > URL 기반으로 조회
        if let image = loadImageFromDocument(fileName: "\(row.id)") {
            cell.imageView?.image = image
        }
        
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

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // TODO: 할 일 개수에 맞게 numberOfEventsFor return
        
        let start = Calendar.current.startOfDay(for: date)
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        let predicate = NSPredicate(format: "registerationDate >= %@ && registerationDate < %@", start as NSDate, end as NSDate)
        
        list = realm.objects(AccountBookTable.self).filter(predicate)
        tableView.reloadData()
        let events = min(list.count, 3)
        return events
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let start = Calendar.current.startOfDay(for: date)//선택한 날짜를 기준으로 시작일
        
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        
        let predicate = NSPredicate(format: "registerationDate >= %@ && registerationDate < %@", start as NSDate, end as NSDate)
        
        list = realm.objects(AccountBookTable.self).filter(predicate)
        
        tableView.reloadData()
    }
    
    // 날짜 대신 들어가는 title
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "TITLE💸"
//    }
    
    // 셀에 들어가는 이미지
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star")
//    }
}
