//
//  PhotoAlbumTool.swift
//
//
//  Created by *** on 28/9/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumTool {

    //操作结果枚举
    enum PhotoAlbumResult {
        case success, error, denied
    }
    
    /// 判断是否授权
    ///
    /// - Returns: 返回授权结果
    class func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .notDetermined
    }

    /// 保存图片到相册
    ///
    /// - Parameters:
    ///   - image: 保存到相册的图片
    ///   - albumName: 指定相册名，如果不传，则保存到相机胶卷（否则保存到指定相册）
    ///   - completion: 保存之后回调
    class func saveImageInAlbum(image: UIImage, albumName: String = "",
                                completion: ((_ result: PhotoAlbumResult) -> ())?) {
        
        if !isAuthorized() {
            completion?(.denied)
            return
        }
        var assetAlbum: PHAssetCollection?
        
        if albumName.isEmpty {
            let list = PHAssetCollection
                .fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary,
                                       options: nil)
            assetAlbum = list[0]
        } else {
            
            let list = PHAssetCollection
                .fetchAssetCollections(with: .album, subtype: .any, options: nil)
            list.enumerateObjects({ (album, index, stop) in
                let assetCollection = album
                if albumName == assetCollection.localizedTitle {
                    assetAlbum = assetCollection
                    stop.initialize(to: true)
                }
            })
            
            if assetAlbum == nil {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest
                        .creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: { (isSuccess, error) in
                    self.saveImageInAlbum(image: image, albumName: albumName,
                                          completion: completion)
                })
                return
            }
        }
        
        PHPhotoLibrary.shared().performChanges({
            
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            
            if !albumName.isEmpty {
                let assetPlaceholder = result.placeholderForCreatedAsset
                let albumChangeRequset = PHAssetCollectionChangeRequest(for:
                    assetAlbum!)
                albumChangeRequset?.addAssets([assetPlaceholder as Any]  as NSArray)
            }
        }) { (isSuccess: Bool, error: Error?) in
            
            if isSuccess {
                completion?(.success)
            } else{
                let errorText = error != nil ? error?.localizedDescription : ""
                print("error: \(errorText ?? "")")
                completion?(.error)
            }
        }
    }
}

