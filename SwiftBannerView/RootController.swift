//
//  RootController.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class RootController: UIViewController {
    
    lazy var textArr : NSMutableArray = { () -> NSMutableArray in
        var textArr :NSMutableArray = NSMutableArray()
        textArr.add("纯SwfitBannerView")
        textArr.add("依赖 Kingfisher 4.0 +")
        textArr.add("通过模型统一设置属性")
        textArr.add("希望大家给小星星")
        textArr.add("谢谢大家!!!")
        return textArr
    }()
    
    var scrollView : UIScrollView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        let backItem : UIBarButtonItem = UIBarButtonItem.init()
        backItem.title = "返回"
        navigationItem.backBarButtonItem = backItem
        
        setupScrollView()
    }
    
    @objc func setupScrollView(){
        let scrollView : UIScrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = CGSize(width: 0, height: 30 + 180 + 30 + 180 + 180 + 130);
        self.scrollView = scrollView
        view.addSubview(scrollView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollView?.frame = self.view.bounds
    }
}
