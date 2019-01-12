//
//  ViewController.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class ViewController: RootController,UITableViewDelegate,UITableViewDataSource{
    
    lazy var dataArr : NSMutableArray = { () -> NSMutableArray in
        let dataArr : NSMutableArray = NSMutableArray()
        dataArr.add("SwiftLocationController")
        dataArr.add("SwiftNetworkController")
        dataArr.add("SwiftBlendController")
        dataArr.add("SwiftBackGroundController")
        return dataArr
    }();
    
    lazy var tableView : UITableView = { () -> UITableView in
        let tableView : UITableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
        
        title = "SwiftBannerView演示"
        view.addSubview(self.tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID : String = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: ID)
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = self.dataArr[indexPath.row] as? String;
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        
            case 0:
                let vc = SwiftLocationController()
                navigationController?.pushViewController(vc, animated: true)
                break
            
            case 1:
                let vc = SwiftNetworkController()
                navigationController?.pushViewController(vc, animated: true)
                break
            
            case 2:
                let vc = SwiftBlendController()
                navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc = SwiftBackGroundController()
                navigationController?.pushViewController(vc, animated: true)
                break
            default: break
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
    }
}

