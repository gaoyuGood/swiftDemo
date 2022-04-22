//
//  CourseNetService.swift
//  LhubIOS
//
//  Created by digital-team on 16/11/21.
//  Copyright © 2021 LangFZ. All rights reserved.
//

import UIKit
import YYModel
import SwiftyJSON

class CourseNetService {

    static func postGoCourseDetail(_ goID: String, _ callback: @escaping (LHubCourseDetailModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.postGoCourseDetail.urlString+goID+"/", RequestItemsType.postGoCourseDetail.encoding, .json, nil, nil) { (response, result) in
            
            print(JSON(result))
            let model: LHubCourseDetailModel = LHubCourseDetailModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubCourseDetailModel()
            callback(model)
        }
    }
    
    static func getGoPackageCoursesEregUrl(_ callback: @escaping (LHubCourseDetailModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getGoPackageCoursesEregUrl.urlString, RequestItemsType.getGoPackageCoursesEregUrl.encoding, .json, nil, nil) { response, result in
            
            let model: LHubCourseDetailModel = LHubCourseDetailModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubCourseDetailModel()
            callback(model)
        }
    }
}


