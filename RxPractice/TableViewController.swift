//
//  ViewController.swift
//  RxPractice
//
//  Created by Greed on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TableViewController: UIViewController {
    
    let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    var data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    
    lazy var items = BehaviorSubject(value: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bind()
    }
    
    private func configureView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func bind() {
        items
            .bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = "\(row) @ row \(element)"
                cell.accessoryType = .detailButton
            }
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.data.remove(at: indexPath.row)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
    }
    
    
}

