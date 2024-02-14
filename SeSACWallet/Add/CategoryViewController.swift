//
//  CategoryViewController.swift
//  SeSACWallet
//
//  Created by Madeline on 2/14/24.
//

import UIKit

class CategoryViewController: BaseViewController {
    
    let categoryTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 화면이 사라지려고 할 때 값 전달
        // 값 전달 3. notification cener로 전달 하기
        // POST
        NotificationCenter.default.post(name: NSNotification.Name("CategoryReceived"), object: nil, userInfo: ["category": categoryTextField.text!])
        // 딕셔너리 타입으로 값 전달
    }
    
    override func configureHierarchy() {
        view.addSubview(categoryTextField)
    }
    
    override func configureConstraints() {
        categoryTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        categoryTextField.placeholder = "category"
        categoryTextField.backgroundColor = .lightGray
    }
    
    

}
