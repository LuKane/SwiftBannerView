//
//  SwiftLocationController.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class SwiftLocationController: RootController , SwiftBannerViewDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "本地图片"
        
        setBannerView1()
        setBannerView2()
        setBannerView3()
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
        bannerModel.leftMargin = 10
        bannerModel.bannerCornerRadius = 8
        
        let bannerView = SwiftBannerView.bannerViewLocationImgArr(locationImArr, bannerFrame: CGRect(x: 0, y:60 + 180 + 30 + 180, width: view.width, height: 180))
        bannerView.bannerModel = bannerModel // 统一设置模型 来设置 banner的样式
        bannerView.delegate = self
        bannerView.tag = 2
        
        self.scrollView!.addSubview(bannerView)
    }
    
    // 代理事件
    func bannerView(_ bannerView: SwiftBannerView, collectionView: UICollectionView, collectionViewCell: SwiftBannerCollectioniewCell, didSelectItemAtIndexPath index: Int) {
        print("BannerView : \(bannerView.tag) -->  index : \(index)")
    }
    
}
