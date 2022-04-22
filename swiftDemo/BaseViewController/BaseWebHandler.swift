//
//  BaseWebHandler.swift
//
//
//  Created by *** on 27/1/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit
import WebKit

@objc protocol BaseWebViewProtocol: NSObjectProtocol {
    @objc optional func tempProtocol (_ url:String)
}

class BaseWebHandler: NSObject {
    public weak var delegate: BaseWebViewProtocol?
}

extension BaseWebHandler: WKScriptMessageHandler {
    
    // MARK: - 监听 JS调原生 的方法
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
//        let json:JSON = JSON(message.body)
//        guard let dic:Dictionary = json.dictionaryObject else {return}
//        let temp_dic:NSMutableDictionary = NSMutableDictionary(dictionary: dic)
        
        // MARK: - toFlightsTimeline
        if message.name == "tempProtocol" {
            delegate?.tempProtocol?(message.body as? String ?? "")
        }
    }
}

