//
//  SwiftLocationController.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class SwiftLocationController: RootController , SwiftBannerViewDelegate{
    
    var bannerView1 : SwiftBannerView?
    var bannerView2 : SwiftBannerView?
    var bannerView3 : SwiftBannerView?
    
    
    lazy var changeArr : NSMutableArray = { () -> NSMutableArray in
        let changeArr : NSMutableArray = NSMutableArray()
        
        changeArr.add(UIImage.init(named: "1Change")!)
        changeArr.add(UIImage.init(named: "2Change")!)
        changeArr.add(UIImage.init(named: "3Change")!)
        changeArr.add(UIImage.init(named: "4Change")!)
        changeArr.add(UIImage.init(named: "5Change")!)
        
        return changeArr
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "本地图片"
        
        setupNav()
        
        setBannerView1()
        setBannerView2()
        setBannerView3()
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
        bannerView1?.locationImageArr = NSMutableArray().mutableCopy() as! NSMutableArray
        bannerView2?.locationImageArr = changeArr.mutableCopy() as! NSMutableArray
        bannerView3?.locationImageArr = changeArr.mutableCopy() as! NSMutableArray
        
        bannerView1?.reloadData()
        bannerView2?.reloadData()
        bannerView3?.reloadData()
    }

    /// 创建本地 图片 bannerView
    private func setBannerView1(){
        let locationImArr = NSMutableArray()
        
        locationImArr.add(UIImage.init(named: "1")!)
        locationImArr.add(UIImage.init(named: "2")!)
        locationImArr.add(UIImage.init(named: "3")!)
        locationImArr.add(UIImage.init(named: "4")!)
        locationImArr.add(UIImage.init(named: "5")!)
        
        let bannerModel = SwiftBannerModel()
        
        bannerModel.isNeedTimerRun  = true // 需要定时跑
        bannerModel.timeInterval = 2 // 设置定时时间
        bannerModel.isNeedPageControl = true // 需要 pageControl
        bannerModel.isNeedCycle = true // 需要 无限循环
        
        bannerModel.pageControlStyle = SwiftBannerPageControlStyle.right // pageControl 居右
        bannerModel.pageControlImgArr = [UIImage.init(named: "pageControlSelected1")!,UIImage.init(named: "pageControlUnSelected1")!] // 自定义pageControl 的图片
        bannerModel.textArr = self.textArr.copy() as? NSArray // 显示的文字
        bannerModel.textChangeStyle = .follow // 文字 的显示样式
        
        let bannerView = SwiftBannerView.bannerViewLocationImgArr(locationImArr, bannerFrame: CGRect(x: 0, y: 30, width: view.width, height: 180))
        bannerView.bannerModel = bannerModel // 统一设置模型 来设置 banner的样式
        bannerView.delegate = self
        bannerView.tag = 0
        
        bannerView1 = bannerView
        
        self.scrollView!.addSubview(bannerView)
    }
    
    private func setBannerView2(){
        let locationImArr = NSMutableArray()
        
        locationImArr.add(UIImage.init(named: "1")!)
        locationImArr.add(UIImage.init(named: "2")!)
        locationImArr.add(UIImage.init(named: "3")!)
        locationImArr.add(UIImage.init(named: "4")!)
        locationImArr.add(UIImage.init(named: "5")!)
        
        let bannerModel = SwiftBannerModel()
        
        bannerModel.isNeedTimerRun  = true // 需要定时跑
        bannerModel.timeInterval = 3 // 设置定时时间
        bannerModel.isNeedPageControl = true // 需要 pageControl
        bannerModel.isNeedCycle = true // 需要 无限循环
        
        bannerModel.pageControlStyle = SwiftBannerPageControlStyle.left // pageControl 居左
        bannerModel.pageControlImgArr = [UIImage.init(named: "pageControlSelected1")!,UIImage.init(named: "pageControlUnSelected1")!] // 自定义pageControl 的图片
        bannerModel.textArr = self.textArr.copy() as? NSArray // 显示的文字
        bannerModel.textChangeStyle = .stay // 文字 的显示样式
        bannerModel.textShowStyle = .right // 文字 居右 显示
        
        let bannerView = SwiftBannerView.bannerViewLocationImgArr(locationImArr, bannerFrame: CGRect(x: 0, y:60 + 180, width: view.width, height: 180))
        bannerView.bannerModel = bannerModel // 统一设置模型 来设置 banner的样式
        bannerView.delegate = self
        bannerView.tag = 1
        
        bannerView2 = bannerView
        
        self.scrollView!.addSubview(bannerView)
    }
    
    private func setBannerView3(){
        let locationImArr = NSMutableArray()
        
        locationImArr.add(UIImage.init(named: "1")!)
        locationImArr.add(UIImage.init(named: "2")!)
        locationImArr.add(UIImage.init(named: "3")!)
        locationImArr.add(UIImage.init(named: "4")!)
        locationImArr.add(UIImage.init(named: "5")!)
        
        let bannerModel = SwiftBannerModel()
        
        bannerModel.isNeedPageControl = true // 需要 pageControl
        bannerModel.isNeedCycle = true // 需要 无限循环
        
        bannerModel.pageControlStyle = SwiftBannerPageControlStyle.middle // pageControl 居中
        bannerModel.leftMargin = 10 // 左右边距
        bannerModel.bannerCornerRadius = 8 // 圆角 
        
        let bannerView = SwiftBannerView.bannerViewLocationImgArr(locationImArr, bannerFrame: CGRect(x: 0, y:60 + 180 + 30 + 180, width: view.width, height: 180))
        bannerView.bannerModel = bannerModel // 统一设置模型 来设置 banner的样式
        bannerView.delegate = self
        bannerView.tag = 2
        
        bannerView3 = bannerView
        
        self.scrollView!.addSubview(bannerView)
    }
    
    // 代理事件
    func bannerView(_ bannerView: SwiftBannerView, collectionView: UICollectionView, collectionViewCell: SwiftBannerCollectioniewCell, didSelectItemAtIndexPath index: Int) {
        print("BannerView : \(bannerView.tag) -->  index : \(index)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bannerView1?.frame = CGRect(x: 0, y: 30, width: view.width, height: 180)
        bannerView2?.frame = CGRect(x: 0, y: 60 + 180, width: view.width, height: 180)
        bannerView3?.frame = CGRect(x: 0, y: 60 + 180 + 30 + 180, width: view.width, height: 180)
    }
}
