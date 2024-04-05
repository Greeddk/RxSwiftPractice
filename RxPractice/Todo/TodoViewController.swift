//
//  TodoViewController.swift
//  RxPractice
//
//  Created by Greed on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct Todo {
    let id: UUID
    var title: String
    var done: Bool
    var isFavorite: Bool
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.done = false
        self.isFavorite = false
    }
}

class TodoViewController: UIViewController {
    
    let titleLabel = UILabel()
    let textField = SignTextField(placeholderText: "무엇을 구매하실 건가요?")
    let addButton = UIButton()
    let tableView = UITableView()
    let nextPageButton = PointButton(title: "다음")
    
    let viewModel = TodoViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        bind()
    }
    
    func bind() {
        
        let changeItemName = PublishRelay<(text: String, indexPath: Int)>()
        let checkButtonTap = PublishRelay<Int>()
        let favoriteButtonTap = PublishRelay<Int>()
        let itemDelete = PublishRelay<Int>()
        
        let input = TodoViewModel.Input(todoTitle: textField.rx.text.orEmpty,
                                        addButtonTap: addButton.rx.tap,
                                        nextPageButtonTap: nextPageButton.rx.tap,
                                        changeItemName: changeItemName,
                                        checkButtonTap: checkButtonTap,
                                        favoriteButtonTap: favoriteButtonTap,
                                        itemDelete: itemDelete)
        
        let output = viewModel.transform(input: input)
        
        output.todoTitle
            .drive(textField.rx.text)
            .disposed(by: disposeBag)
        
        output.addButtonTap
            .bind(with: self) { owner, _ in
                owner.textField.text = ""
            }
            .disposed(by: disposeBag)
        
        output.nextPageButtonTap
            .bind(with: self) { owner, _ in
                print("page이동")
            }
            .disposed(by: disposeBag)
        
        output.todoItems
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: TodoTableViewCell.self)) { (row, element, cell) in
                
                cell.title.text = element.title
                cell.changeDone(done: element.done)
                cell.changeFavorite(isFavorite: element.isFavorite)
                
                cell.checkButton.rx.tap.subscribe(with: self) { owner, _ in
                    checkButtonTap.accept(row)
                }
                .disposed(by: cell.disposeBag)
                cell.favoriteButton.rx.tap.subscribe(with: self) { owner, _ in
                    favoriteButtonTap.accept(row)
                }
                .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                let alert = UIAlertController(title: "쇼핑내역 변경", message: "변경할 아이템을 입력해주세요", preferredStyle: .alert)
                alert.addTextField()
                let ok = UIAlertAction(title: "ok", style: .default) { _ in
                    if let first = alert.textFields?[0] {
                        guard let text = first.text else { return }
                        changeItemName.accept((text, indexPath.row))
                    }
                }
                let cancel = UIAlertAction(title: "cancel", style: .cancel)
                alert.addAction(ok)
                alert.addAction(cancel)
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(with: self) { owner, indexPath in
                itemDelete.accept(indexPath.row)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureView() {
        [titleLabel, textField, addButton, tableView, nextPageButton].forEach { view.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.centerX.equalToSuperview()
        }
        titleLabel.text = "쇼핑"
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.trailing.equalTo(textField.snp.trailing).inset(10)
        }
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .systemGray3
        nextPageButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(300)
        }
        nextPageButton.addTarget(self, action: #selector(nextPageButtonTapped), for: .touchUpInside)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view).inset(10)
            make.bottom.equalTo(nextPageButton.snp.top)
        }
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func nextPageButtonTapped() {
        print("next")
    }
}
