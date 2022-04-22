//
//  CurrentDelegate.swift
//
//
//  Created by *** on 19/2/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit
import SwiftyJSON

public let index_first  = 0
public let index_second = 1
public let index_third  = 2
public let index_fourth = 3
public let index_fifth  = 4

class CurrentDelegate: NSObject {

    static public var backLoginAction:(()->())?
    
    class public var rootTabBar: DemoTabBarController {
        get {
            return window.rootTabBar
        }
    }
    
    class public var window: BaseWindow {
        get {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first! as! BaseWindow
        }
    }
}

// MARK: - get VC
extension CurrentDelegate {
    
    class public func currentViewController() -> UIViewController {
        return rootTabBar.currentViewController()
    }
    
    class public func currentNavigationController() -> BaseNavigationController {
        return rootTabBar.currentNavigationController()
    }
    
    class public func selected(_ index: Int) {
        currentNavigationController().popToRootViewController(animated: false)
        rootTabBar.changeCurrentVC(index)
    }
}
