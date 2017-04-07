//
//  ScanCodeViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/6.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import AVFoundation

/// 扫描二维码 页面
class ScanCodeViewController: ViewController {

    let scanCodeView = CCScanCodeView(frame: CGRect.zero)
    
    typealias CodeCallback = (_ code: String) -> Void
    
    var codeMessage: CodeCallback?
    
    //    回话层对象
    lazy var session : AVCaptureSession = AVCaptureSession()
    
    //    预览图层
    lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let previewLayer : AVCaptureVideoPreviewLayer =  AVCaptureVideoPreviewLayer(session: self.session)
        return previewLayer
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        configSubviews()
        
        setupCodeScanning()
    }
    
    private func configSubviews() {
        view.addSubview(scanCodeView)
        scanCodeView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage.init(named: "back_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.view.addSubview(backButton)
        backButton.snp.updateConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(20)
            make.width.height.equalTo(48)
        }
        backButton.addTarget(self, action: #selector(buttonbackAction(_:)), for: .touchUpInside)
    }
    
    private func setupCodeScanning() {
        // 1、获取摄像设备
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            return
        }
        // 2、创建输入流
        let input = try? AVCaptureDeviceInput.init(device: device)
        // 3、创建输出流
        let output = AVCaptureMetadataOutput.init()
        // 4、设置代理 在主线程里刷新
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
        // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）
        output.rectOfInterest = CGRect(x: 0.05, y: 0.2, width: 0.7, height: 0.6)
        
        // 高质量采集率
        session.canSetSessionPreset(AVCaptureSessionPresetHigh)
        //        1.判断是否能加入输入
        if !session.canAddInput(input) {
            return
        }
        //        2.判断是否能加入输出
        if !session.canAddOutput(output) {
            return
        }
        // 5.1 添加会话输入
        session.addInput(input)
        
        // 5.2 添加会话输出
        session.addOutput(output)
        
        // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
        // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
        
        // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.frame = view.layer.bounds;
        // 8、将图层插入当前视图
        view.layer.insertSublayer(previewLayer, at: 0)
        // 9、启动会话
        session.startRunning()
    }
    
    
    @objc private func buttonbackAction(_ button: UIButton) {
        scanCodeView.stopAnimate()
        self.navigationController?.popViewController(animated: true)
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

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScanCodeViewController : AVCaptureMetadataOutputObjectsDelegate
{
    
    func playSoundEffect(name: String) {
        // 获取音效
        
        guard let audioFile = Bundle.main.path(forResource: name, ofType: nil) else {
            return
        }
        // 1、获得系统声音ID
        var soundID: SystemSoundID = 0
        
        let fileURL = URL.init(fileURLWithPath: audioFile)
        AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID)
        
        // 2、播放音频
        AudioServicesPlaySystemSound(soundID); // 播放音效
        
        if #available(iOS 9.0, *) {
            AudioServicesPlayAlertSoundWithCompletion(soundID) { 
                print("播放成功")
            }
        } else {
            // Fallback on earlier versions
            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, { (soundID, pointer) in
                print("播放成功")
            }, nil)
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        // 0、扫描成功之后的提示音
        playSoundEffect(name: "CCQRCode.bundle/sound.caf")
        session.stopRunning()
        //        1.获取到文字信息
        guard let metadata = metadataObjects.last as? AVMetadataObject else {
            return
        }
        let object = previewLayer.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
        print(object.stringValue)
        // 2、删除预览图层
        previewLayer.removeFromSuperlayer()
        
        scanCodeView.stopAnimate()
        
        if codeMessage != nil {
            self.navigationController?.popViewController(animated: true)
            codeMessage!(object.stringValue)
        }
        
    }
}

