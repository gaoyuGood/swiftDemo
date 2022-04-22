//
//  RequestItems.swift
//
//
//  Created by *** on 12/5/19.
//  Copyright © 2019 ***. All rights reserved.
//

import UIKit
import Alamofire


struct APIURL  {
    
    static var _Base_Weather_Url: String = "https://www.tianqiapi.com"
    
    static let _API_GET_Current_Weather_Url = "/free/day"
}

protocol EndPointType {
    
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    
    func getUrl(_ type: RequestBaseType) -> URL
    func getUrlString(_ type: RequestBaseType) -> String
}

enum RequestBaseType {
    case weather
}

enum RequestItem {
    
    case currentWeather
}

extension RequestItem: EndPointType {
    
    var path: String {
        
        switch  self {
        
        case .currentWeather :
            return APIURL._API_GET_Current_Weather_Url
        }
    }
    
    func getUrl(_ type: RequestBaseType) -> URL {
        
        switch type {
        
        case .weather:
            return URL(string: APIURL._Base_Weather_Url + self.path)!
        
        default:
            return URL(string: APIURL._Base_Weather_Url + self.path)!
        }
    }
    
    func getUrlString(_ type: RequestBaseType) -> String {
        
        switch type {
        
        case .weather:
            return APIURL._Base_Weather_Url + self.path
        
        default:
            return APIURL._Base_Weather_Url + self.path
        }
    }
    
    var httpMethod: HTTPMethod {
        
        switch self  {
            
//        case .currentWeather
//        :
//            return .post
            
        case .currentWeather
        :
           return .get
            
//        case .currentWeather
//        :
//            return .patch
//
//        case .currentWeather
//        :
//            return .delete
//
//        case .currentWeather:
//            return .put
        }
    }
    
    var encoding: ParameterEncoding {
        
        switch self {
        
//        case .currentWeather
//             :
//            return URLEncoding.httpBody
//
//        case .currentWeather
//            :
//            return URLEncoding.queryString
            
        default:
            return JSONEncoding.default
        
        }
    }
}

