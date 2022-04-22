//
//  CommonDefineUtils.swift
//
//
//  Created by *** on 25/1/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit
import AdSupport

private let kScreen: CGRect = UIScreen.main.bounds
let kScreenW: CGFloat = kScreen.size.width
let kScreenH: CGFloat = kScreen.size.height

public var kTabBarH: CGFloat { return getTabBarHeight() }
public var kTabBarBotH: CGFloat { return getTabBarBottomHeight() }

func frameMath(_ frame: CGFloat) -> CGFloat {
    return frame/375.0*UIScreen.main.bounds.width
}

func getNaviHeight() -> CGFloat {
    if isIphoneX() {
        return CGFloat(88)
    } else {
        return CGFloat(64)
    }
}
func getStatusHeight() -> CGFloat {
    if isIphoneX() {
        return CGFloat(44)
    } else {
        return CGFloat(20)
    }
}

// MARK: - TabBar
public func getTabBarHeight() -> CGFloat {
    if isIphoneX() {
        return CGFloat(83)
    } else {
        return CGFloat(49)
    }
}
public func getTabBarBottomHeight() -> CGFloat {
    if isIphoneX() {
        return CGFloat(34)
    } else {
        return 0
    }
}

// MARK: - 刘海屏
public func isIphoneX()->Bool {
    
    if UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0 >= 44 {
        return true
    } else {
        return false
    }
}

// MARK: - idfa idfv
func getUUID() -> String {
    
    // idfa
    var uuid:String = ""
//    if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
//        uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
//    }
    
    // idfv
    if uuid == "" || uuid == "00000000-0000-0000-0000-000000000000" {
        uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    return uuid
}

func getTestJson(string:String)->NSDictionary? {
    
    do {
        let jsonString = string
        let jsonData = jsonString.data(using: .utf8)
        let dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        return dict
    } catch {
        
        print("json 转 dic 失败")
    }
    
    return nil
}

