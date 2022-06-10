//
//  DemoTabBarController.swift
//
//
//  Created by *** on 25/1/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class DemoTabBarController: BaseTabBarController {
    
    public var goToIndex: Int = -1
    private var currentIndex: Int = index_first
    private var isFirstEntreApp: Bool = false
    
    
    // MARK: - tabBar
    // FirstVC
    public lazy var firstVC = FirstVC()
    private lazy var firstNavC: BaseNavigationController = {
        let firstNavC = BaseNavigationController(rootViewController: firstVC)
        firstNavC.tabBarItem.isEnabled = false
        firstVC.view.backgroundColor = UIColor.cyan
        return firstNavC
    }()
    // SecondVC
    private lazy var secondVC = SecondVC()
    private lazy var secondNavC: BaseNavigationController = {
        let secondNavC = BaseNavigationController(rootViewController: secondVC)
        secondNavC.tabBarItem.isEnabled = false
        secondVC.view.backgroundColor = UIColor.orange
        return secondNavC
    }()
    // ThirdVC
    public lazy var thirdVC = ThirdVC()
    private lazy var thirdNavC: BaseNavigationController = {
        let thirdNavC = BaseNavigationController(rootViewController: thirdVC)
        thirdNavC.tabBarItem.isEnabled = false
        thirdVC.view.backgroundColor = UIColor.gray
        return thirdNavC
    }()
    // FourthVC
    private lazy var fourthVC = FourthVC()
    private lazy var fourthNavC: BaseNavigationController = {
        let fourthNavC = BaseNavigationController(rootViewController: fourthVC)
        fourthNavC.tabBarItem.isEnabled = false
        fourthVC.view.backgroundColor = UIColor.blue
        return fourthNavC
    }()
    // FifthVC
    public lazy var fifthVC = FifthVC()
    private lazy var fifthNavC: BaseNavigationController = {
        let fifthNavC = BaseNavigationController(rootViewController: fifthVC)
        fifthNavC.tabBarItem.isEnabled = false
        return fifthNavC
    }()
    
    //TabBar
    public lazy var custom_tabBar: DemoTabBar = {
        
        let custom_tabBar = DemoTabBar(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kTabBarH))
        
        custom_tabBar.selectedItemSingle = { [weak self] (index) in
            self?.selectedVC(index)
        }
        custom_tabBar.selectedItemDouble = { [weak self] (index) in
            self?.doubleClick(index)
        }
        
        return custom_tabBar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lastIndex = getLastIndex()

        if lastIndex < 0 && goToIndex > -1 {
            lastIndex = goToIndex
            goToIndex = -1
        }
        
        addChild(firstNavC)
        addChild(secondNavC)
        addChild(thirdNavC)
        addChild(fourthNavC)
        addChild(fifthNavC)
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.addSubview(custom_tabBar)
        
        custom_tabBar.selectedItem(lastIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if goToIndex > -1 {
            custom_tabBar.selectedItem(goToIndex)
            goToIndex = -1
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: 获取上一次退出app的索引
    private func getLastIndex() -> Int {
        
        let last = UserDefaults.standard.string(forKey: "LastIndex") ?? ""
        
        if last != "" {
            return NSString(string: last).integerValue
        } else {
            return -1
        }
    }
}

// MARK: - 切换控制器、get当前控制器
extension DemoTabBarController {
    
    // MARK: 外部修改当前选中
    public func changeCurrentVC(_ index: Int) {
        custom_tabBar.selectedItem(index)
    }
    
    // MARK: 切换 TabBar 选中
    private func selectedVC(_ index: Int) {
        
        currentIndex = index
        self.selectedIndex = index
        
        UserDefaults.standard.set("\(index)", forKey: "LastIndex")
        UserDefaults.standard.synchronize()
    }
    
    private func doubleClick(_ index: Int) {
        
        switch index {
        
//        case index_profile:
//            ServerControlTool.showEnvirnmentAlert()
        
        default:
            print("DoubleClick: \(index)")
        }
    }
    
    // MARK: 拿到当前VC
    public func currentViewController() -> UIViewController {

        if let modalVC = self.presentedViewController {
            return modalVC
        }
        
        switch selectedIndex {
        
        case index_first:
            return firstNavC.topViewController ?? firstVC
        case index_second:
            return secondNavC.topViewController ?? secondVC
        case index_third:
            return thirdNavC.topViewController ?? thirdVC
        case index_fourth:
            return fourthNavC.topViewController ?? fourthVC
        case index_fifth:
            return fifthNavC.topViewController ?? fifthVC
            
        default:
            return firstNavC.topViewController ?? firstVC
        }
    }
    
    // MARK: 拿到当前根VC
    public func currentRootViewController() -> UIViewController {
        
        switch selectedIndex {
            
        case index_first:       return firstVC
        case index_second:      return secondVC
        case index_third:       return thirdVC
        case index_fourth:      return fourthVC
        case index_fifth:       return fifthVC
            
        default:    return firstVC
        }
    }
    
    // MARK: 当前所在 navigationController
    public func currentNavigationController() -> BaseNavigationController {
        
        switch selectedIndex {
            
        case index_first:   return firstNavC
        case index_second:  return secondNavC
        case index_third:   return thirdNavC
        case index_fourth:  return fourthNavC
        case index_fifth:   return fifthNavC
            
        default:
            return firstNavC
        }
    }
}

// MARK: - 跳转
extension DemoTabBarController {
    
    // MARK: First
    @objc public func goToFirst() {
        currentNavigationController().popToRootViewController(animated: false)
        changeCurrentVC(index_first)
    }
    // MARK: Second
    @objc public func goToSecond() {
        currentNavigationController().popToRootViewController(animated: false)
        changeCurrentVC(index_second)
    }
    // MARK: Third
    @objc public func goToThird() {
        currentNavigationController().popToRootViewController(animated: false)
        changeCurrentVC(index_third)
    }
    // MARK: Fourth
    @objc public func goToFourth() {
        currentNavigationController().popToRootViewController(animated: false)
        changeCurrentVC(index_fourth)
    }
    // MARK: Fifth
    public func goToFifth() {
        currentNavigationController().popToRootViewController(animated: false)
        changeCurrentVC(index_fifth)
    }
}
