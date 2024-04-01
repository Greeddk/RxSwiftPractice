//
//  SumNumberViewController.swift
//  RxPractice
//
//  Created by Greed on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SumNumberViewController: UIViewController {
    
    let textField1 = UITextField()
    let textField2 = UITextField()
    let textField3 = UITextField()
    
    let plusLabel = UILabel()
    
    let resultLabel = UILabel()
    
    let number1 = Observable.just(1)
    let number2 = Observable.just(2)
    let number3 = Observable.just(3)
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        bind()
    }
    
    private func configureView() {
        view.addSubview(textField1)
        textField1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(50)
        }
        textField1.text = "1"
        view.addSubview(textField2)
        textField2.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(5)
            make.centerX.equalTo(view)
            make.width.equalTo(50)
        }
        textField2.text = "1"
        view.addSubview(textField3)
        textField3.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(5)
            make.centerX.equalTo(view)
            make.width.equalTo(50)
        }
        textField3.text = "1"
        view.addSubview(plusLabel)
        plusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(textField3.snp.leading).offset(-5)
            make.centerY.equalTo(textField3)
        }
        plusLabel.text = "+"
        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(textField3.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
    }
    
    private func bind() {
//        number1
//            .map { "\($0)" }
//            .bind(to: textField1.rx.text)
//            .disposed(by: disposeBag)
//        number2
//            .map { "\($0)" }
//            .bind(to: textField2.rx.text)
//            .disposed(by: disposeBag)
//        number3
//            .map { "\($0)" }
//            .bind(to: textField3.rx.text)
//            .disposed(by: disposeBag)
        
        Observable.combineLatest(textField1.rx.text.orEmpty, textField2.rx.text.orEmpty, textField3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0)  + (Int(textValue3) ?? 0)
        }
        .map { $0.description }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
    }
    

}
