//
//  BaseWindow.swift
//
//
//  Created by *** on 17/3/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit

class BaseWindow: UIWindow {
    
    public lazy var rootTabBar: DemoTabBarController = DemoTabBarController()
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        
        self.rootViewController = rootTabBar
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
