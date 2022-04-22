//
//  BaseNavigationController.swift
//
//
//  Created by *** on 25/1/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    override open var shouldAutorotate : Bool {
        return true
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      
        if let viewController = self.viewControllers.last {
            // MARK: - 不需要侧滑返回的类
            let iskind = viewController.conforms(to: NoneInteractivePopGestureProtocol.self)
            if iskind { return false }
        }
        return self.viewControllers.count > 1 ? true : false
    }
    
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        var isHidden = false
        // MARK: - 不需要导航条的类
        let viewController = viewController.conforms(to: NoneNavigationBarProtocol.self)
        
        if viewController {
            isHidden = true
            navigationController.setNavigationBarHidden(true, animated: animated)
        } else {
            navigationController.setNavigationBarHidden(isHidden, animated: animated)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
