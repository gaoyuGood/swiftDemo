//
//  PersistentData.swift
//  MindMapNew
//
//  Created by Jobelle Vallega on 7/10/20.
//  Copyright © 2020 Jobelle Vallega. All rights reserved.
//

import UIKit

enum PersistentKeys : String {
   
    case Auth
    case JWTAuth
    case UserName
    case companyUserName
    case MainCat
    case Sort
    case Filters
    case SubCat
    case CartBadgeNumber
    case CSRF
    case sessionID
}

class PersistentData: NSObject {
     static let sharedInstance  = PersistentData()
    
    //Setters
    func setFilters (_ value : [String]) {
        UserDefaults.standard.setValue(value, forKeyPath: PersistentKeys.Filters.rawValue)
    }
    
    func setCSRF (_ value : String) {
        UserDefaults.standard.setValue(value, forKeyPath: PersistentKeys.CSRF.rawValue)
    }
    
    func setSessionID (_ value : String) {
        UserDefaults.standard.setValue(value, forKeyPath: PersistentKeys.sessionID.rawValue)
    }
    
    func removeSort () {
        UserDefaults.standard.setValue(nil, forKeyPath: PersistentKeys.Sort.rawValue)
    }
    
    func setCartBadge (_ value : Int) {
        UserDefaults.standard.setValue(value, forKeyPath: PersistentKeys.CartBadgeNumber.rawValue)
    }
    func setSort (_ value : Int) {
        UserDefaults.standard.setValue(value, forKeyPath: PersistentKeys.Sort.rawValue)
    }
    func setSelectedMainCat(_ value : String) {
        UserDefaults.standard.set(value, forKey: PersistentKeys.MainCat.rawValue)
    }
    func setSelectedSubCat(_ value : Int) {
        UserDefaults.standard.set(value, forKey: PersistentKeys.SubCat.rawValue)
    }
    func setAuthToken(_ value : String) {
        
        if value != "" {
            
            LHubCurrentDelegate.profileInfo.BearerToken = value
            
            UserDefaults.standard.set(value, forKey: PersistentKeys.Auth.rawValue)
            UserDefaults.standard.setValue(Date().timeIntervalSince1970, forKey: LHubGetBearerTokenTimestamp)
            
            UserDefaults.standard.synchronize()
        }
    }
    func setUserName(_ value : String) {
        LHubCurrentDelegate.userName = value
        UserDefaults.standard.set(value, forKey: PersistentKeys.UserName.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func setJWTToken(_ value : String) {
        LHubCurrentDelegate.profileInfo.JWTToken = value
        UserDefaults.standard.set(value, forKey: PersistentKeys.JWTAuth.rawValue)
        UserDefaults.standard.synchronize()
    }
    //Getters
    func getFilters () -> [String]? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.Filters.rawValue)
        if let na = value {
            return na as? [String]
        }
        else {
            return nil
        }
    }
    func getCartBadge () -> Int? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.CartBadgeNumber.rawValue)
        if let na = value {
            return na as? Int
        }
        else {
            return nil
        }
    }
    func getSort () -> Int? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.Sort.rawValue)
        if let na = value {
            return na as? Int 
        }
        else {
            return nil
        }
    }
    func getAuthToken () -> String? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.Auth.rawValue)
        if let na = value {
            return na as? String
        }
        else {
            return nil
        }
    }
    func getCSRF () -> String? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.CSRF.rawValue)
        if let na = value {
            return na as? String
        }
        else {
            return nil
        }
    }
    func getSessionID () -> String? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.sessionID.rawValue)
        if let na = value {
            return na as? String
        }
        else {
            return nil
        }
    }
    func getSubcat () -> Int? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.SubCat.rawValue)
        if let na = value {
            return na as? Int
        }
        else {
            return nil
        }
    }
    func getMainCateg () -> String? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.MainCat.rawValue)
        if let na = value {
            return na as? String
        }
        else {
            return nil
        }
    }
    func getUserName () -> String? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.UserName.rawValue)
        if let na = value {
            if (na as? String ?? "") != "appuser" && (na as? String ?? "") != "mobileapp" {
                return na as? String
            } else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    func getJWTToken () -> String? {
        let value = UserDefaults.standard.object(forKey: PersistentKeys.JWTAuth.rawValue)
        if let na = value {
            return na as? String
        }
        else {
            return nil
        }
    }
    
    func cleardata () {
        UserDefaults.standard.removeObject(forKey: PersistentKeys.CartBadgeNumber.rawValue)
        UserDefaults.standard.removeObject(forKey: PersistentKeys.JWTAuth.rawValue)
//        UserDefaults.standard.removeObject(forKey: PersistentKeys.Auth.rawValue)
//        UserDefaults.standard.removeObject(forKey: PersistentKeys.UserName.rawValue)
        UserDefaults.standard.synchronize()
    }
   
}
