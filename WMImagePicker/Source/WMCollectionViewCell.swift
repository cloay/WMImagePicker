//
//  WMCollectionViewCell.swift
//
//
//  Created by cloay on 2017/10/23.
//  Copyright © 2017年 Cloay. All rights reserved.
//

import UIKit
import Photos

class WMCollectionViewCell: UICollectionViewCell {
    private let imageV = UIImageView()
    private let unselectedView = UIView()
    private let selectedLabel = UILabel()
    
    private let selectedWidth = CGFloat(26)
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        
        set {
            if newValue.width != imageV.frame.size.width {
                imageV.frame = CGRect.init(x: 0, y: 0, width: newValue.width, height: newValue.height)
                imageV.layer.masksToBounds = true
                imageV.contentMode = .scaleAspectFill
                unselectedView.frame = CGRect.init(x: newValue.width - selectedWidth, y: 0, width: selectedWidth, height: selectedWidth)
                selectedLabel.frame = unselectedView.frame
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageV)
        
        unselectedView.backgroundColor = UIColor.init(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 0.6)
        unselectedView.layer.masksToBounds = true
        unselectedView.layer.cornerRadius = 2
        unselectedView.layer.borderWidth = 2
        unselectedView.layer.borderColor = UIColor.white.cgColor
        unselectedView.isHidden = true
        contentView.addSubview(unselectedView)
        
        selectedLabel.textColor = .white
        selectedLabel.font = UIFont.systemFont(ofSize: 14)
        selectedLabel.textAlignment = .center
        selectedLabel.backgroundColor = UIColor.init(red: 50 / 255.0, green: 205 / 255.0, blue: 50 / 255, alpha: 1.0)
        selectedLabel.layer.masksToBounds = true
        selectedLabel.layer.cornerRadius = selectedWidth / CGFloat(2)
        selectedLabel.isHidden = true
        contentView.addSubview(selectedLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(with image: WMImage, pickerType: WMImagePickerType? = .single,  isSelected: Bool? = false, index: Int? = 0) {
        if let thumbnail = image.thumbnail {
            imageV.image = thumbnail
        } else {
            let requestOpts = PHImageRequestOptions()
            requestOpts.deliveryMode = .opportunistic
            PHImageManager.default().requestImage(for: image.asset!, targetSize: CGSize.init(width: 2 * size.width, height: 2 * size.height), contentMode: .aspectFit, options: requestOpts) { (thumbnail, info) in
                image.thumbnail = thumbnail
                DispatchQueue.main.async {
                    self.imageV.image = thumbnail
                }
            }
        }
        
        if pickerType == .multiple {
            if isSelected! {
                unselectedView.isHidden = true
                selectedLabel.isHidden = false
                selectedLabel.text = String.init(format: "%d", index!)
            } else {
                unselectedView.isHidden = false
                selectedLabel.isHidden = true
            }
        }
    }
}
