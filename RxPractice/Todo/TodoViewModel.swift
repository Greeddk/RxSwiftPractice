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
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let todoTitle: ControlProperty<String>
        let addButtonTap: ControlEvent<Void>
        let nextPageButtonTap: ControlEvent<Void>
        let changeItemName: PublishRelay<(text: String, indexPath: Int)>
        let checkButtonTap: PublishRelay<Int>
        let favoriteButtonTap: PublishRelay<Int>
        let itemDelete: PublishRelay<Int>
    }
    
    struct Output {
        let todoItems: BehaviorRelay<[Todo]>
        let todoTitle: Driver<String>
        let addButtonTap: ControlEvent<Void>
        let nextPageButtonTap: ControlEvent<Void>
    }
 
    func transform(input: Input) -> Output {
        
        var filteredData: [Todo] = []
        let items = BehaviorRelay(value: filteredData)
        
        let title = input.todoTitle
            .asDriver()
        
        input.todoTitle
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler())
            .bind(with: self) { owner, value in
                filteredData = value == "" ? owner.data : owner.data.filter { $0.title.lowercased().contains(value.lowercased()) }
                items.accept(filteredData)
            }
            .disposed(by: disposeBag)
        
        input.addButtonTap
            .withLatestFrom(input.todoTitle)
            .subscribe(with: self) { owner, value in
                owner.data.append(Todo(title: value))
                filteredData = owner.data
                items.accept(filteredData)
            }
            .disposed(by: disposeBag)
        
        input.changeItemName
            .subscribe(with: self) { owner, value in
                filteredData[value.indexPath].title = value.text
                let index = owner.data.firstIndex { todo in
                    todo.id == filteredData[value.indexPath].id
                } ?? 0
                owner.data[index].title = value.text
                items.accept(filteredData)
            }
            .disposed(by: disposeBag)
        
        input.checkButtonTap
            .subscribe(with: self) { owner, row in
                filteredData[row].done.toggle()
                let index = owner.data.firstIndex { todo in
                    todo.id == filteredData[row].id
                } ?? 0
                owner.data[index].done.toggle()
                items.accept(filteredData)
            }
            .disposed(by: disposeBag)
        
        input.favoriteButtonTap
            .subscribe(with: self) { owner, row in
                filteredData[row].isFavorite.toggle()
                let index = owner.data.firstIndex { todo in
                    todo.id == filteredData[row].id
                } ?? 0
                owner.data[index].isFavorite.toggle()
                items.accept(filteredData)
            }
            .disposed(by: disposeBag)
        
        input.itemDelete
            .subscribe(with: self) { owner, row in
                let index = owner.data.firstIndex { todo in
                    todo.id == filteredData[row].id
                } ?? 0
                filteredData.remove(at: row)
                owner.data.remove(at: index)
                items.accept(filteredData)
            }
            .disposed(by: disposeBag)
            
        
        return Output(todoItems: items, todoTitle: title, addButtonTap: input.addButtonTap, nextPageButtonTap: input.nextPageButtonTap)
    }
    
}
