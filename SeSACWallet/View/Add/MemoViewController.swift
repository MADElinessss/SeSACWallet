//
//  MemoViewController.swift
//  SeSACWallet
//
//  Created by Madeline on 2/14/24.
//

import UIKit

class MemoViewController: BaseViewController {
    
    let memoTextView = UITextView()
    
    // 값 전달 4. 프로토콜
    var delegate: PassDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // addObserver보다 post가 먼저 신호를 보내면, addObserver가 신호를 받지 못한다!
        // addObserver가 먼저 -> 그 다음에 post 여야 함!!
        NotificationCenter.default.addObserver(self, selector: #selector(memoNotificationObserved), name: NSNotification.Name("MemoPost"), object: nil)
    
    }
    
    // 값 전달 4. 프로토콜
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 여기에서 실행!
        delegate?.memoReceived(text: memoTextView.text!)
    }
    
    @objc func memoNotificationObserved(_ notification: NSNotification) {
        print(notification)
    }
    
    override func configureHierarchy() {
        view.addSubview(memoTextView)
    }
    
    override func configureConstraints() {
        memoTextView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        memoTextView.backgroundColor = .lightGray
        

    }

}
