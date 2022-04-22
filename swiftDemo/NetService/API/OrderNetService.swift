//
//  OrderNetService.swift
//  LhubIOS
//
//  Created by NTUCLHUB on 21/4/21.
//  Copyright © 2021 LangFZ. All rights reserved.
//

import UIKit
import YYModel
import SwiftyJSON

class OrderNetService {

    static func getOrderHistory(_ callback: @escaping (OrderListModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getOrderHistory.urlString, RequestItemsType.getOrderHistory.encoding, .json, nil, nil) { (response, result) in

            let model: OrderListModel = OrderListModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? OrderListModel()
            callback(model)
        }
    }
    
    static func getOrderDetail(_ number: String, _ callback: @escaping (OrderDetailModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getOrderHistory.urlString + "/\(number)", RequestItemsType.getOrderHistory.encoding, .json, nil, nil) { (response, result) in
            
            let model: OrderDetailModel = OrderDetailModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? OrderDetailModel()
            callback(model)
        }
    }
}

