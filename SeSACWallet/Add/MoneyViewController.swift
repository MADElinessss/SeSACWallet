//
//  MoneyViewController.swift
//  SeSACWallet
//
//  Created by Madeline on 2/14/24.
//

import UIKit

class MoneyViewController: BaseViewController {

    let moneyTextField = UITextField()
    
    // 값 전달 1
    var money: String?
    // 값 전달 2. 클로저 생성
    var getMoney: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: viewWillDisappear vs viewDidDisappear의 UX적인 차이
    // 화면이 바뀌기도 전에 데이터가 먼저 바뀌어있을 때의 혼란의 가능성이 있다면 did!
    // 상황별로 더 자연스러운 방향이 있음
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: Responder Chain - 앱은 유저의 인터랙션을 어떻게 표현하는가?
        // 유명한 그림 이씀
        // 유저는 텍스트필드를 탭하는게 아니라 디스플레이 액정을 탭하는것임!
        // 그래서 유저가 탭했을 때 반응을 줄 수 있지만, 탭한 것처럼 반응을 주는게 좋은 UX~라는 의견이 있다 정도
        // 면접 대비,, 과제 대비,,
        
        // MARK: 바로 onfocused 상태 -> 키보드 자동으로 올라오게
        moneyTextField.becomeFirstResponder()
        // 여기에 넣으면 애니메이션처럼 한텀 늦게 실행됨
        
        // MARK: 키보드 내려가게
//        moneyTextField.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 값 전달 2. 클로저 - 함수 호출
        getMoney?(moneyTextField.text!)
    }
    
    override func configureHierarchy() {
        view.addSubview(moneyTextField)
    }
    
    override func configureConstraints() {
        moneyTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        moneyTextField.placeholder = "💸 금액을 입력하세요."
        moneyTextField.keyboardType = .numberPad
        moneyTextField.backgroundColor = .lightGray
        moneyTextField.text = money
    }

}
