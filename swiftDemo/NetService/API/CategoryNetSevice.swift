//
//  CategoryNetSevice.swift
//  LhubIOS
//
//  Created by NTUCLHUB on 3/3/21.
//  Copyright © 2021 LangFZ. All rights reserved.
//

import Foundation
import YYModel
import SwiftyJSON

class CategoryNetService {
    
    static func getSubCategory(_ categoryID: String, _ callback: @escaping (LHubListCourseModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getSubCategory.urlString + categoryID + "&page_size=100", RequestItemsType.getSubCategory.encoding, .json, nil, nil) { (response, result) in
            print("getSubCategory")
            print(RequestItemsType.getSubCategory.urlString + categoryID + "&page_size=100")
            print(JSON(result))
            let model: LHubListCourseModel = LHubListCourseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubListCourseModel()
            callback(model)
        }
    }
    
    static func postEnroll(_ course_ID: String, _ callback: @escaping (LHubListCourseModel)->()) {
        
        let param = [
            "course_details" : [
                "course_id" : course_ID
            ]
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postEnroll.urlString, RequestItemsType.postEnroll.encoding, .json, nil, param) { (response, result) in
            
            let model: LHubListCourseModel = LHubListCourseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubListCourseModel()
            callback(model)
        }
    }
    
    static func getCourseDetail(_ course_ID: String, _ callback: @escaping (LHubCourseDetailModel)->()) {
        
//        let header = [
//            "platform_visibility" : "mobile"
//        ]
        
        let courseID_utf8 = course_ID.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getCourseDetail.urlString + courseID_utf8 + "?platform_visibility=mobile", RequestItemsType.getCourseDetail.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubCourseDetailModel = LHubCourseDetailModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubCourseDetailModel()
            callback(model)
        }
    }
    
    static func getCourseDetailBundle(_ course_ID: String, _ callback: @escaping (LHubBundleListModel)->()) {
        
        let courseID_utf8 = course_ID.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getCourseDetailBundleList.urlString.replacingOccurrences(of: "{course_id}", with: "\(courseID_utf8)"), RequestItemsType.getCourseDetailBundleList.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubBundleListModel = LHubBundleListModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubBundleListModel()
            callback(model)
        }
    }
    
    static func getBundleDetailCourses(_ bundle_ID: String, _ callback: @escaping (LHubBundleListModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getBundleDetailCourses.urlString.replacingOccurrences(of: "{ID}", with: bundle_ID), RequestItemsType.getBundleDetailCourses.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubBundleListModel = LHubBundleListModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubBundleListModel()
            callback(model)
        }
    }
    
    static func getCourseFeedback(_ course_ID: String, _ callback: @escaping (LHubCourseFeedbackModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getReviews.urlString + course_ID, RequestItemsType.getReviews.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubCourseFeedbackModel = LHubCourseFeedbackModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubCourseFeedbackModel()
            callback(model)
        }
    }
    
    static func getCourseFromSearch(_ source: LHubCourseListApiSource, _ searchName: String, _ filter: [String : String], _ courseID: String = "", _ callback: @escaping (LHubListCourseModel)->()) {
        
        var filters = ""
        filter.forEach { (key, value) in
            filters += "&\(key)=\(value)"
        }
        
        var url = ""
        if source == .tms {
            url = RequestItemsType.getTmsCourseSearch.urlString
        } else if source == .tag {
            let searchName_utf8 = searchName.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
            url = RequestItemsType.getCourseDetail.urlString + "all/?\(source.rawValue)=\(searchName_utf8)"
        } else if source == .subcategory{
            url = RequestItemsType.getFreeCourse.urlString + "?platform_visibility=mobile&subcategory_id=\(courseID)&page=1&page_size=10"
        } else {
            if courseID != "" {
                url = RequestItemsType.getCourseDetail.urlString + "?platform_visibility=mobile&subcategory_id=\(courseID)" + filters
            } else {
                if LHubCurrentDelegate.currentLoginType == .Company {
                    url = RequestItemsType.getCoursesListCompany.urlString + "\(searchName.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")"
                } else {
                    url = RequestItemsType.getCourseDetail.urlString + source.rawValue + "?coursename=\(searchName.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")" + filters
                }
            }
        }
        
        LHubRequestService.shared.requestToken(.get, url, RequestItemsType.getCourseDetail.encoding, .json, nil, nil) { (response, result) in
            
            print("getCourseFromSearch")
            print(url)
            print(JSON(result))
            
            let model: LHubListCourseModel = LHubListCourseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubListCourseModel()
            
            if source == .tms {
                
                let resultModel = LHubListCourseModel()
                resultModel.result = model
                resultModel.pagination = model.pagination
                callback(resultModel)
                
            } else {
                
                callback(model)
            }
        }
    }
    
    static func getFreeCourse(_ page: Int = 1, _ size: Int = 10, _ callback: @escaping (LHubListCourseModel)->()) {
        
        let url = RequestItemsType.getFreeCourse.urlString + "?platform_visibility=mobile&sale_type=free&page=\(page)&page_size=\(size)"
        print(url)
        LHubRequestService.shared.requestToken(.get, url, RequestItemsType.getFreeCourse.encoding, .json, nil, nil) { (response, result) in
            print("getFreeCourse")
            print(JSON(result))
            let model: LHubListCourseModel = LHubListCourseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubListCourseModel()
            callback(model)
        }
    }
    
    static func getTopSearch(_ callback: @escaping (LHubCategoryTopSearchModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getTopSearch.urlString, RequestItemsType.getTopSearch.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubCategoryTopSearchModel = LHubCategoryTopSearchModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubCategoryTopSearchModel()
            callback(model)
        }
    }
}

@objcMembers
class LHubCategoryTopSearchModel: LHubBaseModel, YYModel {
    
    var result: LHubCategoryTopSearchModel?
    
    var results: [LHubCategoryTopSearchModel] = []
    
    var key_word: String = ""
    var hits: Int = 0
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["results" : LHubCategoryTopSearchModel.self]
    }
    
    public func initModel() {
        
        let result: LHubCategoryTopSearchModel = LHubCategoryTopSearchModel()
        var results: [LHubCategoryTopSearchModel] = []
        
        let model1 = LHubCategoryTopSearchModel()
        model1.key_word = "Python"
        let model2 = LHubCategoryTopSearchModel()
        model2.key_word = "Java"
        let model3 = LHubCategoryTopSearchModel()
        model3.key_word = "JavaScript"
        let model4 = LHubCategoryTopSearchModel()
        model4.key_word = "Unity"
        let model5 = LHubCategoryTopSearchModel()
        model5.key_word = "React"
        let model6 = LHubCategoryTopSearchModel()
        model6.key_word = "Excel"
        let model7 = LHubCategoryTopSearchModel()
        model7.key_word = "Wordpress"
        let model8 = LHubCategoryTopSearchModel()
        model8.key_word = "Php"
        
        results.append(model1)
        results.append(model2)
        results.append(model3)
        results.append(model4)
        results.append(model5)
        results.append(model6)
        results.append(model7)
        results.append(model8)
        
        result.results = results
        self.result = result
    }
}

enum LHubCourseListApiSource: String {
    case none = ""
    case all = "all/"
    case tms = "tms/"
    case goal = "Goal"
    case tag = "course_tag_name"
    case free = "free"
    case subcategory = "subcategory"
    case lhubgo = "lhubgo"
}

