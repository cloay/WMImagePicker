# WMImagePicker 
## WMImagePicker是一个图片选择组件，可调取摄像头和图库。

<img src="https://github.com/cloay/WMImagePicker/blob/master/demo_multiple.png" width="330" height="640"/>

## 主要功能特点：
1、图片选择UI类似微信支持多图选择</br>
2、支持缩略图、原图，原图使用lazy模式，使用时动态读取</br>
3、支持图片库、照相机访问权限提示

## 使用方式
利用cocoapods的方式导入，在Podfile文件中添加如下：
```
target 'TargetName' do
    pod 'WMImagePicker'
end
```
## 用法

```
let imagePicker = WMImagePicker()
imagePicker.showIn(self, didSelectedImageBlock: { images in
    //images为WMImage类型的图片数组
    
})
```
详细使用参考Demo
</br></br></br></br></br>


