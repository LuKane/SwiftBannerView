//
//  SwiftBannerView.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//
/**
 * 使用 SwiftBannerView的过程中,有任何bug或问题,都可以在github上提出 issue
 * 或者 联系QQ: 1169604556
 * Github: https://github.com/LuKane
 */

import UIKit

/// SwiftBannerView 的代理
@objc protocol SwiftBannerViewDelegate {
    
   /// SwiftBannerView 的点击事件
   ///
   /// - Parameters:
   ///   - bannerView: 当前 banner
   ///   - collectionView: 当前 collectionView
   ///   - collectionViewCell: 当前 cell
   ///   - index: 当前下标
   @objc optional func bannerView(_ bannerView :SwiftBannerView, collectionView :UICollectionView, collectionViewCell : SwiftBannerCollectioniewCell, didSelectItemAtIndexPath index :Int)
    
   @objc optional func bannerView(_ bannerView : SwiftBannerView,_ topColor : UIColor?, _ bottomColor : UIColor?,_ alpha : CGFloat,_ isRight : Bool)
}

class SwiftBannerView: UIView , UICollectionViewDelegate , UICollectionViewDataSource {
    weak var delegate : SwiftBannerViewDelegate?
    
    /// 滚动图片的倍数
    private var kAccount : Int = 100
    /// 流水布局的 layout
    private var layout : UICollectionViewFlowLayout?
    /// 设置 总的父控件
    private var collectionView : UICollectionView?
    /// Cell 的 指定字符串 : 缓存池获取
    private let SwiftBannerViewCellID : String = "SwiftBannerViewCellID"
    /// collectionView 的 cell
    private var collectionViewCell : SwiftBannerCollectioniewCell!
    
    private var collectionUseCell : SwiftBannerCollectioniewCell!
    /// collectionView 的 '数据源' 数组
    private var ImageArr : NSMutableArray = NSMutableArray()
    /// 默认的 banner 数据 模型
    private var defaultModel : SwiftBannerModel?
    /// 定时器
    private var bannerTimer : Timer?
    /// pageControl
    private var pageControl : SwiftBannerPageControl?
    /// 文字的 控件
    private var viewText : SwiftBannerViewText?
    // 第一次设置
    private var _firstSet : Bool = false
    // 滑动到中间时,偏移量
    private var lastContentOffsetX : CGFloat?
    
    /// 公开一个 bannerModel , 用于设置 banner的各种属性
    public var bannerModel : SwiftBannerModel? {
        didSet{
            setBannerModel()

            if bannerModel?.bgChangeColorArr != nil {
                if bannerModel?.bgChangeColorArr?.count == 1 {
                    if let delegate = self.delegate {
                        delegate.bannerView?(self, (bannerModel?.bgChangeColorArr![0])! as? UIColor, nil, 1, false)
                    }
                }
            }
        }
    }
    
