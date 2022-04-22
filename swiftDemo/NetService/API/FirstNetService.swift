//
//  FirstNetService.swift
//
//
//  Created by *** on 2/3/21.
//  Copyright © 2021 ***. All rights reserved.
//

import Foundation
import YYModel
import SwiftyJSON

class FirstNetService {
    
    static func getCurrentWeatherCodable(_ callback: @escaping (Swift.Result<CurrentCityWeatherResult, RequestError>)->()) {
        
        let urlParam = "?appid=56761788&appsecret=ti3hP8y9"
        
        RequestService.shared.requestNoToken(.get, RequestItem.currentWeather.getUrlString(.weather)+urlParam, RequestItem.currentWeather.encoding, .json, nil, nil, { response, result, data in
            
            // Codable
            do {
                let model =  try JSONDecoder().decode(CurrentCityWeatherResult.self, from: data!)
                callback(.success(model))
            } catch {
                callback(.failure(RequestError(title: "Url: \(RequestItem.currentWeather.getUrlString(.weather)+urlParam)", body: "")))
            }
        })
    }
    
    static func getCurrentWeatherNSObject(_ callback: @escaping (CurrentCityWeather)->()) {
        
        let urlParam = "?appid=56761788&appsecret=ti3hP8y9"
        
        RequestService.shared.requestNoToken(.get, RequestItem.currentWeather.getUrlString(.weather)+urlParam, RequestItem.currentWeather.encoding, .json, nil, nil, { response, result, data in

            print(JSON(result))
            
            // NSObject
            let model: CurrentCityWeather = CurrentCityWeather.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? CurrentCityWeather()
            callback(model)
        })
    }
}


struct CurrentCityWeatherResult: Codable {
    
    var update_time: String
    var tem_night: String
    var air: String
    var tem: String
    var win_meter: String
    var cityid: String
    var wea_img: String
    var win_speed: String
    var wea: String
    var win: String
    var city: String
    var tem_day: String
}


@objcMembers
class CurrentCityWeather: NSObject, YYModel {
    
    var update_time: String = ""
    var tem_night: String = ""
    var air: String = ""
    var tem: String = ""
    var win_meter: String = ""
    var cityid: String = ""
    var wea_img: String = ""
    var win_speed: String = ""
    var wea: String = ""
    var win: String = ""
    var city: String = ""
    var tem_day: String = ""
}

