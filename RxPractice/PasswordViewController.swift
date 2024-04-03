//
//  PasswordViewController.swift
//  RxPractice
//
//  Created by Greed on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordViewController: UIViewController {
    
    let passwordTextField = {
        let view = UITextField()
        view.placeholder = "비밀번호를 입력해주세요"
        return view
    }()
    let nextButton = {
        let view = UIButton()
        view.backgroundColor = .lightGray
        view.setTitle("완료", for: .normal)
        return view
    }()
    let descriptionLabel = UILabel()
    
    let validText = Observable.just("8자 이상 입력해주세요")
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        [passwordTextField, nextButton, descriptionLabel].forEach { view.addSubview($0) }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func bind() {
//        validText
//            .bind(to: descriptionLabel.rx.text)
//            .disposed(by: disposeBag)
//        
//        let validation = passwordTextField.rx.text.orEmpty
//            .map { $0.count >= 8 }
//            
//        validation
//            .bind(to: descriptionLabel.rx.isHidden, nextButton.rx.isEnabled)
//            .disposed(by: disposeBag)
//        
//        validation
//            .bind(with: self) { owner, value in
//                let color = value ? UIColor.systemPink : UIColor.lightGray
//                owner.nextButton.backgroundColor = color
//            }
//            .disposed(by: disposeBag)
//        
//        nextButton.rx.tap
//            .bind(with: self) { owner, _ in
//                print("show alert")
//            }
//            .disposed(by: disposeBag)
        
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
            
        validation
            .bind(to: descriptionLabel.rx.isHidden, nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("good")
            }
            .disposed(by: disposeBag)
    }

}
