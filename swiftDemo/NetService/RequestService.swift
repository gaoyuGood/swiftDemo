//
//  RequestService.swift
//  
//
//  Created by *** on 3/2/20.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public enum ContentType: String {
    case none = ""
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
    case patch = "application/merge-patch+json"
    case formData = "multipart/form-data"
}

public enum Method: Int {
    case get        = 1
    case post       = 2
    case delete     = 3
    case put        = 4
    case post_FORM  = 5
    case patch      = 6
}

extension Method {
    
    func getHttpRequestMethod() -> HTTPMethod {
        
        switch self {
        case .get:
            return HTTPMethod.get;
        case .put:
            return HTTPMethod.put;
        case .delete:
            return HTTPMethod.delete;
        case .patch:
            return HTTPMethod.patch;
        default:
            return HTTPMethod.post;
        }
    }
}

class RequestError: Error {
    
    var title =  ""
    var body = ""
    
    init(title : String, body : String) {
        self.title = title
        self.body = body
    }
}


class RequestService: NSObject {

    @objc static let shared: RequestService = RequestService()

    override init() {
        super.init()
    }
    
    // MARK: - Request No Token
    public func requestNoToken(_ method: Method, _ url: String, _ encoding: ParameterEncoding, _ contentType: ContentType, _ extraHeaders: [String:Any]? = nil, _ params: [String:Any]? = nil, _ callback: @escaping (_ response: HTTPURLResponse?, _ result: AnyObject?, _ data: Data?) -> ()) {
        
        let headers = getMethodHeader(contentType, extraHeaders)
        baseRequest(method, url, encoding, headers, params) { (response, result, data) in
            callback(response, result, data)
        }
    }
    
    // MARK: - Headers
    private func getMethodHeader(_ contentType: ContentType, _ extraHeaders: [String:Any]? = nil) -> [String:Any] {
        
        var headers: [String : Any] = [:]
        
        if contentType != .none {
            headers["Content-Type"] = contentType.rawValue
        }
        
        let _ = extraHeaders?.compactMap({ (key, value) in
            headers[key] = value
        })
        
        return headers
    }
}

extension RequestService {
    
    // MARK: - Base Request
    private func baseRequest(_ method: Method,_ url: String,_ encoding: ParameterEncoding, _ headers: [String:Any]? = nil,_ params: [String:Any]? = nil,_ callback: @escaping (_ response: HTTPURLResponse?, _ result: AnyObject?, _ data: Data?) -> ()) {
        
        Alamofire.SessionManager.default.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let request: DataRequest = Alamofire.request(url, method: method.getHttpRequestMethod(), parameters: params, encoding: encoding, headers: headers as? HTTPHeaders)
        
        request.response(queue: nil, responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments)) { (dataResponse) in
            
            if dataResponse.response?.statusCode != 200 {
                
                print("Error URL: \(url)\nerror: \(dataResponse.result.error?.localizedDescription ?? "")")
            }
            
            callback(dataResponse.response, dataResponse.result.value as AnyObject?, dataResponse.data)
        }
    }
}
