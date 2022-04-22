//
//  CacheTool.swift.swift
//  
//
//  Created by *** on 2019/6/25.
//  Copyright © 2019年 ***. All rights reserved.
//

class CacheTool {
    
    static func checkCacheData(completeHandler:((_ cache: String)->())?) {
        
        var cacheString = ""
        
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        let files = FileManager.default.subpaths(atPath: cachePath!)
        var big = Float()
        
        DispatchQueue.global().async {
            
            for p in files!{
                
                let path = cachePath!.appendingFormat("/\(p)")
                
                var floder:[FileAttributeKey : Any]?
                do {
                    floder = try FileManager.default.attributesOfItem(atPath: path)
                    
                } catch {
                    print("error : \(error)")
                    cacheString = "0 MB"
                }
                
                if floder != nil {
                    
                    for (abc,bcd) in floder! {
                        if abc == FileAttributeKey.size {
                            big += (bcd as AnyObject).floatValue
                        }
                    }
                }
            }
            print("Cache Data \(big/(1024*1024)) MB")
            if (big/(1024*1024)) < 0.01 {
                cacheString = "0 MB"
            } else {
                cacheString = (String(format: "%.2f", big/(1024*1024)) + " MB")
            }
            completeHandler?(cacheString)
        }
    }
    
    static func cleanCache(completeHandler:((_ success: Bool)->())?) {
        
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let files = FileManager.default.subpaths(atPath: cachePath!)
        
        for p in files!{
            
            let path = cachePath!.appendingFormat("/\(p)")
            
            if FileManager.default.fileExists(atPath: path) {

                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    completeHandler?(false)
                    print("Delete Error \(error)")
                }
            }
        }
        completeHandler?(true)
    }
}
