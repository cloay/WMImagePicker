//
//  WMImagePickerViewController.swift
//
//
//  Created by cloay on 2017/10/23.
//  Copyright © 2017年 Cloay. All rights reserved.
//

import UIKit
import Photos

public enum WMImagePickerType {
    case single
    case multiple
}

protocol WMImagePickerViewControllerDelegate: class {
    
    /// 完成按钮或单选时选中照片回调
    ///
    /// - Parameter didFinishPickingImages: 选中照片的数组
    func wmImagePickerController(didFinishPickingImages: [WMImage])
    
    /// 取消选择
    func wmImagePickerControllerDidCancel()
}

class WMImagePickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver {
    
    /// 默认为0不限制
    var pickerMaxCount = 0
    var pickerType: WMImagePickerType = .single
    weak var delegate: WMImagePickerViewControllerDelegate?
    
    private var collectionV: UICollectionView?
    private var allAssets: PHFetchResult<PHAsset>?
    private var selectedIndexPaths: [IndexPath] = []
    private var allImagesDic: [String : WMImage] = [ : ]
    
    private let cellIdentifier = "TCIMAGE_PICKER_IDENTIFIER"
    private let rowCount = 3
    private let lineSpacing = 6
    private var cellWidth = CGFloat(0)
    
    convenience init(pickerType: WMImagePickerType = .single) {
        self.init()
        self.pickerType = pickerType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNav()
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allAssets = PHAsset.fetchAssets(with: .image, options: options)
        PHPhotoLibrary.shared().register(self)
        
        initColloectionView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    private func initNav() {
        title = "请选择照片"
        
        let titleColor = UIColor.init(red: 30 / 255.0, green: 144 / 255.0, blue: 1.0, alpha: 1.0)
        
        let cancelBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(titleColor, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnOnClick), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: cancelBtn)
        
        if pickerType == .multiple {
            let doneBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
            doneBtn.setTitle("完成", for: .normal)
            doneBtn.setTitleColor(titleColor, for: .normal)
            doneBtn.addTarget(self, action: #selector(doneBtnOnClick), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: doneBtn)
        }
    }
    
    private func initColloectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = CGFloat(lineSpacing)
        layout.minimumInteritemSpacing = CGFloat(lineSpacing)
        cellWidth = (view.bounds.size.width - CGFloat(lineSpacing * (rowCount + 1))) / CGFloat(rowCount)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        collectionV = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
        collectionV!.backgroundColor = .white
        collectionV!.dataSource = self
        collectionV!.delegate = self
        collectionV!.register(WMCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionV!)
    }
    
    @objc private func cancelBtnOnClick() {
        self.dismiss(animated: true) {
            if let delegate = self.delegate {
                delegate.wmImagePickerControllerDidCancel()
            }
        }
    }
    
    @objc private func doneBtnOnClick() {
        var selectedImages: [WMImage] = []
        autoreleasepool {
            for indexPath in selectedIndexPaths {
                if let image = allImagesDic[String.init(format: "%d", indexPath.row)] {
                    selectedImages.append(image)
                }
            }
        }
        
        if let delegate = self.delegate {
            delegate.wmImagePickerController(didFinishPickingImages: selectedImages)
        }
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - collectionview datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let allAssets = self.allAssets {
            return allAssets.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! WMCollectionViewCell
        cell.size = CGSize(width: cellWidth, height: cellWidth)
        
        let key = String.init(format: "%d", indexPath.row)
        var image = allImagesDic[key]
        if nil == image {
            let asset = allAssets![indexPath.row]
            image = WMImage()
            image!.asset = asset
            allImagesDic[key] = image
        }
        let isSelected = selectedIndexPaths.contains(indexPath)
        cell.updateData(with: image!, pickerType: pickerType, isSelected: isSelected, index: isSelected ? selectedIndexPaths.index(of: indexPath)! + 1 : 0)
        
        return cell
    }
    
    // MARK: - collectionView delegate method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //单选直接回调
        if pickerType == .single {
            var selectedImages: [WMImage] = []
            if let image = allImagesDic[String.init(format: "%d", indexPath.row)] {
                selectedImages.append(image)
            }
            self.dismiss(animated: true) {
                if let delegate = self.delegate {
                    delegate.wmImagePickerController(didFinishPickingImages: selectedImages)
                }
            }
        } else {
            var reloadItems: [IndexPath] = []
            if let index = selectedIndexPaths.index(of: indexPath) {
                selectedIndexPaths.remove(at: index)
                reloadItems.append(indexPath) //取消选择也要更新该Item选中状态
            } else {
                if pickerMaxCount > 0 { //限制了照片选择数量
                    if selectedIndexPaths.count < pickerMaxCount {
                        selectedIndexPaths.append(indexPath)
                    } else {
                        let alert = UIAlertController.init(title: "提示", message: String.init(format: "您最多只能选择%d张照片", pickerMaxCount), preferredStyle: .alert)
                        alert.addAction(UIAlertAction.init(title: "我知道了", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else { //不限制
                    selectedIndexPaths.append(indexPath)
                }
            }
            reloadItems.append(contentsOf: selectedIndexPaths)
            collectionView.reloadItems(at: reloadItems)
        }
    }
    
    // MARK: - photolibrary chanage observer delegate method
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        let photoChangeDetails = changeInstance.changeDetails(for: allAssets!)
        if let details = photoChangeDetails {
            allAssets = details.fetchResultAfterChanges
            DispatchQueue.main.async {
                self.collectionV!.reloadData()
            }
        }
    }
}
