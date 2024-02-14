//
//  BaseViewController.swift
//  SeSACWallet
//
//  Created by Madeline on 2/14/24.
//

import Toast
import UIKit

//class ParentBaseViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("ParentBaseViewController viewDidLoad")
//        test()
//    }
//    
//    func test() {
//        print("ParentBaseViewController test")
//    }
//}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureView()
        configureConstraints()
//        test()
        print("BaseViewController viewDidLoad")
         
    }
    
//    override func test() {
//        print("BaseViewController override test")
//    }
    func configureHierarchy() {
        
    }
    
    func configureView() {
        view.backgroundColor = .white // 얘 쓸라면 super.configureView()해주기
        // 귀찮으면 viewDidLoad에 구현해두면 됨
    }
    
    func configureConstraints() {
        
    }
    
    func showAlert(
        title: String,
        message: String,
        ok: String,
        handler: @escaping (() -> Void)
    ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // handler는 이미 실행된 것
//        let ok = UIAlertAction(title: ok, style: .default, handler: handler)
        
        // 얘는 여기에서 실행하는 것
        let ok = UIAlertAction(title: ok, style: .default) { _ in
            handler()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
        
    }
    
    func showToast() {
        view.makeToast("🍞")
    }
    
}
