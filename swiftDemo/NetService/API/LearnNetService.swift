//
//  LearnNetService.swift
//  LhubIOS
//
//  Created by NTUCLHUB on 3/3/21.
//  Copyright © 2021 LangFZ. All rights reserved.
//

import Foundation
import YYModel
import SwiftyJSON
import Alamofire

class LearnNetService {
    
    static func postLearnOnGoingCourse(_ callback: @escaping (LHubListCourseModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.postLearnOnGoingCourse.urlString, RequestItemsType.postLearnOnGoingCourse.encoding, .json, nil, nil) { (response, result) in

            let model: LHubListCourseModel = LHubListCourseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubListCourseModel()
            callback(model)
        }
    }
    
    static func postLearnCompleteCourse(_ callback: @escaping (LHubListCourseModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.postLearnCompleteCourse.urlString, RequestItemsType.postLearnCompleteCourse.encoding, .json, nil, nil) { (response, result) in

            let model: LHubListCourseModel = LHubListCourseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubListCourseModel()
            callback(model)
        }
    }
    
    static func postLearnSearchCourse(_ courseName: String, _ callback: @escaping (LHubListCourseModel)->()) {
        
        let courseID_utf8 = courseName.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.postLearnSearchCourse.urlString+courseID_utf8, RequestItemsType.postLearnSearchCourse.encoding, .json, nil, nil) { (response, result) in

            let model: LHubListCourseModel = LHubListCourseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubListCourseModel()
            callback(model)
        }
    }
    
    static func getLearnPackages(_ callback: @escaping (LHubLearnGoPackageModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getLearnPackages.urlString, RequestItemsType.getLearnPackages.encoding, .json, nil, nil) { (response, result) in
            print("Nghia getLearnPackages /api/packages/mypackages/")
            print(JSON(result))
            let model: LHubLearnGoPackageModel = LHubLearnGoPackageModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubLearnGoPackageModel()
            callback(model)
        }
    }
    
    static func postLearnCompanyPackages(_ callback: @escaping (LHubLearnGoPackageModel)->()) {
        
        let param = [
            "code"  :   LHubCurrentDelegate.companyCode
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postLearnPackagesCompany.urlString, RequestItemsType.postLearnPackagesCompany.encoding, .json, nil, param) { (response, result) in

            let model: LHubLearnGoPackageModel = LHubLearnGoPackageModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubLearnGoPackageModel()
            callback(model)
        }
    }
    
    static func getLearnBundle(_ callback: @escaping (LHubBundleListModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getLearnBundle.urlString, RequestItemsType.getLearnBundle.encoding, .json, nil, nil) { (response, result) in

            let model: LHubBundleListModel = LHubBundleListModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubBundleListModel()
            callback(model)
        }
    }
    
    static func getEntrollCourses(_ callback: @escaping (LHubListCourseModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getEntrollCourses.urlString, RequestItemsType.getEntrollCourses.encoding, .json, nil, nil) { (response, result) in

            let model: LHubListCourseModel = LHubListCourseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubListCourseModel()
            callback(model)
        }
    }
    
    static func getCourseSession(_ callback: @escaping (_ sessionID:String)->()) {
        
        var sessionID = ""
        
        let params: [String : Any] = [
            "email" : LHubCurrentDelegate.email,
            "password" : LHubCurrentDelegate.password
        ]
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getLoginSession.urlString, RequestItemsType.getLoginSession.encoding, .json, params, nil) { (getResponse, getResult) in

            let cookie: String = JSON(getResponse?.allHeaderFields ?? [:]).dictionaryObject?["Set-Cookie"] as? String ?? ""
            
            var csrfToken = ""
            let cookieArr: [String] = cookie.components(separatedBy: ";")

            for str in cookieArr {
                if str.contains("sessionid") {
                    sessionID = str.components(separatedBy: "=").last ?? ""
                } else if str.contains("csrftoken") {
                    csrfToken = str.components(separatedBy: "=").last ?? ""
                }
            }
            
            let postHeader: [String : Any] = [
                "X-CSRFToken" : "\(csrfToken)",
                "Cookie" : "csrftoken=\(csrfToken); sessionid=\(sessionID)"
            ]
            
            if LHubCurrentDelegate.currentLoginType == .Company {
                
                LHubRequestService.shared.requestToken(.post, RequestItemsType.postLoginSession.urlString, RequestItemsType.postLoginSession.encoding, .form, postHeader, params) { (postResponse, postResult) in
                    
                    if JSON(postResult ?? [:]).dictionaryObject?["success"] as? Bool ?? false == true {
                        
                        LHubRequestService.shared.requestNoToken(.get, RequestItemsType.getSessionCookie.urlString, RequestItemsType.getSessionCookie.encoding, .json, nil, nil) { (sessionResponse, sessionResult) in
                            
                            let model: SessionIDModel = SessionIDModel.yy_model(with: JSON(sessionResult ?? [:]).dictionaryObject ?? Dictionary()) ?? SessionIDModel()
                            
                            if model.status_code == 200 {
                                callback(model.result?.session_cookie ?? "")
                            }
                        }
                    }
                }
            } else {
                
                LHubRequestService.shared.requestToken(.post, RequestItemsType.postSessionID_LHub.urlString, RequestItemsType.postSessionID_LHub.encoding, .form, postHeader, params) { postResponse, postResult in
                    
                    if JSON(postResult ?? [:]).dictionaryObject?["success"] as? Bool ?? false == true {
                        
                        LHubRequestService.shared.requestNoToken(.get, RequestItemsType.getSessionCookie.urlString, RequestItemsType.getSessionCookie.encoding, .json, nil, nil) { (sessionResponse, sessionResult) in
                            
                            let model: SessionIDModel = SessionIDModel.yy_model(with: JSON(sessionResult ?? [:]).dictionaryObject ?? Dictionary()) ?? SessionIDModel()
                            
                            if model.status_code == 200 {
                                callback(model.result?.session_cookie ?? "")
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func getNoteList(_ courseID: String, _ callback: @escaping (LHubNoteListModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getMyNotes.urlString + (courseID.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "") + "/", RequestItemsType.getMyNotes.encoding, .form, nil, nil) { (response, result) in
            
            let model: LHubNoteListModel = LHubNoteListModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubNoteListModel()
            callback(model)
        }
    }
    
    static func getPublicNoteList(_ courseID: String, _ callback: @escaping (LHubNoteListModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getPeerNotes.urlString + (courseID.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "") + "/", RequestItemsType.getPeerNotes.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubNoteListModel = LHubNoteListModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubNoteListModel()
            callback(model)
        }
    }
    
    static func postCreateNote(_ courseID: String, _ title: String, _ description: String, _ is_public: Bool, _ callback: @escaping (LHubNoteListModel)->()) {
       
        let params : [String: AnyObject] = [
            "course_id" : courseID,
            "title" : title,
            "description" : description,
            "is_public" : is_public
        ] as [String : AnyObject]
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(PersistentData.sharedInstance.getAuthToken() ?? "")",
            "Content-Type": "multipart/form-data"
        ]
        
        let data = UIImage(named: "asset_edit_notes")?.jpegData(compressionQuality: 1.0) ?? Data()
        
        Alamofire.upload(multipartFormData: { multi in
            
            for (key, value) in params {
                multi.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            multi.append(data, withName: "image1", fileName: "imagename.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image2", fileName: "imagename.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image3", fileName: "imagename.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image4", fileName: "imagename.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image5", fileName: "imagename.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image6", fileName: "imagename.jpg", mimeType: "image/jpeg")
            
        }, to: RequestItemsType.postNote.urlString, headers: headers) { result in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    let model: LHubNoteListModel = LHubNoteListModel.yy_model(with: JSON(response.data ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubNoteListModel()
                    callback(model)
                }
            case .failure( _):
                print("failure")
            }
        }
    }
    
    static func putUpdateNote(_ courseID: String, _ title: String, _ description: String, _ is_public: Bool, _ noteID: String, _ callback: @escaping (LHubNoteListModel)->()) {
        
        let params : [String: AnyObject] = [
            "course_id" : courseID,
            "title" : title,
            "description" : description,
            "is_public" : is_public
        ] as [String : AnyObject]
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(PersistentData.sharedInstance.getAuthToken() ?? "")",
            "Content-Type": "multipart/form-data"
        ]
        
        let data = UIImage(named: "asset_edit_notes")?.jpegData(compressionQuality: 1.0) ?? Data()

        Alamofire.upload(multipartFormData: { multi in
            
            for (key, value) in params {
                multi.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            multi.append(data, withName: "image1", fileName: "image.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image2", fileName: "image.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image3", fileName: "image.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image4", fileName: "image.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image5", fileName: "image.jpg", mimeType: "image/jpeg")
            multi.append(data, withName: "image6", fileName: "image.jpg", mimeType: "image/jpeg")
            
        }, to: RequestItemsType.putUpdateNote.urlString + noteID + "/", method: .put, headers: headers) { result in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    let model: LHubNoteListModel = LHubNoteListModel.yy_model(with: JSON(response.data ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubNoteListModel()
                    callback(model)
                }
            case .failure( _):
                print("failure")
            }
        }
    }
    
    static func deleteNote(_ noteID: String, _ callback: @escaping (LHubNoteListModel)->()) {
        
        LHubRequestService.shared.requestToken(.delete, RequestItemsType.deleteNote.urlString + noteID + "/", RequestItemsType.deleteNote.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubNoteListModel = LHubNoteListModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubNoteListModel()
            callback(model)
        }
    }
    
    static func getCertificatesList(_ username: String, _ callback: @escaping (AchievementTimeLineModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getCertificateList.urlString+username+"/", RequestItemsType.getCertificateList.encoding, .form, nil, nil) { (response, result) in
            
            let model: AchievementTimeLineModel = AchievementTimeLineModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? AchievementTimeLineModel()
            callback(model)
        }
    }
    
    static func getDashboard(_ callback: @escaping (LHubDashboardModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getDashboard.urlString, RequestItemsType.getDashboard.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubDashboardModel = LHubDashboardModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubDashboardModel()
            callback(model)
        }
    }
    
    static func getCourseBlockData(_ courseID: String, _ callback: @escaping (LHubLearnBlocksModel)->()) {
        
        let courseID_utf8 = courseID.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        let params: [String : Any] = [
            "course_id"         :   courseID_utf8,
            "depth"             :   "all",
            "nav_depth"         :   "3",
            "requested_fields"  :   "graded,format,student_view_multi_device,lti_url,block_counts,due,special_exam_info",
            "all_blocks"        :   false,
            "student_view_data" :   "video,discussion",
            "block_counts"      :   "video"
        ]
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getCourseBlock.urlString, RequestItemsType.getCourseBlock.encoding, .json, nil, params) { (response, result) in
            
            let json = JSON(result ?? [:])
            var dic: [String: Any] = [:]
            dic["root"] = json.dictionaryValue["root"]?.stringValue
            var blocks: [[String:Any]] = []
            
            for key in json["result"]["blocks"].dictionaryValue.keys {
                
                var block_dic: [String:Any] = json["result"]["blocks"][key].dictionaryObject ?? [:]
                block_dic["block_key"] = key
                blocks.append(block_dic)
            }
            dic["blocks"] = blocks
            
            let model: LHubLearnBlocksModel = LHubLearnBlocksModel.yy_model(with: JSON(dic).dictionaryObject ?? Dictionary()) ?? LHubLearnBlocksModel()
            model.dealWithModel()
            callback(model)
        }
    }
    
    static func getHandouts(_ courseID: String, _ callback: @escaping (LHubLearnHandoutsModel)->()) {
        
        let courseID_utf8 = courseID.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getHandouts.urlString.replacingOccurrences(of: "{course_id}", with: "\(courseID_utf8)"), RequestItemsType.getHandouts.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubLearnHandoutsModel = LHubLearnHandoutsModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubLearnHandoutsModel()
            callback(model)
        }
    }
    
    static func getJobRecommendations(_ searchName: String, _ callback: @escaping (LHubLearnJobRecommendationsModel)->()) {
        
        let searchName_utf8 = searchName.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        LHubRequestService.shared.requestToken(.get, "https://api.mycareersfuture.gov.sg/v2/jobs?search=\(searchName_utf8)&limit=50&page=0&sortBy=new_posting_date", RequestItemsType.getHandouts.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubLearnJobRecommendationsModel = LHubLearnJobRecommendationsModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubLearnJobRecommendationsModel()
            callback(model)
        }
    }
    
    static func postFeedback(_ courseID: String, _ rating: Int, _ comment: String, _ callback: @escaping (LHubLearnHandoutsModel)->()) {
        
        let params : Parameters = [
            "course_id" : courseID,
            "rating" : "\(rating)",
            "review" : comment
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postReview.urlString, RequestItemsType.postReview.encoding, .form, nil, params) { (response, result) in
            
            print(JSON(result ?? [:]))
            let model: LHubLearnHandoutsModel = LHubLearnHandoutsModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubLearnHandoutsModel()
            callback(model)
        }
    }
}

@objcMembers
class SessionIDModel: LHubBaseModel, YYModel {
    
    var result: SessionIDModel?
    var session_cookie: String = ""
}

