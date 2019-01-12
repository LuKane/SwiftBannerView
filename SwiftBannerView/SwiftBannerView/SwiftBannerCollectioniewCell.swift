//
//  SwiftBannerCollectioniewCell.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/21.
//  Copyright © 2018年 LuKane. All rights reserved.
//
/**
 * 使用 SwiftBannerView的过程中,有任何bug或问题,都可以在github上提出 issue
 * 或者 联系QQ: 1169604556
 * Github: https://github.com/LuKane
 */

import UIKit
import Kingfisher

class SwiftBannerCollectioniewCell: UICollectionViewCell {
    private var viewText : SwiftBannerViewText?
    // 占位图
    var placeHolder : UIImage?
    // 网络图片 url
    var url : String? {
        didSet {
            self.imageView?.kf.setImage(with: URL.init(string: url!), placeholder: self.placeHolder, options: [.fromMemoryCacheOrRefresh], progressBlock: {  (current, total) in

            }) { [weak self] (image, error, cacheType, url) in
                if(error == nil) {
                    self?.layoutSubviews()
                }
            }
        }
    }
    // 本地图片
    var image : UIImage? {
        didSet {
            self.imageView?.image = image
        }
    }
    // 当前图片的控件
    var imageView : UIImageView?
    // 文字的变更
    var text : String? {
        didSet {
            if viewText?.isHidden == false {
                viewText?.text = text
            }
        }
    }
    // 当前模型 -> 来设置 ViewText 样式
    var bannerM : SwiftBannerModel? {
        didSet {
            if bannerM?.isNeedText == true {
                viewText?.isHidden = false
                viewText?.bannerM = bannerM
            }else{
                viewText?.isHidden = true
            }
        }
    }
    // 是否设置过模型... 避免下次再设置
    var isSet : Bool?
    // 做记录用的 
    var bgChangeColor : UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(){
        
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        self.imageView = imageView
        addSubview(imageView)
        
        let viewText : SwiftBannerViewText = SwiftBannerViewText()
        self.viewText = viewText
        addSubview(viewText)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bannerM?.leftMargin != nil && bannerM?.leftMargin != 0 {
            self.imageView?.frame = CGRect(x: (bannerM?.leftMargin)!, y: 0, width: self.width - 2 * (bannerM?.leftMargin)!, height: self.height)
        }else{
            self.imageView?.frame = self.bounds
        }
        
        if bannerM?.bannerCornerRadius != nil && bannerM?.bannerCornerRadius != 0 {
            self.imageView?.layer.cornerRadius = (bannerM?.bannerCornerRadius)!
        }
        
        if bannerM?.isNeedText == true {
            if bannerM?.leftMargin != nil && bannerM?.leftMargin != 0 {
                viewText?.frame = CGRect(x: (bannerM?.leftMargin)!, y: self.height - (bannerM?.textHeight)!, width: self.width - 2 * (bannerM?.leftMargin)!, height: (bannerM?.textHeight)!)
            }else{
                viewText?.frame = CGRect(x: 0, y: self.height - (bannerM?.textHeight)!, width: self.width, height: (bannerM?.textHeight)!)
            }
        }
    }
}
