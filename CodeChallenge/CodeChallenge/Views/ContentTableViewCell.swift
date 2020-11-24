//
//  ContentTableViewCell.swift
//  CodeChallenge
//
//  Created by SOM on 23/11/20.
//  Copyright © 2020 Somnath Rasal. All rights reserved.
//

import UIKit
import SnapKit

class ContentTableViewCell: UITableViewCell {

    static let cellIdentifier = "ContentTableViewCell"
        
    lazy private var idLabel: UILabel = {
        let idLabel = UILabel(frame: CGRect.zero)
        idLabel.numberOfLines = 0
        idLabel.font = .systemFont(ofSize: 13.0)
        idLabel.textColor = .darkGray
        return idLabel
    }()
    
    lazy private var dateLabel: UILabel = {
        let dateLabel = UILabel(frame: CGRect.zero)
        dateLabel.numberOfLines = 0
        dateLabel.font = .systemFont(ofSize: 13.0)
        dateLabel.textColor = .darkGray
        return dateLabel
    }()

    // MARK: Life cycle methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        self.setupLayoutConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layoutIfNeeded()
    }

    // MARK: setup layout contraints
    private func setupLayoutConstraints() {
    
        self.contentView.addSubview(self.idLabel)
        self.idLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
        }

        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.idLabel.snp.bottom).offset(5.0)
             make.left.equalTo(self.idLabel)
        }
    }
    
    func configureCellData(with cellData: ContentData) {
        self.idLabel.text = "\(cellData.id ?? "0000")"
        self.dateLabel.text = "\(cellData.date ?? "01/01/0101")"
    }
}
