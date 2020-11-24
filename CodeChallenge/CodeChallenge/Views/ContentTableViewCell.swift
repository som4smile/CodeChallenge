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
    
    // MARK: - Properties Initializer

    private var idLabel: UILabel = {
        let idLabel = UILabel(frame: CGRect.zero)
        idLabel.textAlignment = .left
        idLabel.numberOfLines = 0
        idLabel.font = .systemFont(ofSize: 13.0)
        idLabel.textColor = .darkGray
        return idLabel
    }()
    
    private var typeLabel: UILabel = {
        let typeLabel = UILabel(frame: CGRect.zero)
        typeLabel.textAlignment = .center
        typeLabel.numberOfLines = 0
        typeLabel.font = .boldSystemFont(ofSize: 13.0)
        typeLabel.textColor = .black
        return typeLabel
    }()
    
    private var dateLabel: UILabel = {
        let dateLabel = UILabel(frame: CGRect.zero)
        dateLabel.textAlignment = .right
        dateLabel.numberOfLines = 0
        dateLabel.font = .systemFont(ofSize: 13.0)
        dateLabel.textColor = .darkGray
        return dateLabel
    }()
    
    private var dataLabel: UILabel = {
        let dataLabel = UILabel(frame: CGRect.zero)
        dataLabel.textAlignment = .left
        dataLabel.numberOfLines = 0
        dataLabel.font = .systemFont(ofSize: 14.0)
        dataLabel.textColor = .black
        return dataLabel
    }()

    private var contentImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
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
            make.left.equalToSuperview().offset(10.0)
            make.top.equalToSuperview().offset(5.0)
        }

        self.contentView.addSubview(self.typeLabel)
        self.typeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.idLabel.snp.bottom).offset(5.0)
            make.centerX.equalToSuperview()
        }

        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(5.0)
            make.right.equalToSuperview().offset(-10.0)
        }
        
        self.contentView.addSubview(self.dataLabel)
        self.dataLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.typeLabel.snp.bottom).offset(5.0)
            make.bottom.equalToSuperview().offset(-10.0)
            make.left.equalToSuperview().offset(10.0)
            make.right.equalToSuperview().offset(-10.0)
            make.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(self.contentImageView)
        self.contentImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.typeLabel.snp.bottom).offset(5.0)
            make.bottom.equalToSuperview().offset(-10.0)
            make.left.equalToSuperview().offset(10.0)
            make.right.equalToSuperview().offset(-10.0)
            make.centerX.equalToSuperview()
        }
        
        layoutSubviews()
        layoutIfNeeded()
    }
    
    // Setup UI with actual data
    func configureCellData(with cellData: ContentData) {
        
        self.idLabel.text = cellData.id ?? ""
        self.dateLabel.text = cellData.date ?? ""
        self.typeLabel.text = cellData.type
        
        if cellData.type == "image" {
            self.contentImageView.isHidden = false
            self.dataLabel.isHidden = true
            self.contentImageView.image = UIImage(named: "defaultImage")
            
            if NetworkState().isNetworkAvailable {
                self.downloadImage(imageURL: cellData.data)
            }
            
        } else {
            self.contentImageView.isHidden = true
            self.dataLabel.isHidden = false
             self.dataLabel.text = "\(cellData.data ?? "")"
        }
    }
    
    // API for Image download
    private func downloadImage(imageURL: String?) {
        guard let urlString = imageURL else { return }
        
        ContentDownloader.sharedInstance.downloadImage(with: urlString, completionBlock: { (imageData, error) in
            if imageData != nil {
                DispatchQueue.main.async {
                    self.contentImageView.image = UIImage(data: imageData as! Data)
                    self.layoutSubviews()
                    self.layoutIfNeeded()
                }
            }
        })
        
    }
}
