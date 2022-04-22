//
//  ProfileNetService.swift
//  LhubIOS
//
//  Created by NTUCLHUB on 29/1/21.
//  Copyright © 2021 LangFZ. All rights reserved.
//

import UIKit
import YYModel
import SwiftyJSON
import Alamofire
import Datadog

class ProfileNetService {
    
    
    // MARK: - Token Model
    @objcMembers
    class ProfileTokenModel: NSObject, YYModel {
        
        var access_token: String = ""
        var expires_in: String = ""
        var scope: String = ""
        var token_type: String = ""
    }
    // MARK: - Get JWT Token
    static func getJWTToken(_ callback: @escaping (ProfileTokenModel) -> ()) {
        
        let params: [String : Any] = [
            "grant_type"    :   "client_credentials",
            "token_type"    :   "jwt",
            "client_secret" :   APIURL.jwt_client_secret,
            "client_id"     :   APIURL.jwt_client_id
        ]
        
        LHubRequestService.shared.requestNoToken(.post, RequestItemsType.getJWTToken.urlString, RequestItemsType.getJWTToken.encoding, .form, nil, params) { (response, result) in

            if response?.statusCode == 200 {
                
                let model: ProfileTokenModel = ProfileTokenModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? ProfileTokenModel()
                
                callback(model)
                
            } else {
                
                callback(ProfileTokenModel())
            }
        }
    }
    
    static func getProfileData(_ company: Bool, _ callback: @escaping (LHubProfileInfoDataModel) -> ()) {

        let userName = company ? LHubCurrentDelegate.companyUserName : LHubCurrentDelegate.userName
        let userNamePath = company ? LHubCurrentDelegate.companyUserNamePath : LHubCurrentDelegate.userNamePath
        
        if userName != "" {
            
            LHubRequestService.shared.requestToken(.get, RequestItemsType.getUserProfile.urlString + userNamePath, RequestItemsType.getUserProfile.encoding, .json) { (response, result) in
                print("Nghia getUserProfile /api/user/v2/accounts/ ")
                print(userNamePath)
                print(JSON(result as Any))
                
                let model: LHubProfileInfoDataModel = LHubProfileInfoDataModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileInfoDataModel()
                
                if model.status_code == 200 {
                    LHubCurrentDelegate.profileModel = model
                    
                    Datadog.setUserInfo(id: LHubCurrentDelegate.userName, name: LHubCurrentDelegate.profileModel.result?.name, email: LHubCurrentDelegate.profileModel.result?.email, extraInfo: [:])
                    
                    if model.result?.infinity_status ?? false == false {
                        
                        CourseNetService.getGoPackageCoursesEregUrl { eregModel in
                            LHubCurrentDelegate.ereg_url = eregModel.result?.url ?? ""
                            callback(model)
                        }
                    } else {
                        callback(model)
                    }
                }
            }
        } else {
            
            callback(LHubProfileInfoDataModel())
        }
    }
    
    static func updateProfileData(_ name: String = "", _ birth: String = "", _ gender: String = "", _ interest: [String] = [], _ callback: @escaping (LHubProfileInfoDataModel) -> ()) {
        
        var params : [String: Any] = [:]
        
        if name != "" {
            params["name"] = name
        }
        if birth != "" {
            params["date_of_birth"] = birth
        }
        if gender != "" {
            params["gender"] = gender
        }
        params["interests"] = interest
        
        let userNamePath = LHubCurrentDelegate.currentLoginType == .Company ? (LHubCurrentDelegate.companyUserNamePath) : (LHubCurrentDelegate.userNamePath)
        
        let url = RequestItemsType.patchUserProfile.urlString + userNamePath
        
        LHubRequestService.shared.requestToken(.patch, url, RequestItemsType.patchUserProfile.encoding, .patch, nil, params) { (response, result) in
            
            let model: LHubProfileInfoDataModel = LHubProfileInfoDataModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileInfoDataModel()
            
//            if model.status_code == 200 {
//                LHubCurrentDelegate.profileModel = model
//            }
            callback(model)
        }
    }
    
