//
//  TodoTableViewCell.swift
//  RxPractice
//
//  Created by Greed on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift

class TodoTableViewCell: UITableViewCell {
    
    let checkButton = UIButton()
    let title = UILabel()
    let favoriteButton = UIButton()
    
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
    
    func configureCell() {
        contentView.addSubview(checkButton)
        contentView.addSubview(title)
        contentView.addSubview(favoriteButton)
        checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
        }
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkButton.snp.trailing).offset(20)
        }
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }

    }
    
    func changeDone(done: Bool) {
        if done {
            checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
    
    func changeFavorite(isFavorite: Bool) {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
}
