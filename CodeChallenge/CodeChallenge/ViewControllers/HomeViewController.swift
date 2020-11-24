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
    
    var tableData: [ContentData]?
    
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
        if NetworkState().isNetworkAvailable {
            
            ContentDownloader.sharedInstance.downloadContent(with: { (json, error) in
                if (json != nil) {
                    print("\(String(describing: json))")
                    
                    if let jsonData = json as? [[String: Any]] {
                        ContentFileManager.saveContentData(contentData: jsonData)
                        self.parseData(jsonData: jsonData)
                    }
                } else {
                    print("\(String(describing: error))")
                }
            })
        } else {
            self.showAlert(title: "Error!", message: "Network is not available. Data from local data file is displayed.", buttonTitle: "OK")
            guard let jsonData = ContentFileManager.readContentData() else { return }
            self.parseData(jsonData: jsonData)
        }
    }
    
    func parseData(jsonData: [[String: Any]]) {
        if let jsonString = try? JSONSerialization.data(withJSONObject: jsonData, options: []),
            let content = String(data: jsonString, encoding: .utf8) {
                            
            let contentData = content.data(using: .utf8)!
            let contentDataArray: [ContentData] = try! JSONDecoder().decode([ContentData].self, from: contentData)
            
            if !contentDataArray.isEmpty {
                self.tableData = self.sortList(list: contentDataArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    func sortList(list: [ContentData]) -> [ContentData] {
        let sortedArray = list.sorted(by: { $0.type > $1.type })
        print(sortedArray)
        return sortedArray
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.cellIdentifier, for: indexPath) as? ContentTableViewCell,
            let tableData = self.tableData else {
            return UITableViewCell()
        }
        cell.configureCellData(with: tableData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData?.count ?? 0
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableData = self.tableData else { return }
        
        if tableData[indexPath.row].type == "image" {
            if NetworkState().isNetworkAvailable {
                print("Image \(String(describing: tableData[indexPath.row].id)) Selected")
                let imageViewController = ActualSizeImageViewController()
                imageViewController.contentData = tableData[indexPath.row]
                self.navigationController?.pushViewController(imageViewController, animated: true)
            } else {
                self.showAlert(title: "Error!", message: "Network is not available.", buttonTitle: "OK")
            }
        }
    }
}

extension HomeViewController {
    func showAlert(title: String, message: String, buttonTitle: String) {
        let uiAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        uiAlert.addAction(UIAlertAction(title: NSLocalizedString(buttonTitle, comment: "Default action"), style: .default, handler: { _ in
            debugPrint("Alert button tap")
        }))
        
        DispatchQueue.main.async {
            self.present(uiAlert, animated: true, completion: nil)
        }
    }

}
