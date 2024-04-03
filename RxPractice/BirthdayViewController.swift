//
//  BirthdayViewController.swift
//  RxPractice
//
//  Created by Greed on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")

    let year = PublishRelay<Int>()
    let month = PublishRelay<Int>()
    let day = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()

    }
    
    func bind() {
        
        year
            .asDriver(onErrorJustReturn: 2024)
            .map { "\($0)년" }
            .drive(yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month
            .asDriver(onErrorJustReturn: 4)
            .map { "\($0)월"}
            .drive(monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        day
            .asDriver(onErrorJustReturn: 3)
            .map { "\($0)일" }
            .drive(with: self, onNext: { owner, value in
                owner.yearLabel.text = value
            })
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .subscribe(with: self, onNext: { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
            })
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .subscribe(with: self) { owner, date in
                let currentDate = Calendar.current.component(.year, from: Date())
                let birth = Calendar.current.component(.year, from: date)
                if currentDate - birth >= 17 {
                    owner.infoLabel.text = "가입 가능한 나이입니다."
                    owner.infoLabel.textColor = .blue
                    owner.nextButton.isEnabled = true
                    owner.nextButton.backgroundColor = .blue
                } else {
                    owner.infoLabel.text = "만 17세 이상만 가입 가능합니다"
                    owner.infoLabel.textColor = .red
                    owner.nextButton.isEnabled = false
                    owner.nextButton.backgroundColor = .lightGray
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(infoLabel)
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}