    private func setBannerModel(){
        // 1.先移除定时器
        removeTimer()
        
        // 需要定时器
        if bannerModel?.isNeedTimerRun == true {
            
            if bannerModel?.timeInterval != nil {
                if Double((bannerModel?.timeInterval)!) <= 0 {
                    bannerModel?.timeInterval = defaultModel?.timeInterval
                }
            }else{
                bannerModel?.timeInterval = defaultModel?.timeInterval
            }
            setupTimer()
        }
        
        // 需要循环播放
        if bannerModel?.isNeedCycle == true {
            jumpToLocation()
        }else{
            kAccount = 1
            jumpToLocation()
            self.collectionView?.reloadData()
        }
        
        // 是否有 占位图
        if bannerModel?.placeHolder == nil {
            bannerModel?.placeHolder = defaultModel?.placeHolder!
        }
        
        // pageControl
        if bannerModel?.pageControlStyle == nil {
            bannerModel?.pageControlStyle = defaultModel?.pageControlStyle!
        }
        
        // 当前 pageControl的颜色
        if bannerModel?.currentPageIndicatorTintColor == nil {
            bannerModel?.currentPageIndicatorTintColor = defaultModel?.currentPageIndicatorTintColor!
        }
        
        // 剩下 pageControl 的颜色
        if bannerModel?.pageIndicatorTintColor == nil {
            bannerModel?.pageIndicatorTintColor = defaultModel?.pageIndicatorTintColor!
        }
        
        // 是否需要 PageControl
        if bannerModel?.isNeedPageControl == false {
            bannerModel?.isNeedPageControl = defaultModel?.isNeedPageControl!
        }else{
            pageControl?.isHidden = false
        }
        
        if bannerModel?.currentPage == nil {
            bannerModel?.currentPage = defaultModel?.currentPage
        }
        
        
        // 自定义pageControl 的图片
        if bannerModel?.pageControlImgArr == nil { // 系统
            
            let bannerM = SwiftBannerModel()
            bannerM.pageControlStyle = bannerModel?.pageControlStyle!
            bannerM.pageIndicatorTintColor = bannerModel?.pageIndicatorTintColor!
            bannerM.currentPageIndicatorTintColor = bannerModel?.currentPageIndicatorTintColor!
            bannerM.currentPage = bannerModel?.currentPage
            bannerM.numberOfPages = ImageArr.count
            pageControl?.bannerModel = bannerM
        }else{ // 自定义
            bannerModel?.numberOfPages = ImageArr.count
            
            if(bannerModel?.currentPage == nil ){
                bannerModel?.currentPage = defaultModel?.currentPage
            }
            pageControl?.bannerModel = bannerModel
        }
        
        // 文字的改变样式
        if bannerModel?.textChangeStyle == nil {
            bannerModel?.textChangeStyle = defaultModel?.textChangeStyle
        }
        
        // 文字的显示样式
        if bannerModel?.textShowStyle == nil {
            bannerModel?.textShowStyle = defaultModel?.textShowStyle
        }
        
        // 文字的颜色
        if bannerModel?.textColor == nil {
            bannerModel?.textColor = defaultModel?.textColor
        }
        
        // 文字的font
        if bannerModel?.textFont == nil {
            bannerModel?.textFont = defaultModel?.textFont
        }
        
        // 文字的父控件的背景颜色
        if bannerModel?.textBackGroundColor == nil {
            bannerModel?.textBackGroundColor = defaultModel?.textBackGroundColor
        }
        
        // 文字的父控件的背景透明度
        if bannerModel?.textBackGroundAlpha == nil {
            bannerModel?.textBackGroundAlpha = defaultModel?.textBackGroundAlpha
        }
        
        if bannerModel?.leftMargin != nil{
            
        }else{
            bannerModel?.leftMargin = defaultModel?.leftMargin
        }
        
        var isNeedText : Bool = false
        if bannerModel?.textArr != nil {
            if bannerModel?.textArr?.count == ImageArr.count {
                isNeedText = true
            }
            
            switch bannerModel?.textChangeStyle {
            case .follow?: // 跟着一起跑
                bannerModel?.isNeedText = true
                break
                
            case .stay? : // 不动
                bannerModel?.isNeedText = false
                if isNeedText == true {
                    if viewText == nil {
                        initViewText()
                    }
                }
                break
                
            default:
                break
            }
        }
        
        if isNeedText == true {
            if bannerModel?.textHeight == nil {
                bannerModel?.textHeight = (defaultModel?.textHeight)!
            }
        }
        
        defaultModel = bannerModel
        
        // 是否需要 无限循环
        if bannerModel?.isNeedCycle == true {
            jumpToLocation()
        }else{
            kAccount = 1
            jumpToLocation()
            collectionView?.reloadData()
        }
    }
    
    /// 重写 本地图片数组
    var locationImageArr : NSMutableArray = [] {
        didSet{
            ImageArr.removeAllObjects()
            collectionView?.reloadData()
            
            for image in locationImageArr {
                let isImage : Bool = image is UIImage
                assert(isImage, "\n **加载本地图片,LocationImgArr 内必须添加 图片(UIImage) ** \n")
                ImageArr.add(image)
            }
            initPageAndJumpToLocation()
        }
    }
    
    /// 重写 网络图片数组
    var networkImageArr : NSMutableArray = [] {
        didSet{
            ImageArr.removeAllObjects()
            collectionView?.reloadData()
            
            for url in networkImageArr {
                let isUrl : Bool = url is String
                assert(isUrl, "\n **加载网络图片,NetWorkImgArr 内必须添加 图片URL的绝对路径** \n")
                
                var isHttpString : Bool = false
                if (url as! String).hasPrefix("http") {
                    isHttpString = true
                }
                assert(isHttpString, "\n **加载网络图片,NetWorkImgArr 内必须添加 图片URL的绝对路径** \n")
                ImageArr.add((url as! String))
            }
            initPageAndJumpToLocation()
        }
    }
    
