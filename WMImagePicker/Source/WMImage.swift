//
//  WMImage.swift
//
//
//  Created by cloay on 2017/10/24.
//  Copyright © 2017年 Cloay. All rights reserved.
//

import Foundation
import Photos

class WMImage {
    
    /// 图片信息
    var asset: PHAsset?
    
    /// 缩略图
    var thumbnail: UIImage?
    
    /// 原图
    lazy var original: UIImage? = {
        var image: UIImage?
        if let asset = self.asset {
            let requestOpts = PHImageRequestOptions()
            requestOpts.isSynchronous = true
            PHImageManager.default().requestImageData(for: asset, options: requestOpts, resultHandler: { (imageData, imageUTI, orientation, info) in
                if let data = imageData {
                    image = UIImage.init(data: data)
                }
            })
        }
        
        if nil == image, nil != thumbnail {
            image = thumbnail
        }
        return image
    }()
    
}
