//
//  Extension+String.swift
//  
//
//  Created by *** on 12/4/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit

extension String {
    
    /// 返回价钱字符串 避免精度问题
    ///
    /// - Parameters:
    ///   - str: 传入价钱字符串
    ///   - half_adjust: 是否四舍五入
    /// - Returns: 返回两位不含无效0字符串
    static func getPriceNum(_ str:String, half_adjust:Bool = false) -> String {
        
        let price_arr = str.components(separatedBy: ".")
        
        if price_arr.count > 1 {
            
            var price_first:NSString = NSString(string: price_arr.first ?? "0")
            var price_last:NSString = NSString(string: price_arr.last ?? "")
            
            if price_last.length > 2 {
                
                if half_adjust {
                    //四舍五入
                    let price_t = price_last.substring(with: NSRange(location: 2, length: 1))
                    
                    let cs:CharacterSet? = CharacterSet(charactersIn: "56789").inverted
                    let filtered:String = price_t.components(separatedBy: cs!).joined(separator: "")
                    
                    if filtered == price_t {
                        //五入
                        let temp_last:NSString = price_last.substring(to: 2) as NSString
                        
                        if temp_last == "99" {
                            price_last = ""
                            price_first = NSString(string: "\(price_first.integerValue + 1)")
                        } else if temp_last.integerValue < 9 {
                            price_last = NSString(string: "0\(temp_last.integerValue + 1)")
                        } else {
                            price_last = NSString(string: "\(temp_last.integerValue + 1)")
                        }
                    } else {
                        //四舍
                        price_last = price_last.substring(to: 2) as NSString
                    }
                } else {
                    //保留两位 不四舍五入
                    price_last = price_last.substring(to: 2) as NSString
                }
            }
            
            if price_last.length > 1 {
                if price_last.substring(from: 1) == "0" {
                    //1.10 -> 1.1
                    price_last = price_last.substring(to: 1) as NSString
                }
            }
            
            if price_last == "0" {
                //1.0 -> 1
                price_last = ""
            }
            //有小数的返回
            return price_last != "" ? "\(price_first).\(price_last as String)" : "\(price_first)"
        }
        
        return price_arr.first ?? "0"
    }
}