    /// 重写 混合图片数组
    var blendImageArr : NSMutableArray = [] {
        didSet{
            ImageArr.removeAllObjects()
            collectionView?.reloadData()
            
            for item in blendImageArr {
                var isBlend : Bool = false
                if item is UIImage {
                    isBlend = true
                }
                
                if item is String {
                    if (item as! String).hasPrefix("http") {
                        isBlend = true
                    }
                }
                
                assert(isBlend, "\n **加载混合图片,blendImgArr 内必须添加 图片URL的绝对路径 或者 图片(UIImage) ** \n");
                ImageArr.add(item)
            }
            initPageAndJumpToLocation()
        }
    }
    
    /// 重写 修改背景色的数组
    var changeColorArr : NSMutableArray = [] {
        didSet {
            if changeColorArr.count != 0 {
                bannerModel?.bgChangeColorArr = NSMutableArray(array: changeColorArr)
            }
            _firstSet = false;
            jumpToLocation()
        }
    }
    
    /// 刷新 --> 提供做API 方法(切换banner的图片时候才调用的)
    @objc public func reloadData(){
        
        if ImageArr.count == 0 {
            return;
        }
        
        initDefaultData()
        bannerModel?.numberOfPages = ImageArr.count
        
        initPageControl()
        setBannerModel()
        
        if bannerModel?.isNeedPageControl == true {
            pageControl?.isHidden = false
        }
        
        pageControl?.bannerModel = bannerModel
        collectionView?.reloadData()
    }
    
    /// 重写 initWithFrame
    ///
    /// - Parameter frame: frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化 collectionView
        initCollectionView()
        // 初始化 基本数据
        initDefaultData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 类方法创建 本地 图片轮播器
    ///
    /// - Parameters:
    ///   - locationImgArr: 本地图片数组 (存放的都是图片)
    ///   - frame: frame
    /// - Returns: bannerView
    class func bannerViewLocationImgArr(_ locationImgArr :NSMutableArray?, bannerFrame frame :CGRect) -> SwiftBannerView {
        
        let bannerView = SwiftBannerView(frame: frame)
        if locationImgArr?.count == 0 {
            return bannerView
        }
        bannerView.locationImageArr = locationImgArr?.mutableCopy() as! NSMutableArray
        return bannerView
    }
    
    /// 类方法创建 网络 图片轮播器
    ///
    /// - Parameters:
    ///   - networkImgArr: 网络图片数组 (存放的都是 url)
    ///   - frame: frame
    /// - Returns: bannerView
    class func bannerViewNetworkImgArr(_ networkImgArr :NSMutableArray?, bannerFrame frame :CGRect) -> SwiftBannerView{
        
        let bannerView = SwiftBannerView(frame: frame)
        if networkImgArr?.count == 0 {
            return bannerView
        }
        bannerView.networkImageArr = networkImgArr?.mutableCopy() as! NSMutableArray
        return bannerView
    }
    
    /// 类方法创建 混合 图片轮播器
    ///
    /// - Parameters:
    ///   - blendImgArr: 混合图片数组 (存放的是 本地图片image 或者 url)
    ///   - frame: frame
    /// - Returns: bannerView
    class func bannerViewBlendImgArr(_ blendImgArr :NSMutableArray?, bannerFrame frame :CGRect) -> SwiftBannerView {
        
        let bannerView = SwiftBannerView(frame: frame)
        if blendImgArr?.count == 0 {
            return bannerView
        }
        bannerView.blendImageArr = blendImgArr?.mutableCopy() as! NSMutableArray
        return bannerView
    }
    
    /// 初始化 collectionView
    private func initCollectionView(){
        
        // 流水布局的 滚动基本属性
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = self.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.layout = layout
        
        // collectionView
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(SwiftBannerCollectioniewCell.self, forCellWithReuseIdentifier: SwiftBannerViewCellID)
        
        self.collectionView = collectionView
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.pageControl?.frame = CGRect(x: bannerModel?.leftMargin ?? 0, y: self.height - 30, width: self.width - 2 * (bannerModel?.leftMargin ?? 0), height: 30)
        
        layout?.itemSize = self.size
        collectionView?.frame = self.bounds
        collectionView?.collectionViewLayout = layout!
        collectionView?.reloadData()
        
        if viewText != nil {
            viewText?.frame = CGRect(x: bannerModel?.leftMargin ?? 0, y: self.height - (bannerModel?.textHeight)!, width: self.width - (bannerModel?.leftMargin ?? 0) * 2, height: (bannerModel?.textHeight)!)
        }
        
        if ImageArr.count == 1 {
            return
        }
        
        var index = ImageArr.count * kAccount / 2
        if bannerModel?.isNeedCycle == false {
            index = 0
        }
        collectionView?.setContentOffset(CGPoint(x: CGFloat(Int((collectionView?.width)!) * index), y: 0), animated: false)
    }
    
