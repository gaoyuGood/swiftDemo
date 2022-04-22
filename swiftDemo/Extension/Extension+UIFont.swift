//
//  UIStyleExt.swift
//
//
//  Created by *** on 25/1/21.
//  Copyright © 2021 ***. All rights reserved.
//

import Foundation
import SnapKit


// MARK:- 字体

/*
    PingFangSC-Medium
    PingFangSC-Semibold
    PingFangSC-Regular
    PingFangSC-Light
    PingFangSC-Ultralight
    PingFangSC-Thin
    
    HelveticaNeue
    HelveticaNeue-UltraLightItalic
    HelveticaNeue-Medium
    HelveticaNeue-MediumItalic
    HelveticaNeue-UltraLight
    HelveticaNeue-Italic
    HelveticaNeue-Light
    HelveticaNeue-ThinItalic
    HelveticaNeue-LightItalic
    HelveticaNeue-Bold
    HelveticaNeue-Thin
    HelveticaNeue-CondensedBlack
    HelveticaNeue-CondensedBold
    HelveticaNeue-BoldItalic

    Roboto-Black
    Roboto-BlackItalic
    Roboto-Bold
    Roboto-BoldCondensed
    Roboto-BoldCondensedItalic
    Roboto-BoldItalic
    Roboto-Condensed
    Roboto-CondensedItalic
    Roboto-Italic
    Roboto-Light
    Roboto-LightItalic
    Roboto-Medium
    Roboto-MediumItalic
    Roboto-Regular
    Roboto-Thin
    Roboto-ThinItalic
 */

enum CustomFontName:String {
    
    case PingFangSCRegular = "PingFangSC-Regular"
    case PingFangSCLight = "PingFangSC-Light"
    case PingFangSCSemibold = "PingFangSC-Semibold"
    case PingFangSCMedium = "PingFangSC-Medium"
    case PingFangSCThin = "PingFangSC-Thin"
    case HelveticaNeueMedium = "HelveticaNeue-Medium"
    case HelveticaNeueLight = "HelveticaNeue-Light"
    case HelveticaNeue = "HelveticaNeue"
    case Helvetica_Neue = "Helvetica Neue"
    case OpenSansSemibold = "OpenSans-Semibold"
    case PingFangSCHeavy = "PingFangSC-Heavy"
    
    case RobotoBlack = "Roboto-Black"
    case RobotoBlackItalic = "Roboto-BlackItalic"
    case RobotoBold = "Roboto-Bold"
    case RobotoBoldCondensed = "Roboto-BoldCondensed"
    case RobotoBoldCondensedItalic = "Roboto-BoldCondensedItalic"
    case RobotoBoldItalic = "Roboto-BoldItalic"
    case RobotoCondensed = "Roboto-Condensed"
    case RobotoCondensedItalic = "Roboto-CondensedItalic"
    case RobotoItalic = "Roboto-Italic"
    case RobotoLight = "Roboto-Light"
    case RobotoLightItalic = "Roboto-LightItalic"
    case RobotoMedium = "Roboto-Medium"
    case RobotoMediumItalic = "Roboto-MediumItalic"
    case RobotoRegular = "Roboto-Regular"
    case RobotoThin = "Roboto-Thin"
    case RobotoThinItalic = "Roboto-ThinItalic"
    
    func isBold() -> Bool {
        switch self {
        case .PingFangSCMedium,
             .PingFangSCSemibold,
             .HelveticaNeueMedium,
             .OpenSansSemibold,
             .PingFangSCHeavy,
             .RobotoBold,
             .RobotoBoldCondensed,
             .RobotoBoldCondensedItalic,
             .RobotoBoldItalic,
             .RobotoMedium,
             .RobotoMediumItalic
            :
            return true
        default:
            return false
        }
    }
}

extension UIFont {
    class func customFont(name customFontName: CustomFontName, size fontSize: CGFloat) -> UIFont {
        if let customFont = UIFont(name: customFontName.rawValue, size: frameMath(fontSize)) {
            return customFont
        } else {
            if customFontName.isBold() {
                return UIFont.boldSystemFont(ofSize: frameMath(fontSize))
            } else {
                return UIFont.systemFont(ofSize: frameMath(fontSize))
            }
        }
    }
    class func customFontReal(name customFontName: CustomFontName, size fontSize: CGFloat) -> UIFont {
        if let customFont = UIFont(name: customFontName.rawValue, size: fontSize) {
            return customFont
        } else {
            if customFontName.isBold() {
                return UIFont.boldSystemFont(ofSize: fontSize)
            } else {
                return UIFont.systemFont(ofSize: fontSize)
            }
        }
    }
}

// MARK:- 屏幕适配
extension CGRect {
    static func make(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) -> CGRect {
        let scale = 1.0 / (375.0 * UIScreen.main.bounds.width)
        return CGRect(x: x * scale, y: y * scale, width: width * scale, height: height * scale)
    }
}

extension CGSize {
    static func make(width:CGFloat, height:CGFloat) -> CGSize {
        let ratio = 1.0 / (375.0 * UIScreen.main.bounds.width)
        return CGSize(width: width * ratio, height: height * ratio)
    }
}
