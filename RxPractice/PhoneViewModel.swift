//
//  PhoneViewModel.swift
//  RxPractice
//
//  Created by Greed on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    let inputText = BehaviorRelay(value: "010")
    
    let validation = BehaviorRelay(value: false)
    
    let disposeBag = DisposeBag()
    
    //이렇게 해도 되나요??22
    init() {
        inputText
            .map { $0.count >= 10 && (Int($0) != nil) }
            .subscribe(with: self) { owner, value in
                owner.validation.accept(value)
            }
            .disposed(by: disposeBag)
            
    }
    
}