    /// 初始化 默认数据
    private func initDefaultData(){
        
        defaultModel = SwiftBannerModel()
        
        defaultModel?.isNeedCycle = false
        defaultModel?.isNeedTimerRun = false
        defaultModel?.timeInterval = 1.5
        defaultModel?.placeHolder = createImageWithUIColor(UIColor.lightText)
        
        // pageControl
        defaultModel?.isNeedPageControl = false
        defaultModel?.currentPageIndicatorTintColor = UIColor.green
        defaultModel?.pageIndicatorTintColor = UIColor.white
        defaultModel?.pageControlStyle = .right
        defaultModel?.currentPage = 0
        
        // 文字
        defaultModel?.textChangeStyle = .follow
        defaultModel?.textShowStyle = .left
        defaultModel?.textColor = UIColor.white
        defaultModel?.textFont = UIFont(name: "Heiti SC", size: 15)
        defaultModel?.textBackGroundColor = UIColor.black
        defaultModel?.textBackGroundAlpha = 0.7
        defaultModel?.textHeight = 30
        
        // 边距
        defaultModel?.leftMargin = 0
        // 圆角
        defaultModel?.bannerCornerRadius = 0
    }
    
    /// 初始化 pageControl 以及跳转到指定位置
    private func initPageAndJumpToLocation(){
        guard ImageArr.count > 1 else {
            if pageControl != nil {
                pageControl?.removeFromSuperview()
                pageControl = nil
            }
            
            if viewText != nil {
                viewText?.removeFromSuperview()
                viewText = nil
            }
            
            return
        }
        initPageControl()
        jumpToLocation()
    }
    
    /// 初始化 pageControl
    private func initPageControl(){
        
        if self.pageControl != nil {
            return
        }
        
        guard ImageArr.count > 1 else {
            return
        }
        
        let pageControl = SwiftBannerPageControl.init(frame: CGRect(x: bannerModel?.leftMargin ?? 0, y: self.height - 30, width: self.width - 2 * (bannerModel?.leftMargin ?? 0), height: 30))
        pageControl.isHidden = true
        self.pageControl = pageControl
        addSubview(pageControl)
    }
    
    /// 初始化 .stay模型下的 文字父控件
    private func initViewText(){
        let viewText : SwiftBannerViewText = SwiftBannerViewText(frame: CGRect(x: bannerModel?.leftMargin ?? 0, y: self.height - (bannerModel?.textHeight)!, width: self.width - (bannerModel?.leftMargin ?? 0) * 2, height: (bannerModel?.textHeight)!))
        viewText.bannerM  = bannerModel
        viewText.text = bannerModel?.textArr?.firstObject as? String
        self.viewText = viewText
        insertSubview(viewText, belowSubview: pageControl!)
    }
    
