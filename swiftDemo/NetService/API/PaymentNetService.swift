//
//  PaymentNetService.swift
//  LhubIOS
//
//  Created by NTUCLHUB on 2/3/21.
//  Copyright © 2021 LangFZ. All rights reserved.
//

import UIKit
import YYModel
import SwiftyJSON
import Stripe
import Alamofire

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        
        LHubCurrentDelegate.currentNavigationPushToPayment { (ephemeralKey) in
            
            completion(ephemeralKey, nil)
        }
        /*
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "api_version", value: apiVersion)]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                completion(nil, error)
                return
            }
            completion(json, nil)
        })
        task.resume()*/
    }
}


class PaymentNetService {
    
    // MARK: Add To Shopping Cart
    static func postAddToShoppingCart(_ sku: String, _ callback: @escaping(LHubBaseModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postAddCartItem.urlString, RequestItemsType.postAddCartItem.encoding, .json, nil, ["products":[["sku":sku]]]) { (response, result) in
            
            let model: LHubBaseModel = LHubBaseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubBaseModel()

//              "result" : {
//                "id" : 18,
//                "results" : null,
//                "payment_data" : null,
//                "pagination" : null,
//                "order" : null
//              }
            callback(model)
        }
    }
    
    // MARK: RequestItemsType.postDeleteCartItem
    static func postDeleteCartItem(_ course_id: String, _ callback: @escaping(LHubBaseModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postDeleteCartItem.urlString, RequestItemsType.postDeleteCartItem.encoding, .form, nil, ["course_id":course_id]) { (response, result) in
            
            let model: LHubBaseModel = LHubBaseModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubBaseModel()
            callback(model)
        }
    }
    
    // MARK: Get Shopping Cart Content
    static func getShoppingCartContent(_ callback: @escaping(LHubShoppingCartModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getShoppingCartContent.urlString, RequestItemsType.getShoppingCartContent.encoding, .json, nil, nil) { (response, result) in
            
            let model: LHubShoppingCartModel = LHubShoppingCartModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? LHubShoppingCartModel()
            callback(model)
        }
    }
    
    // MARK: Post BuyNow
    static func postBuyNow(_ skuArr: [String], _ callback: @escaping(PaymentBuyNowModel) -> ()) {
        
        let skus = skuArr.reduce([]) { (result:[[String : String]], next: String) -> [[String : String]] in
            var tempArr = result
            tempArr.append(["sku" : next])
            return tempArr
        }
        let param: [String:Any] = ["products" : skus]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postBuyNow.urlString, RequestItemsType.postBuyNow.encoding, .json, nil, param) { (response, result) in
            
            let model: PaymentBuyNowModel = PaymentBuyNowModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? PaymentBuyNowModel()
            callback(model)
        }
    }
    
    // MARK: Post CustomerID
    static func postCustomerID(_ callback: @escaping(PaymentVerifyModel) -> ()) {
        // /api/stripe/get_customer_id/
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postCustomerID.urlString, RequestItemsType.postCustomerID.encoding, .json, nil, nil) { (response, result) in
            
            let model: PaymentVerifyModel = PaymentVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? PaymentVerifyModel()
            callback(model)
        }
    }
    
    // MARK: Get EphemeralKey
    static func getEphemeralKey(_ customer_id: String, _ callback: @escaping([String:Any]) -> ()) {
                
        let header = ["stripe_customer_id" : customer_id]
        
        LHubRequestService.shared.requestToken(.get, RequestItemsType.getEphemeralKeys.urlString, RequestItemsType.getEphemeralKeys.encoding, .form, nil, header) { (response, result) in
            
//            let model: PaymentVerifyModel = PaymentVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? PaymentVerifyModel()
            
            callback(JSON(result ?? [:]).dictionaryObject ?? [:])
        }
    }
    
    static func postCheckoutPaymentIntent(_ callback: @escaping(PaymentVerifyModel) -> ()) {
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postCheckoutPaymentIntent.urlString, RequestItemsType.postCheckoutPaymentIntent.encoding, .json, nil, nil) { (response, result) in
            
            let model: PaymentVerifyModel = PaymentVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? PaymentVerifyModel()
            callback(model)
        }
    }
    
    static func postConfirmPaymentIntent(_ id: String, _ callback: @escaping(PaymentVerifyModel) -> ()) {
        
        let param = [
            "id" : id
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postConfirmPaymentIntent.urlString, RequestItemsType.postConfirmPaymentIntent.encoding, .form, nil, param) { (response, result) in
            
            let model: PaymentVerifyModel = PaymentVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? PaymentVerifyModel()
            callback(model)
        }
    }
    
    static func postVoucher(_ code: String, _ callback: @escaping(PaymentAddVoucherModel) -> ()) {
        
        let param = [
            "voucher" : code
        ]

        LHubRequestService.shared.requestToken(.post, RequestItemsType.postAddVoucher.urlString, RequestItemsType.postAddVoucher.encoding, .form, nil, param) { (response, result) in

            let model: PaymentAddVoucherModel = PaymentAddVoucherModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? PaymentAddVoucherModel()
            callback(model)
        }
    }
    
    static func postCancelVoucher(_ code: String, _ callback: @escaping(PaymentAddVoucherModel) -> ()) {
        
        let param = [
            "code" : code
        ]

        LHubRequestService.shared.requestToken(.post, RequestItemsType.postCancelVoucher.urlString, RequestItemsType.postCancelVoucher.encoding, .form, nil, param) { (response, result) in

            let model: PaymentAddVoucherModel = PaymentAddVoucherModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? PaymentAddVoucherModel()
            callback(model)
        }
    }
    
    static func postBundleSubscription(_ customerID: String, _ priceID: String, _ callback: @escaping(PaymentVerifyModel) -> ()) {
        
        let param = [
            "stripe_customer_id"    :   customerID,
            "price_id"              :   priceID
        ]

        LHubRequestService.shared.requestToken(.post, RequestItemsType.postBundleSubscription.urlString, RequestItemsType.postBundleSubscription.encoding, .form, nil, param) { (response, result) in

            let model: PaymentVerifyModel = PaymentVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? PaymentVerifyModel()
            callback(model)
        }
    }
    
    static func postConfirmBundlePaymentIntent(_ id: String, _ callback: @escaping(PaymentVerifyModel) -> ()) {
        
        let param = [
            "payment_intent_id" : id
        ]
        
        LHubRequestService.shared.requestToken(.post, RequestItemsType.postBundleConfirmPaymentIntent.urlString, RequestItemsType.postBundleConfirmPaymentIntent.encoding, .json, nil, param) { (response, result) in
            
            let model: PaymentVerifyModel = PaymentVerifyModel.yy_model(with: JSON(result ?? [:]).dictionaryObject ?? Dictionary()) ?? PaymentVerifyModel()
            callback(model)
        }
    }
}

