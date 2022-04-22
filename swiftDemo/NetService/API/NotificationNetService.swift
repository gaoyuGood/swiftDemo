//
//  NotificationNetService.swift
//  LhubIOS
//
//  Created by NTUCLHUB on 16/4/21.
//  Copyright © 2021 LangFZ. All rights reserved.
//

import UIKit
import SwiftyJSON
import YYModel

class NotificationNetService {
    
    static func getNotifications(_ callback: @escaping (LHubNotificationModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getNotifications.urlString, RequestItemsType.getNotifications.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubNotificationModel = LHubNotificationModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubNotificationModel()
            callback(model)
        }
    }
    
    static func postNotificateRead(_ ids: [String], _ callback: @escaping (LHubNotificationModel)->()) {

        let param: [String : Any] = [
            "ids" : ids
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postNotificateRead.urlString, RequestItemsType.postNotificateRead.encoding, .json, nil, param) { (response, result) in
            
            let model: LHubNotificationModel = LHubNotificationModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubNotificationModel()
            callback(model)
        }
    }
    
    static func postNotificateUnread(_ ids: [String], _ callback: @escaping (LHubNotificationModel)->()) {
        
        let param: [String : Any] = [
            "ids" : ids
        ]

        LHubRequestService.shared.requestToken(.post, RequestItemsType.postNotificateUnread.urlString, RequestItemsType.postNotificateUnread.encoding, .json, nil, param) { (response, result) in
            
            let model: LHubNotificationModel = LHubNotificationModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubNotificationModel()
            callback(model)
        }
    }
    
    static func postNotificateDelete(_ ids: [String], _ callback: @escaping (LHubNotificationModel)->()) {
        
        let param: [String : Any] = [
            "ids" : ids
        ]

        LHubRequestService.shared.requestToken(.post, RequestItemsType.postNotificateDelete.urlString, RequestItemsType.postNotificateDelete.encoding, .json, nil, param) { (response, result) in
            
            let model: LHubNotificationModel = LHubNotificationModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubNotificationModel()
            callback(model)
        }
    }
}
