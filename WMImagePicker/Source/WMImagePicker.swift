//
//  WMImagePicker.swift
//  
//
//  Created by cloay on 2017/9/10.
//  Copyright © 2017年 Cloay. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

typealias WMImagePickerDidSeletedImage = ([WMImage]) -> ()

class WMImagePicker: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, WMImagePickerViewControllerDelegate {
    
    /// 从图片库选择类型多选还是单选
    var pickerType: WMImagePickerType = .single
    
    /// 是否限制多选照片数，默认为0不限制
    var pickerMaxCount = 0
    
    var didSelectedImageBlock: WMImagePickerDidSeletedImage?
    
    convenience init(pickerType: WMImagePickerType? = .single, pickerMaxCount: Int? = 0, didSelectedImageBlock: WMImagePickerDidSeletedImage? = nil) {
        self.init()
        self.pickerType = pickerType!
        self.pickerMaxCount = pickerMaxCount!
        self.didSelectedImageBlock = didSelectedImageBlock
    }

    
    /// 弹出图片选择器
    ///
    /// - Parameters:
    ///   - viewController: 从该Vc中弹出
    ///   - didSelectedImageBlock: 照片回调
    func showIn(_ viewController: UIViewController, didSelectedImageBlock: WMImagePickerDidSeletedImage? = nil) {
        self.didSelectedImageBlock = didSelectedImageBlock
        
        self.view.backgroundColor = .clear
        self.modalPresentationStyle = .overCurrentContext
        viewController.present(self, animated: false, completion: {
            self.show()
        })
    }
    
    
    private func show() {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction.init(title: "相册", style: .default, handler: { action in
            let status = PHPhotoLibrary.authorizationStatus()            
            if status == .denied || status == .restricted {
                self.showAlert(pesentVc: self, title: "提示", message: "尚未开启访问照片权限，您可以去设置->隐私->照片中设置开启", handler: { action in
                    UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
                })
                return
            }
            
            let imagePicker = WMImagePickerViewController()
            imagePicker.pickerType = self.pickerType 
            imagePicker.pickerMaxCount = self.pickerMaxCount
            imagePicker.delegate = self
            let nav = UINavigationController.init(rootViewController: imagePicker)
            self.present(nav, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { action in
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if status == .denied || status == .restricted {
                self.showAlert(pesentVc: self, title: "提示", message: "尚未开启相机权限，您可以去设置->隐私->相机，设置开启", handler: { action in
                    UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
                })
                return
            }
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera;
            imagePicker.delegate = self
            imagePicker.showsCameraControls = true
            imagePicker.cameraCaptureMode = .photo
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { action in
            self.dismiss(animated: false, completion: nil)
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    private func showAlert(pesentVc: UIViewController, title: String, message: String, handler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: handler))
        pesentVc.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - 照相机回调
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage]
        if let _ = image {
            let originalImage = image as! UIImage
            
            //保存到相册
            if picker.sourceType == .camera {
                UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil)
            }
            
            if let block = self.didSelectedImageBlock {
                let mImage = WMImage()
                mImage.thumbnail = originalImage
                block([mImage])
            }
        }
        picker.dismiss(animated: true, completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - 照片库选择
    func wmImagePickerController(didFinishPickingImages: [WMImage]) {
        if let block = self.didSelectedImageBlock {
            block(didFinishPickingImages)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func wmImagePickerControllerDidCancel() {
        self.dismiss(animated: false, completion: nil)
    }

}