@objcMembers
class PaymentVerifyModel: LHubBaseModel, YYModel {

    /* EphemeralKey */
    var associated_objects: [PaymentVerifyModel] = []
    var object: String = ""
    var id: String = ""
    var secret: String = ""
    var livemode: Bool = false
    var created: Double = 0.0
    var expires: Double = 0.0
    
    /* associated_objects */
    var type: String = ""
    
    
    /* CustomerID */
    var result: PaymentVerifyModel?
    
    var customer_id: String = ""
    
    var client_secret: String = ""
    var currency: String = ""
    var transaction_id: String = ""
    var payment_intent_id: String = ""
    var total_amount: Double = 0.0
    
    /* Confirm Payment Intent */
    var order_number: String = ""
    var total: Int = 0
    var products: [PaymentVerifyModel] = []
    
    /* products */
    var media: PaymentVerifyModel?
    var raw: String = ""
    var small: String = ""
    var large: String = ""
    
    var course_id: String = ""
    var category: String = ""
    var title: String = ""
    var organization: String = ""
    var sku: String = ""
    var code: String = ""
    
    var price: Double = 0.0
    var discounted_price: Double = 0.0
    var discount_applicable: Bool = false
}

@objcMembers
class PaymentBuyNowModel: LHubBaseModel, YYModel {

    var result: PaymentBuyNowModel?
    
    var gst_tax: String = ""
    var total_amount: String = ""
    var currency: String = ""
    var client_secret: String = ""
    var transaction_id: String = ""
    var gst_amount: String = ""
    var subtotal: String = ""
    var total: String = ""
    var sub_total: String = ""
    var basket: Int = 0
    
    /*
     [
        "status_code": 200,
        "result": [
            "sub_total": 100.00,
            "basket": 1489,
            "gst_tax": 7%,
            "total": 107.00,
            "UTAP": [
                "status": 1,
                "error": [
                    "code": ,
                    "details": [],
                    "message":
                ],
            "data": [
                "Eligibility": 1,
                "DateofBirth": 01-01-1978,
                "ApprovedValueDate": 02-09-2021,
                "MembershipType": Union,
                "UTAPMaxClaimAmount": .00,
                "UTAPBalanceFundingAmt": 500.00,
                "Remarks": ,
                "UIN": S3468018C
                ]
            ],
            "gst_amount": 7.00
        ],
        "message": ,
        "status": 1
     ]
     */
}

@objcMembers
class PaymentAddVoucherModel: LHubBaseModel, YYModel {

    var result: PaymentAddVoucherModel?

    var total: String = ""
    var subtotal: Double = 0
    var gst: String = ""
    var discount: String = ""
    
    /*
     [
        "result": [
            "gst": 11.20,
            "results": <null>,
            "discount": -20.00%,
            "total": 171.20,
            "pagination": <null>,
            "subtotal": 200.00
        ],
        "status_code": 200,
        "message": ,
        "status": 1
     ]
     */
}

/*
 {
   "message" : "Payment completed.",
   "status" : true,
   "status_code" : 200,
   "result" : {
     "gst_tax" : "7%",
     "total_amount" : "32.10",
     "currency" : "SGD",
     "client_secret" : "pi_1InJCzCWEv86Pz7XZek5Ebfz_secret_I4hcFWSb1AWU1f2oaq5vcq9cb",
     "transaction_id" : "pi_1InJCzCWEv86Pz7XZek5Ebfz",
     "subtotal" : "30.00",
     "gst_amount" : "2.10"
   }
 }
    {
      "associated_objects" : [
        {
          "id" : "cus_IqAdIbHyQvo8mw",
          "type" : "customer"
        }
      ],
      "expires" : 1615608042,
      "livemode" : false,
      "object" : "ephemeral_key",
      "created" : 1615604442,
      "secret" : "ek_test_YWNjdF8xSUF2S2RDV0V2ODZQejdYLHpoRDBMbFEwTW5IRno0SVp1dlNpb3Vnam8xcmF5Rmc_00X9gWGFkY",
      "id" : "ephkey_1IUNiYCWEv86Pz7XKq07V4r7"
    }
 */
