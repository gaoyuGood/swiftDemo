//
//  BaseViewController.swift
//
//
//  Created by *** on 25/1/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit

/// 无滑动返回手势协议
@objc public protocol NoneInteractivePopGestureProtocol {}
/// 无导航条协议
@objc public protocol NoneNavigationBarProtocol {}
/// 用于刷新消息跟判断navigationRootVC
@objc public protocol HadTabBarProtocol {}                      

open class BaseViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    open override class func awakeFromNib() {
        super.awakeFromNib()
    }
    open override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.conforms(to: HadTabBarProtocol.self) {
//            CurrentDelegate.rootTabBar.showPopAdIfNeeded()
//            CurrentDelegate.rootTabBar.message_tool.refreshMessage()
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

open class NoneBarController: BaseViewController, NoneNavigationBarProtocol {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

open class NoneBackPopController: BaseViewController, NoneInteractivePopGestureProtocol {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}
