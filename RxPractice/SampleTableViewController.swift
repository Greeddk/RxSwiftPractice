//
//  BasicTableViewController.swift
//  RxPractice
//
//  Created by Greed on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SampleTableViewController: UIViewController {
    
    let bag = DisposeBag()
    let tableView = UITableView()
    let addButton = UIButton()
    
    var data = ["First Item",
                "Second Item",
                "Third Item"]
    
    lazy var items = BehaviorSubject(value: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
     
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ \(row)"
                return cell
            }
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.data.remove(at: indexPath.row)
                owner.items.onNext(owner.data)
            }
            .disposed(by: bag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.setTitle("add", for: .normal)
        addButton.setTitleColor(.blue, for: .normal)
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(addButton.snp.bottom)
        }
    }
    
    @objc func addButtonTapped() {
        let random = ["jack", "greed", "moana", "alex", "hue", "musk"]
        data.append(random.randomElement()!)
        items.onNext(data)
    }
    
}

