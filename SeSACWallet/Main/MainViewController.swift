//
//  MainViewController.swift
//  SeSACWallet
//
//  Created by Madeline on 2/14/24.
//

import SnapKit
import UIKit

class MainViewController: BaseViewController {

    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureConstraints() {
        view.addSubview(tableView)
    }
    
    override func configureHierarchy() {
//        tableView.snp.makeConstraints { make in
//            make.edges.equalTo(view)
//        }
    }
    
    override func configureView() {
        super.configureView() // BaseViewController의 내용도 실행해
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.title = "용돈기입장"
        
        let item = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc func rightBarButtonItemTapped() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