    /// 跳转到 指定位置
    private func jumpToLocation(){
        guard ImageArr.count > 1 else {
            return
        }
        
        var index : Int = ImageArr.count * kAccount / 2
        if self.bannerModel?.isNeedCycle == nil {
            index = 0
        }
        
        self.collectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(ImageArr.count == 1) {
            return 1
        }else {
            return ImageArr.count * kAccount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftBannerViewCellID, for: indexPath)
        
        collectionViewCell = cell as? SwiftBannerCollectioniewCell
        
        let row : Int = indexPath.row % ImageArr.count
        
        if ImageArr[row] is String { // 如果是 字符串
            if (ImageArr[row] as! String).hasPrefix("http") { // 如果是 url
                collectionViewCell.placeHolder = bannerModel?.placeHolder
                collectionViewCell.url = ImageArr[row] as? String
            }
        }else { // 如果不是字符串 : 是图片
            if ImageArr[row] is UIImage { // 是图片
                collectionViewCell.image = ImageArr[row] as? UIImage
            }
        }
        
        if let Arr : NSMutableArray = bannerModel?.bgChangeColorArr as? NSMutableArray {
            if Arr.count != 0 {
                collectionViewCell.bgChangeColor = Arr[row] as? UIColor
            }
        }
        
        if collectionViewCell.isSet != true {
            collectionViewCell.isSet = true
            collectionViewCell.bannerM = bannerModel
        }
        
        if _firstSet == false {
            _firstSet = true;
            collectionUseCell = collectionViewCell
        }
        
        if bannerModel?.textChangeStyle == .follow && bannerModel?.isNeedText == true {
            collectionViewCell.text = bannerModel?.textArr![row] as? String
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row : Int = indexPath.row % ImageArr.count
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let delegate = self.delegate {
            delegate.bannerView?(self, collectionView: collectionView, collectionViewCell: cell as! SwiftBannerCollectioniewCell, didSelectItemAtIndexPath: row)
        }
    }
    
    /// 设置 timer
    private func setupTimer(){
        if ImageArr.count == 1 {
            return
        }
        
        if bannerModel?.isNeedTimerRun == false {
            return
        }
        
        if bannerModel?.timeInterval == nil || bannerModel?.timeInterval == 0 {
            return
        }
        
        if bannerTimer != nil {
            removeTimer()
        }
        
        let timer = Timer(timeInterval: (bannerModel?.timeInterval)!, repeats: true) { [weak self] (timer) in
            self?.timeRun()
        }
        bannerTimer = timer
        
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    /// 移除 timer
    private func removeTimer(){
        bannerTimer?.invalidate()
        bannerTimer = nil
    }
    
    /// 定时器开始跑
    @objc private func timeRun(){
        
        if ImageArr.count == 0 {
            return
        }
        
        var index = Int(((collectionView?.contentOffset.x)! / (layout?.itemSize.width)!)) + 1;
        
        if index == ImageArr.count * kAccount || index == 0 {
            
            guard kAccount != 1 else {
                return
            }
            
            index = ImageArr.count * kAccount / 2
            
            self.collectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false);
        }
        self.collectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: true);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard ImageArr.count > 1 else {
            return
        }
        
        let contentOffsetX : CGFloat = (CGFloat(Int(scrollView.contentOffset.x)) + scrollView.width) / scrollView.width
        autoreleasepool {
            let arr : NSArray = "\(contentOffsetX)".components(separatedBy: ".") as NSArray
            
            let cellArr : [SwiftBannerCollectioniewCell] = collectionView?.visibleCells as! [SwiftBannerCollectioniewCell]
            
            
            if arr.count == 2 {
                let lastStr : String = arr.lastObject as! String
                
                if lastStr == "0" {
                    
                    let index : Int = (Int(contentOffsetX) - 1) % ImageArr.count
                    
                    lastContentOffsetX = contentOffsetX
                    
                    if viewText != nil && bannerModel?.textChangeStyle == .stay {
                        viewText?.text = bannerModel?.textArr![index] as? String
                    }
                    
                    if pageControl?.isHidden == false {
                        pageControl?.currentPage = index
                    }
                    
                    let path : IndexPath = NSIndexPath(row: Int(scrollView.contentOffset.x / scrollView.frame.size.width), section: 0) as IndexPath
                    collectionUseCell = collectionView?.cellForItem(at: path) as? SwiftBannerCollectioniewCell
                    
                    if bannerModel?.bgChangeColorArr?.count != 0 {
                        if let delegate = self.delegate {
                            delegate.bannerView?(self, (bannerModel?.bgChangeColorArr![index])! as? UIColor, nil, 1.0, true)
                        }
                    }
                    
                }else{
                    
                    if let Arr : NSMutableArray = bannerModel?.bgChangeColorArr as? NSMutableArray {
                        if Arr.count == 0 {
                            return;
                        }
                    }
                    
                    if cellArr.count == 2 {
                        
                        var cell = cellArr[0] as SwiftBannerCollectioniewCell!
                        if cell == collectionUseCell {
                            cell = cellArr[1]
                        }else{
                            cell = cellArr[0]
                        }
                        
                        let offSetX : String = "\(contentOffsetX)"
                        if offSetX.contains(".") {
                            var isRight = true
                            if contentOffsetX < lastContentOffsetX! {
                                isRight = true
                            }else if contentOffsetX > lastContentOffsetX! {
                                isRight = false
                            }
                            
                            let alphaStr : String = "0." + offSetX.components(separatedBy: ".")[1]
                            let alpha = CGFloat(Double(alphaStr)!)
                            if let delegate = self.delegate {
                                delegate.bannerView?(self, collectionUseCell.bgChangeColor, cell?.bgChangeColor, alpha, isRight)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
    
    /// 通过颜色创建图片
    ///
    /// - Parameter imageColor: 图片颜色
    /// - Returns: 图片
    private func createImageWithUIColor(_ imageColor :UIColor) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(imageColor.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    deinit {
        print("SwiftBannerView -> deinit")
    }
}
