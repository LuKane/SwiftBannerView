//
//  SwiftBackGroundController.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/7/12.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class SwiftBackGroundController: RootController,SwiftBannerViewDelegate {

    private var topImageView : UIImageView?
    private var bottomImageView : UIImageView?
    private var bannerView1 : SwiftBannerView?
    
    lazy var urlArr : NSMutableArray = { () -> NSMutableArray in
        let urlArr : NSMutableArray = NSMutableArray()
        
        urlArr.add("https://wx4.sinaimg.cn/mw690/005TQtyLly1ft05o8ru11j30j608gwfu.jpg")
        urlArr.add("https://wx4.sinaimg.cn/mw690/005TQtyLly1ft05o87llij312c0gwn0p.jpg")
        urlArr.add("https://wx1.sinaimg.cn/mw690/005TQtyLly1ft05o8gwjij30j608g0u1.jpg")
        
        return urlArr
    }()
    
    lazy var changeArr: NSMutableArray = { () -> NSMutableArray in
        let changeArr : NSMutableArray = NSMutableArray()
        
        changeArr.add("https://wx4.sinaimg.cn/mw690/005TQtyLly1ft05o87llij312c0gwn0p.jpg")
        changeArr.add("https://wx1.sinaimg.cn/mw690/005TQtyLly1ft05o8gwjij30j608g0u1.jpg")
        
        return changeArr
    }()
    
    lazy var colorArr: NSMutableArray = { () -> NSMutableArray in
        let colorArr : NSMutableArray = NSMutableArray()
        
        colorArr.add(UIColor.colorWithHex("5676F7"))
        colorArr.add(UIColor.colorWithHex("E95B44"))
        colorArr.add(UIColor.colorWithHex("25A053"))
        
        return colorArr
    }()
    
    lazy var changeColorArr: NSMutableArray = { () -> NSMutableArray in
        let changeColorArr : NSMutableArray = NSMutableArray()
        
        changeColorArr.add(UIColor.colorWithHex("E95B44"))
        changeColorArr.add(UIColor.colorWithHex("25A053"))
        
        return changeColorArr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "背景色切换"
        view.backgroundColor = UIColor.lightGray
        setupNav()
        
        let topImageView : UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 180))
        self.topImageView = topImageView
        view.insertSubview(topImageView, belowSubview: self.scrollView!)
        
        let bottomImageView : UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 180))
        self.bottomImageView = bottomImageView
        view.insertSubview(bottomImageView, belowSubview: self.scrollView!)
        
        setupBannerView1()
    }
    
    func setupNav(){
        let rightBtn : UIButton = UIButton.init(type: .custom)
        rightBtn.setTitleColor(UIColor.black, for: .normal)
        rightBtn.setTitle("Change", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        rightBtn.addTarget(self, action: #selector(rightBtnDidClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    
    @objc func rightBtnDidClick(){
        // 1.若要设置 背景色 ,必须写在 图片数组的前面
        self.bannerView1?.changeColorArr = self.changeColorArr.mutableCopy() as! NSMutableArray
        self.bannerView1?.networkImageArr = self.changeArr.mutableCopy() as! NSMutableArray
        self.bannerView1?.reloadData()
    }
    
    @objc func setupBannerView1(){
        let bannerView = SwiftBannerView.bannerViewNetworkImgArr(self.urlArr, bannerFrame: CGRect(x: 0, y: 60, width: view.bounds.width, height: 180))
        bannerView.delegate = self
        
        let bannerM : SwiftBannerModel = SwiftBannerModel()
        bannerM.textArr = self.textArr.copy() as? NSArray
        bannerM.textChangeStyle = .stay
        bannerM.currentPageIndicatorTintColor = UIColor.orange
        bannerM.pageIndicatorTintColor = UIColor.white
        bannerM.pageControlStyle = .middle
        
        bannerM.isNeedPageControl = true
        bannerM.isNeedCycle = true
        bannerM.bgChangeColorArr = self.colorArr.mutableCopy() as? NSArray
        bannerM.leftMargin = 15
        bannerM.bannerCornerRadius = 10
        
        self.bannerView1 = bannerView;
        bannerView.bannerModel = bannerM
        self.scrollView!.addSubview(bannerView)
    }
    
    func bannerView(_ bannerView: SwiftBannerView, _ topColor: UIColor?, _ bottomColor: UIColor?, _ alpha: CGFloat, _ isRight: Bool) {
        
        /* 当只有一张图片时, 禁止切换背景色 */
//        if bannerView.networkImageArr.count <= 1 {
//            return;
//        }
        
        if topColor != nil {
            self.topImageView?.backgroundColor = topColor
            
            if bottomColor != nil{
                if isRight == true {
                    self.topImageView?.alpha = alpha
                }else{
                    self.topImageView?.alpha = 1 - alpha
                }
            }else{
                self.topImageView?.alpha = 1.0
            }
        }
        
        if bottomColor != nil {
            self.bottomImageView?.backgroundColor = bottomColor
            if isRight == true {
                self.bottomImageView?.alpha = 1 - alpha
            }else{
                self.bottomImageView?.alpha = alpha
            }
        }else{
            self.bottomImageView?.backgroundColor = nil
            self.bottomImageView?.alpha = 0.0
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bannerView1?.frame = CGRect(x: 0, y: 60, width: view.width, height: 180)
        
        topImageView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 180)
        bottomImageView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 180)
    }
}