    static func postCompanyResetPassword(_ email: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        let param = [
            "email" :   email
        ]
        
        let header = [
            "charset"   :   "UTF-8"
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postCompanyResetPassword.urlString, RequestItemsType.postCompanyResetPassword.encoding, .form, header, param) { response, result in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func postCompanyResetPasswordNonLogin(_ email: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        let param = [
            "email" :   email
        ]
        
        let header = [
            "charset"   :   "UTF-8"
        ]
        
        LHubCurrentDelegate.refreshJWTToken { success in
            LHubRequestService.shared.requestToken(.post, RequestItemsType.postCompanyResetPasswordNonLogin.urlString, RequestItemsType.postCompanyResetPasswordNonLogin.encoding, .form, header, param) { response, result in
                let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
                callback(model)
            }
        }
    }
    
    static func postProfileAvatar(_ image: UIImage, _ callback: @escaping (Bool) -> ()) {
        
        let header = [
            "Authorization" : "Bearer \(LHubCurrentDelegate.profileInfo.BearerToken)",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
            
        let url = RequestItemsType.postUserAvatar
        let urlString = url.urlString.replacingOccurrences(of: "{username}", with: LHubCurrentDelegate.userName)
        print(urlString)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let mydata = Data(base64Encoded: image.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? "") {
                multipartFormData.append(mydata, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: urlString as String, method: .post, headers: header) { (EncodingResult) in
            
            switch EncodingResult {
            case .success(_, _, _):
                callback(true)
            case .failure( _):
                callback(false)
            }
        }
    }
    
    // MARK: - FAQ - Get Category & Top 10 Questions
    static func getFaqCategoryTopTenQuesetions(_ callback: @escaping (FAQCategoriesTopTenQuestionsModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getFaqCategoryTop.urlString, RequestItemsType.getFaqCategoryTop.encoding, .json) { (response, result) in

            let model: FAQCategoriesTopTenQuestionsModel = FAQCategoriesTopTenQuestionsModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? FAQCategoriesTopTenQuestionsModel()
            model.result?.top.last?.isLast = true
            model.result?.categories.last?.isLast = true
            callback(model)
        }
    }
    
    // MARK: - FAQ - Get Questions from Category
    static func getQuestionsOfCategory(_ categoryId: String, _ callback: @escaping (FAQQuestionsOfCategoryModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getQuestionsOfCategory.urlString.replacingOccurrences(of: "{category_id}", with: categoryId), RequestItemsType.getQuestionsOfCategory.encoding, .json, nil, nil) { (response, result) in
            
            let model: FAQQuestionsOfCategoryModel = FAQQuestionsOfCategoryModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? FAQQuestionsOfCategoryModel()
            model.result.last?.isLast = true
            callback(model)
        }
    }
    
    // MARK: - FAQ - Get Answer HTML
    static func getFAQDetail(_ questionId: String, _ callback: @escaping(FAQQuestionDetailModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getQuestionDetail.urlString.replacingOccurrences(of: "{id}", with: questionId), RequestItemsType.getQuestionDetail.encoding, .json) { (response, result) in
            
            let model: FAQQuestionDetailModel = FAQQuestionDetailModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? FAQQuestionDetailModel()
            callback(model)
        }
    }
    
    // MARK: - Interest
    static func getInterestData(_ callback: @escaping (LHubProfileInterestModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getInterestData.urlString, RequestItemsType.getInterestData.encoding, .json, nil, nil) { response, result in
            
            let model: LHubProfileInterestModel = LHubProfileInterestModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileInterestModel()
            callback(model)
        }
    }
    
    static func getUserInterest(_ callback: @escaping (LHubProfileInterestModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getUserInterest.urlString, RequestItemsType.getUserInterest.encoding, .json, nil, nil) { response, result in
            
            let model: LHubProfileInterestModel = LHubProfileInterestModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileInterestModel()
            callback(model)
        }
    }
    
    static func patchUserInterest(_ interest: [Int], _ callback: @escaping (LHubProfileInfoDataModel) -> ()) {
        
        let params: [String : Any] = [
            "interests"    :   interest
        ]
        
        let userNamePath = LHubCurrentDelegate.currentLoginType == .Company ? (LHubCurrentDelegate.companyUserNamePath) : (LHubCurrentDelegate.userNamePath)
        
        LHubRequestService.shared.requestToken(.patch, RequestItemsType.patchUserInterest.urlString + userNamePath, RequestItemsType.patchUserInterest.encoding, .patch, nil, params) { response, result in
            
            let model: LHubProfileInfoDataModel = LHubProfileInfoDataModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileInfoDataModel()
            
            if model.status_code == 200 {
                LHubCurrentDelegate.profileModel = model
            }
            callback(model)
        }
    }
    
    // MARK: - NESSO Association
    static func getTokenFromNESSO(_ accessToken: String, _ callback: @escaping (String) -> ()) {
        
        let param = [
            "access_token"  :   accessToken
        ]
        
        LHubRequestService.shared.requestNoToken(.post, RequestItemsType.postNESSOAssociation.urlString, RequestItemsType.postNESSOAssociation.encoding, .json, nil, param) { response, result in
            
            if JSON(result ?? [:])["success"].boolValue == true {
                callback(JSON(result ?? [:])["lms_token"].stringValue)
            } else {
                callback("")
            }
        }
    }
    
    static func getCompanyCodeVerify(_ companyCode: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        LHubRequestService.shared.requestNoToken(.get, RequestItemsType.getCompanyCodeVerify.urlString+"?enterprise_slug="+companyCode, RequestItemsType.getCompanyCodeVerify.encoding, .json, nil, nil) { response, result in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func postCompanyLogin(_ companyCode: String, _ email: String, _ password: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        let param = [
//            "username"      :   "shopeelearner01",
            "company_code"  :   companyCode,
            "email"         :   email,
            "password"      :   password,
            "client_id"     :   APIURL.client_id,
            "grant_type"    :   "password",
            "token_type"    :   "Bearer"
        ]

        LHubRequestService.shared.requestNoToken(.post, RequestItemsType.postCompanyLogin.urlString, RequestItemsType.postCompanyLogin.encoding, .form, nil, param) { response, result in
            
            print("postCompanyLogin")
            print(RequestItemsType.postCompanyLogin.urlString)
            print(param)
            print(JSON(result))
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func postCompanyLoginTriggerEmail(_ companyCode: String, _ email: String, _ password: String, _ username: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        let param = [
            "company_code"  :   companyCode,
            "username"      :   username,
            "email"         :   email,
            "password"      :   password,
            "client_id"     :   APIURL.client_id,
            "grant_type"    :   "password",
            "token_type"    :   "Bearer"
        ]
        
        LHubRequestService.shared.requestNoToken(.post, RequestItemsType.postOTPTriggerEmail.urlString, RequestItemsType.postOTPTriggerEmail.encoding, .json, nil, param) { response, result in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func getCompanyLoginOTPVerify(_ companyCode: String, _ email: String, _ password: String, _ username: String, _ otp: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        let param = [
            "company_code"  :   companyCode,
            "username"      :   username,
            "email"         :   email,
            "password"      :   password,
            "client_id"     :   APIURL.client_id,
            "grant_type"    :   "password",
            "token_type"    :   "Bearer",
            "otp"           :   otp
        ]
        
        LHubRequestService.shared.requestNoToken(.post, RequestItemsType.postOTPVerify.urlString, RequestItemsType.postOTPVerify.encoding, .json, nil, param) { response, result in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    /* Company SecondEmail OTP */
    
    static func getCompanyAddSecondEmail(_ email: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        let param = [
            "email"             :   LHubCurrentDelegate.profileModel.result?.email ?? "",
            "secondary_email"   :   email
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postSecondEmailGenerate.urlString, RequestItemsType.postSecondEmailGenerate.encoding, .json, nil, param) { response, result in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func postSecondEmailResendOTP(_ email: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        let param = [
            "email"             :   LHubCurrentDelegate.profileModel.result?.email ?? "",
            "secondary_email"   :   email
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postSecondEmailResendOTP.urlString, RequestItemsType.postSecondEmailResendOTP.encoding, .json, nil, param) { response, result in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func postSecondEmailResendOTPVerify(_ email: String, _ code: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        let param = [
            "email"             :   LHubCurrentDelegate.profileModel.result?.email ?? "",
            "secondary_email"   :   email,
            "code"              :   code
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postSecondEmailResendOTPVerify.urlString, RequestItemsType.postSecondEmailResendOTPVerify.encoding, .json, nil, param) { response, result in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func getCompanyRefreshToken(_ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        let param = [
            "company_code"  :   LHubCurrentDelegate.companyCode,
            "username"      :   LHubCurrentDelegate.companyUserName != "" ? LHubCurrentDelegate.companyUserName : LHubCurrentDelegate.userName,
            "email"         :   LHubCurrentDelegate.email,
            "password"      :   LHubCurrentDelegate.password,
            "client_id"     :   APIURL.client_id,
            "grant_type"    :   "password",
            "token_type"    :   "Bearer"
        ]
        
        LHubRequestService.shared.requestNoToken(.post, RequestItemsType.postOTPRefreshToken.urlString, RequestItemsType.postOTPRefreshToken.encoding, .json, nil, param) { response, result in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func getMyInfo(_ code: String, _ state: String, _ callback: @escaping (LHubProfileMyInfoModel) -> ()) {
        
        let url = RequestItemsType.getMyInfo.urlString.replacingOccurrences(of: "{code_id}", with: code).replacingOccurrences(of: "{state_id}", with: state)
        
        LHubRequestService.shared.requestToken(.get, url, RequestItemsType.getMyInfo.encoding, .json) { response, result in
            
            LHubCurrentDelegate.myInfoUpdateData = JSON(result ?? [:])["result"]["results"].dictionaryObject ?? Dictionary()
            
            let model: LHubProfileMyInfoModel = LHubProfileMyInfoModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileMyInfoModel()
            callback(model)
        }
    }
    
    static func postMyInfoRetrieve(_ customer_id: String, _ callback: @escaping (LHubProfileVerifyModel) -> ()) {
        
        var dataValue = ""
        
        do {
            let dataJson = try JSONSerialization.data(withJSONObject: LHubCurrentDelegate.myInfoUpdateData, options: .prettyPrinted)
            dataValue = String(data: dataJson, encoding: .utf8) ?? ""
        } catch {
            dataValue = ""
        }
        
        let param: [String : String] = [
            "data"  :   dataValue,
            "id"    :   customer_id
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postMyInfoRetrieve.urlString, RequestItemsType.postMyInfoRetrieve.encoding, .form, nil, param) { response, result in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func getImproveCategory(_ callback: @escaping (LHubProfileImproveCategoryModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getImproveCategory.urlString, RequestItemsType.getImproveCategory.encoding, .json, nil, nil) { response, result in
            
            let model: LHubProfileImproveCategoryModel = LHubProfileImproveCategoryModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileImproveCategoryModel()
            callback(model)
        }
    }
    
    static func postImproveSubmit(_ category: String, _ title: String, _ message: String, _ email: String, _ callback: @escaping (LHubProfileImproveSubmitVerifyModel) -> ()) {
        
        let param = [
            "category"  :   category,
            "title"     :   title,
            "message"   :   message,
            "email"     :   email
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postImproveSubmit.urlString, RequestItemsType.postImproveSubmit.encoding, .json, nil, param) { response, result in
            
            let model: LHubProfileImproveSubmitVerifyModel = LHubProfileImproveSubmitVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileImproveSubmitVerifyModel()
            callback(model)
        }
    }
    
    static func postContactUsSubmit(_ name: String, _ mobile: String, _ title: String, _ message: String, _ email: String, _ callback: @escaping (LHubProfileImproveSubmitVerifyModel) -> ()) {
        
        let param = [
            "name"      :   name,
            "mobile"    :   mobile,
            "title"     :   title,
            "message"   :   message,
            "email"     :   email
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postContactUsSubmit.urlString, RequestItemsType.postContactUsSubmit.encoding, .json, nil, param) { response, result in
            
            let model: LHubProfileImproveSubmitVerifyModel = LHubProfileImproveSubmitVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileImproveSubmitVerifyModel()
            callback(model)
        }
    }
    
    // MARK: - UTap
    
    static func getUTapMemberShipProfile( _ callback: @escaping (LHubProfileVerifyModel)->()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getUtapMembershipStatus.urlString, RequestItemsType.getUtapMembershipStatus.encoding, .form, nil, nil) { (response, result) in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func getUTapMemberShipEligible(_ orderTotal: String, _ courseID: String, _ callback: @escaping (LHubProfileVerifyModel)->()) {
        
        let courseID_utf8 = courseID.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getUTapMembershipEligible.urlString+"\(courseID_utf8)/?course_price_incl_disc_incl_tax="+orderTotal, RequestItemsType.getUTapMembershipEligible.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func postUTapCreateClaim(_ courseID: String, _ amount: Double, _ callback: @escaping (LHubProfileVerifyModel)->()) {
        
        let courseID_utf8 = courseID.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        let param: [String : Any] = [
            "course_id"         :   courseID_utf8,
            "utap_claim_amount" :   amount
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postUTapCreateClaim.urlString, RequestItemsType.postUTapCreateClaim.encoding, .form, nil, param) { (response, result) in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
    
    static func postUTapRefund(_ ApplicationCode: String, _ callback: @escaping (LHubProfileVerifyModel)->()) {
        
        let param: [String : Any] = [
            "ApplicationCode"   :   ApplicationCode,
            "Reasons"           :   "Withdrawn"
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postUTapRefund.urlString, RequestItemsType.postUTapRefund.encoding, .json, nil, param) { (response, result) in
            
            let model: LHubProfileVerifyModel = LHubProfileVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubProfileVerifyModel()
            callback(model)
        }
    }
}


@objcMembers
class LHubProfileVerifyModel: LHubBaseModel, YYModel {
    /*
    [
        "status": 1,
        "result": [
            "message": utap membership exists,
            "pagination": <null>,
            "status_code": 200,
            "result": [
                "NricValue": S7725803E,
                "utap_membership": [
                    "data": [
                        "UTAPBalanceFundingAmt": 300.0,
                        "MembershipStatusCode": 1,
                        "MembershipType": Union,
                        "MembershipStatusName": ACTIVE,
                        "UnionName": AIR TRANSPORT EXECUTIVE STAFF UNION,
                        "ArrearsAmount": 0,
                        "UIN": S7725803E,
                        "UnionCode": AESU,
                        "ArrearsinMonth": 0,
                        "DateofBirth": 01-01-1977,
                        "JoinUnionDate": 01/07/2021,
                        "BranchCode": GB],
                    "status": 1,
                    "error": ["details": [], "code": , "message": ]
                ],
                "is_utap_membership": 1,
                "NRICExist": 1],
            "results": <null>
        ],
        "status_code": 200,
        "message": ]*/
    
    var success: Bool = false
    var result: LHubProfileVerifyModel?
    
    var enterprise_exists: Bool = false
    var enterprise_logo: String = ""
    var bearer_token: String = ""
    var username: String = ""
    
    var NRICExist: Bool = false
    var is_utap_membership: Bool = false
    var NricValue: String = ""
    
    var utap_membership: LHubProfileVerifyModel?
    var data: LHubProfileVerifyModel?
    
    var UTAPBalanceFundingAmt: Double = 0
    var UTAPMaxClaimAmount: Double = 0
    
    var is_member_eligible: Bool = false
    var balance_amt: Double = 0
    var utap_member: LHubProfileVerifyModel?
    
    var UTAP_response: LHubProfileVerifyModel?
    var ApplicationCode: String = ""
    var transaction_code: String = ""
    
    /* utap_member */
    
    
    /*
     [
        "result": [
            "pagination": <null>,
            "is_member_eligible": 1,
            "status_code": 200,
            "balance_amt": 300.00,
            "utap_member": [
                "data": [
                    "UTAPMaxClaimAmount": .00,
                    "Remarks": ,
                    "DateofBirth": 01-01-1977,
                    "UTAPBalanceFundingAmt": 300.00,
                    "UIN": S7725803E,
                    "Eligibility": 1,
                    "MembershipType": Union
                ],
                "status": 1,
                "error": [
                    "code": ,
                    "message": ,
                    "details": []
                ]
            ],
            "claim_amt": .00,
            "message": success  user is eligible ,
            "results": <null>
        ],
        "status_code": 200,
        "message": ,
        "status": 1
     ]
     */
}

@objcMembers
class LHubProfileMyInfoModel: LHubBaseModel, YYModel {
    
    var result: LHubProfileMyInfoModel?
    var results: LHubProfileMyInfoModel?
    
    var data: LHubProfileMyInfoModel?
    var signature: LHubProfileMyInfoModel?
    
    var uinfin: LHubProfileMyInfoModel?
    var name: LHubProfileMyInfoModel?
    var dob: LHubProfileMyInfoModel?
    
    var lastupdated: String = ""
    var source: String = ""
    var classification: String = "" 
    var value: String = ""
}

@objcMembers
class LHubProfileImproveCategoryModel: LHubBaseModel, YYModel {
    
    var result: [LHubProfileImproveCategoryModel] = []
    
    var id: Int = 0
    var feedback_category: String = ""
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["result" : LHubProfileImproveCategoryModel.self]
    }
}

@objcMembers
class LHubProfileImproveSubmitVerifyModel: LHubBaseModel, YYModel {
    
    var result: String = ""
}

