//
//  CCPayCodeViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/19.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class CCPayCodeViewController: ViewController {

    @IBOutlet weak var codeImageView: UIImageView!
    
    var code: String = "pay:"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.global().async {
            let image = self.generateCode(self.code)
            DispatchQueue.main.async {
                self.codeImageView.image = image
            }
        }
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
