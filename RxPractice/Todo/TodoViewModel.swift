//
//  TodoViewModel.swift
//  RxPractice
//
//  Created by Greed on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class TodoViewModel {
    
    var data = [Todo(title: "비누"), Todo(title: "초콜렛"), Todo(title: "감자"),Todo(title: "비누"), Todo(title: "초콜렛"), Todo(title: "감자"),Todo(title: "비누"), Todo(title: "초콜렛"), Todo(title: "감자"),Todo(title: "비누"), Todo(title: "초콜렛"), Todo(title: "감자"),Todo(title: "비누"), Todo(title: "초콜렛"), Todo(title: "감자"),Todo(title: "비누"), Todo(title: "초콜렛"), Todo(title: "감자"),Todo(title: "비누"), Todo(title: "초콜렛"), Todo(title: "감자")]
    
    lazy var items = BehaviorSubject(value: filteredData)
    
    var filteredData: [Todo] = []
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let todoTitle: ControlProperty<String?>
        let addButtonTap: ControlEvent<Void>
        let nextPageButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let todoTitle: Driver<String>
        let addButtonTap: ControlEvent<Void>
        let nextPageButtonTap: ControlEvent<Void>
    }
 
    func transform(input: Input) -> Output {
        
        let title = input.todoTitle.orEmpty
            .asDriver()
        
        input.todoTitle
            .orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler())
            .bind(with: self) { owner, value in
                owner.filteredData = value == "" ? owner.data : owner.data.filter { $0.title.lowercased().contains(value.lowercased()) }
                owner.items.onNext(owner.filteredData)
            }
            .disposed(by: disposeBag)
        
        input.addButtonTap
            .subscribe(with: self) { owner, _ in
                let title = "\(input.todoTitle.orEmpty)"
                owner.data.append(Todo(title: title))
                owner.filteredData = owner.data
                owner.items.onNext(owner.filteredData)
            }
            .disposed(by: disposeBag)
        
        return Output(todoTitle: title, addButtonTap: input.addButtonTap, nextPageButtonTap: input.nextPageButtonTap)
    }

    
}
