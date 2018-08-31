//
//  ViewController.swift
//  WMImagePicker
//
//  Created by cloay on 2018/8/31.
//  Copyright © 2018年 Cloay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var imagePicker: WMImagePicker? = {
        return WMImagePicker()
    }()
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func setAvatarBtnOnClick(_ sender: Any) {
        imagePicker?.showIn(self, didSelectedImageBlock: { images in
            self.imgView.image = images.first?.thumbnail
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

