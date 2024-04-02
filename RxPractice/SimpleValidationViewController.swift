//
//  SimpleValidationViewController.swift
//  RxPractice
//
//  Created by Greed on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleValidationViewController: UIViewController {
    
    let usernameLabel = UILabel()
    let passLabel = UILabel()
    
    let usernameTextField = UITextField()
    let passTextField = UITextField()
    
    let usernameValidate = UILabel()
    let passValidate = UILabel()
    
    let doButton = UIButton()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        bind()
    }
    
    private func configureView() {
        [usernameLabel, passLabel, usernameTextField, passTextField, usernameValidate, passValidate, doButton].forEach { view.addSubview($0)}
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        usernameLabel.text = "Username"
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        usernameValidate.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        usernameValidate.text = "유저 이름은 5글자 이상이여야 합니다."
        usernameValidate.textColor = .red
        passLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameValidate.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        passLabel.text = "Password"
        passTextField.snp.makeConstraints { make in
            make.top.equalTo(passLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        passValidate.snp.makeConstraints { make in
            make.top.equalTo(passTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        passValidate.text = "비밀번호는 5글자 이상이여야 합니다."
        passValidate.textColor = .red
        doButton.snp.makeConstraints { make in
            make.top.equalTo(passValidate.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        doButton.setTitle("Click", for: .normal)
        doButton.setTitleColor(.white, for: .normal)
        doButton.backgroundColor = .green
    }
    
    private func bind() {
        usernameTextField.rx.text.orEmpty
            .map { $0.count >= 5 }
            .bind(to: passTextField.rx.isEnabled, usernameValidate.rx.isHidden)
            .disposed(by: disposeBag)
        
        passTextField.rx.text.orEmpty
            .map { $0.count >= 5 }
            .bind(to: doButton.rx.isEnabled, passValidate.rx.isHidden)
            .disposed(by: disposeBag)
        
        doButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "complete", message: "good job", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }

}
