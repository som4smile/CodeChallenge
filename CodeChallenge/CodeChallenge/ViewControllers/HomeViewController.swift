//
//  HomeViewController.swift
//  CodeChallenge
//
//  Created by SOM on 23/11/20.
//  Copyright © 2020 Somnath Rasal. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        return UITableView(frame: self.view.bounds, style: .plain)
    }()
    
    var tableData = [ContentData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemGroupedBackground
        self.title = "Home"
        
        self.configureTableView()
        self.retrieveTableData()
    }
    
    private func configureTableView() {
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.cellIdentifier)

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func retrieveTableData() {
        ContentDownloader.sharedInstance.downloadContent(with: { (json, error) in
            if (json != nil) {
                print("\(String(describing: json))")
                
                if let jsonData = json as? [[String: Any]],
                    let jsonString = try? JSONSerialization.data(withJSONObject: jsonData, options: []),
                    let content = String(data: jsonString, encoding: .utf8) {
                    
                    let contentData = content.data(using: .utf8)!
                    let contentDataArray: [ContentData] = try! JSONDecoder().decode([ContentData].self, from: contentData)
                    
                    if !contentDataArray.isEmpty {
                        self.tableData = contentDataArray
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            } else {
                print("\(String(describing: error))")
            }
            
        })
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.cellIdentifier, for: indexPath) as? ContentTableViewCell  else {
            return UITableViewCell()
        }

        cell.configureCellData(with: self.tableData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
}
