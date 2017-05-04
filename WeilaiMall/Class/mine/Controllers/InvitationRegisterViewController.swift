//
//  InvitationRegisterViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/11.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

class InvitationRegisterViewController: ViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var codeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBackItem()
        
        
        DispatchQueue.global().async {
            var mobile_phone = ""
            if let userinfo = CoreDataManager().getCoreData() {
                mobile_phone = String(userinfo.mobile_phone)
            }
            let image = self.generateCode(webViewHost+"register?invite_code="+mobile_phone)
            DispatchQueue.main.async {
                self.codeImageView.image = image
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func shareCodeAction(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(cutImageWithView(view: self.view), self, #selector(savedPhotosAlbum(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    //保存图片
    func savedPhotosAlbum(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            MBProgressHUD.showErrorAdded(message: "保存失败", to: self.view)
        } else {
            MBProgressHUD.showErrorAdded(message: "保存成功,你可以相册查看", to: self.view)
        }
    }
    
    /// 截屏
    ///
    /// - Parameters:
    ///   - view: 要截屏的view
    /// - Returns: 一个UIImage
    func cutImageWithView(view:UIView) -> UIImage
    {
        // 参数①：截屏区域  参数②：是否透明  参数③：清晰度
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InvitationRegisterViewController {
    func generateCode(_ info: String, imageWidth: CGFloat = 125) -> UIImage {
        
        let QRCodeColor = UIColor.black
        let QRCodeBgColor = UIColor.white
        //let QRCodeSize = CGSize(width: imageWidth, height: imageWidth)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = info.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let ci_image = filter?.outputImage
        
        
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setValue(ci_image, forKey: "inputImage")
        colorFilter?.setValue(CIColor(cgColor: QRCodeColor.cgColor), forKey: "inputColor0")// 二维码颜色
        colorFilter?.setValue(CIColor(cgColor: QRCodeBgColor.cgColor), forKey: "inputColor1")// 背景色
        
        let outImage = colorFilter?.outputImage
        let scale = imageWidth / outImage!.extent.size.width;
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = outImage?.applying(transform)
        
        let image = UIImage(ciImage: transformImage!)
        return image
    }
}
