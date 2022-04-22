//
//  Extension+UIColor.swift
//  
//
//  Created by *** on 5/3/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String,alpha: CGFloat = 1.0) {
        let hex = hex.hasPrefix("#")
            ? String(hex.dropFirst())
            : hex
        guard  hex.count == 6
            else {
                self.init(white: 1.0, alpha: 0.0)
                return
        }
        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: alpha)
    }
    
    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0, green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0, blue: CGFloat(valueRGB & 0x0000FF) / 255.0, alpha: alpha)
    }
}

