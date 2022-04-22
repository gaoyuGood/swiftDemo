//
//  LoginNetService.swift
//  LhubIOS
//
//  Created by NTUCLHUB on 1/4/21.
//  Copyright © 2021 LangFZ. All rights reserved.
//

import UIKit
import YYModel
import SwiftyJSON

class LoginNetService {

    static func postLogin(_ email: String, _ password: String, _ callback: @escaping (LoginModel)->()) {
        
        let appendUrl = "?client_id=\(APIURL.client_id)&token_type=\(APIURL.token_type)&grant_type=\(APIURL.grant_type)&username=\(email)&password=\(password)"
        
        LHubRequestService.shared.requestNoToken(.post, RequestItemsType.login.urlString + appendUrl, RequestItemsType.login.encoding, .form, nil, nil) { (response, result) in
            
            let model: LoginModel = LoginModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LoginModel()
            callback(model)
        }
    }
    
    static func postRegister(_ userName: String, _ password: String, _ email: String, _ callback: @escaping (LHubListCourseModel)->()) {
        
        let header = [
            "Accept-Language" : "lang"
        ]
        let params : [String : Any]  = [
            "username" : userName,
            "password" : password,
            "email" : email
        ]
        
        LHubRequestService.shared.requestNoToken(.post, RequestItemsType.register.urlString, RequestItemsType.register.encoding, .form, header, params) { (response, result) in
            
//            let model: LHubListCourseModel = LHubListCourseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubListCourseModel()
//            callback(model)
        }
    }
    
    static func getUsername(_ callback: @escaping (String)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getUsername.urlString, RequestItemsType.getUsername.encoding, .json, nil, nil) { (response, result) in
        
            callback(JSON(result ?? [:]).dictionaryValue["username"]?.stringValue ?? "")
        }
    }
}

@objcMembers
class LoginModel: NSObject, YYModel {
    var access_token: String = ""
    var expires_in: Int = 0
    var refresh_token: String = ""
    var scope: String = ""
    var token_type: String = ""
}

