//
//  PickerViewController.swift
//  RxPractice
//
//  Created by Greed on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PickerViewController: UIViewController {
    
    let countLabel = UILabel()
    let pickerView1 = UIPickerView()
    
    let data = Observable.just((0..<40).map { $0 })
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        bind()
    }
    
    private func configureView() {
        view.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(pickerView1)
        pickerView1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        data
            .bind(to: pickerView1.rx.itemTitles) { (row, element) in
                return "\(element)"
            }
            .disposed(by: disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .map { $0.description }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
            
    }
    
    
    
    
    
    
}
