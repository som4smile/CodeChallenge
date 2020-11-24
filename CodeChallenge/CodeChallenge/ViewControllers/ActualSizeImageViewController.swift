//
//  ActualSizeImageViewController.swift
//  CodeChallenge
//
//  Created by SOM on 24/11/20.
//  Copyright © 2020 Somnath Rasal. All rights reserved.
//

import UIKit
import SnapKit

class ActualSizeImageViewController: UIViewController {

    private var contentImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    var contentData: ContentData?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemGroupedBackground
        self.title = "Image"
        
        self.view.addSubview(self.contentImageView)
        self.contentImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(10.0)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        guard let contentData = self.contentData, let urlString = contentData.data else { return }
        self.downloadImage(urlString: urlString)
    }
    
    func downloadImage(urlString: String) {
        ContentDownloader.sharedInstance.downloadImage(with: urlString, completionBlock: { (imageData, error) in
            if imageData != nil {
                DispatchQueue.main.async {
                    self.contentImageView.image = UIImage(data: imageData as! Data)
                    self.view.layoutSubviews()
                    self.view.layoutIfNeeded()
                }
            }
        })
        
    }
}
