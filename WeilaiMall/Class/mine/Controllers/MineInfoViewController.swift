//
//  MineInfoViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/23.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

/// 选择器的类型
///
/// - datePicker: 日期选择器
/// - sexPicker: 性别选择器
enum PickerStyle {
    case datePicker(Date)
    case sexPicker(Int)
}

/// 选择日期和性别 视图
class CCPickerView: UIView {
    
    let sexs = ["保密", "男", "女"]
    
    lazy var datePicker = UIDatePicker.init()
    
    lazy var sexPicker = UIPickerView.init()
    
    let controlView = UIView()
    
    let sureButton = UIButton(type: .system)
    
    let style: PickerStyle
    
    typealias styleCallback = (_ style: PickerStyle) -> Void
    
    var buttonAction: styleCallback?
    
    init(style: PickerStyle) {
        self.style = style
        super.init(frame: CGRect.zero)
        
        switch style {
        case .datePicker(let date):
            configDatePicker(date)
            break
        case .sexPicker(let sex):
            configSexPicker(sex)
            break
        }
    }
    
    private func configDatePicker(_ date: Date) {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor.white
        datePicker.setDate(date, animated: false)
        addSubview(datePicker)
        datePicker.snp.updateConstraints { (make) in
            make.width.left.right.bottom.equalToSuperview()
            make.top.equalTo(40)
        }
        addControlView()
    }
    
    private func configSexPicker(_ sex: Int) {
        addSubview(sexPicker)
        sexPicker.showsSelectionIndicator = true
        sexPicker.backgroundColor = UIColor.white
        sexPicker.delegate = self
        sexPicker.dataSource = self
        sexPicker.selectRow(sex, inComponent: 0, animated: false)
        sexPicker.snp.updateConstraints { (make) in
            make.width.left.right.bottom.equalToSuperview()
            make.top.equalTo(40)
        }
        addControlView()
    }
    
    private func addControlView() {
        controlView.backgroundColor = CCbackgroundColor
        let effectView = UIVisualEffectView.init(effect: UIVisualEffect.init())
        controlView.addSubview(effectView)
        effectView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(controlView)
        controlView.snp.updateConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(40)
        }
        
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(CCOrangeColor, for: .normal)
        controlView.addSubview(sureButton)
        sureButton.snp.updateConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        
        sureButton.addTarget(self, action: #selector(sureAction(_:)), for: .touchUpInside)
    }
    
    @objc func sureAction(_ button: UIButton) {
        switch style {
        case .datePicker(_):
            let date = datePicker.date
            if buttonAction != nil {
                buttonAction!(PickerStyle.datePicker(date))
            }
        case .sexPicker(_):
            let sex = sexPicker.selectedRow(inComponent: 0)
            if buttonAction != nil {
                buttonAction!(PickerStyle.sexPicker(sex))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CCPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

// MARK: - 我的信息
/// 我的信息
class MineInfoViewController: ViewController, CCTableViewProtocol {

    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var model: UserModel!
    
    let titles = ["头像", "真实姓名", "生日", "性别", "邮箱", "手机号"]
    
    let sexs = ["保密" ,"男", "女"]
    
    var detailTitles: [String] = []
    
    let cellIndentifier = "infoCell"
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        return imagePickerVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configTableView()
    }
    
    
    func configTableView() {
        self.view.addSubview(tableView)
        tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let timeZone = TimeZone.current.secondsFromGMT()
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: model.birthday)?.addingTimeInterval(TimeInterval(timeZone))
        
        formatter.dateFormat = "yyyy年MM月dd日"
        let birthday = formatter.string(from: date!)
        
        let sex = sexs[model.sex]
        
        detailTitles = ["", model.real_name, birthday, sex, model.email, String(model.mobile_phone)]
        
        self.view.addSubview(backgroundView)
        backgroundView.alpha = 0
        backgroundView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hideView(tap:))))
    }
    
    @objc private func hideView(tap: UITapGestureRecognizer) {
        for view in backgroundView.subviews {
            if view is CCPickerView {
                hidePickerView(pickerView: view as! CCPickerView)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "updateInfo" {
            let updateVC = segue.destination as! ChangeUserInfoViewController
            updateVC.textFieldText = sender as? String
            updateVC.change = {
                [unowned self] real_name in
                self.detailTitles[1] = real_name
                let cell = self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0))
                cell?.detailTextLabel?.text = real_name
            }
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MineInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 80: 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        func accessView() -> UIView {
            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
            let imageView = UIImageView.init()
            imageView.kf.setImage(with: URL(string: (model.user_picture)), placeholder: UIImage.init(named: "login"))
            imageView.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
            imageView.center = view.center
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 25
            view.addSubview(imageView)
            return view
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIndentifier)
            if indexPath.row == 0 {
                cell?.accessoryView = accessView()
            }
        }
        cell?.accessoryType = indexPath.row > 3 ? .none : .disclosureIndicator
        cell?.selectionStyle = indexPath.row > 3 ?.none: .default
        cell?.textLabel?.font = UIFont.CCsetfont(16)
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.detailTextLabel?.text = detailTitles[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            uploadUserPicture()
        }else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "updateInfo", sender: detailTitles[indexPath.row])
        }else if indexPath.row == 2 {
            changeDate()
        }else if indexPath.row == 3 {
            changeSex()
        }
    }
}


// MARK: - 时间选择和性别选择 以及修改
extension MineInfoViewController {
    
    func changeDate() {
        let timeZone = TimeZone.current.secondsFromGMT()
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: model.birthday)?.addingTimeInterval(TimeInterval(timeZone))
        
        let style = PickerStyle.datePicker(date!)
        
        backgroundView.alpha = 1.0
        
        let picker = showPicker(style: style)
        
        picker.buttonAction = {
            [unowned self] style in
            switch style {
            case .datePicker(let date):
                self.updateDateRequest(date: date)
                self.hidePickerView(pickerView: picker)
            default :
                break
            }
        }
    }
    
    func changeSex() {
        let style = PickerStyle.sexPicker(model.sex)
        backgroundView.alpha = 1.0
        let picker = showPicker(style: style)
        
        picker.buttonAction = {
            [unowned self] style in
            switch style {
            case .sexPicker(let sex):
                self.updateSexRequest(sex: sex)
                self.hidePickerView(pickerView: picker)
            default :
                break
            }
        }
        
    }
    
    func showPicker(style: PickerStyle) -> CCPickerView {
        let picker = CCPickerView(style: style)
        backgroundView.addSubview(picker)
        
        picker.snp.updateConstraints { (make) in
            make.width.left.right.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        backgroundView.layoutIfNeeded()
        picker.snp.updateConstraints { (make) in
            make.width.left.right.bottom.equalToSuperview()
            make.height.equalTo(240)
        }
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.layoutIfNeeded()
        }
        return picker
    }
    
    func hidePickerView(pickerView: CCPickerView) {
        pickerView.snp.updateConstraints { (make) in
            //make.width.left.right.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        UIView.animate(withDuration: 0.2, animations: { 
            pickerView.superview?.layoutIfNeeded()
        }) { (complete) in
            if complete {
                self.backgroundView.alpha = 0
                pickerView.removeFromSuperview()
            }
        }
    }
    
    func updateDateRequest(date: Date) {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let birthday = formatter.string(from: date)
        let request = UpdateInfoRequest(parameter: ["access_token": access_token, "birthday": birthday])
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            hub.hide(animated: true)
            if error == nil {
                do {
                    try CoreDataManager().updateUser(with: ["birthday": birthday])
                    formatter.dateFormat = "yyyy年MM月dd日"
                    let birthday = formatter.string(from: date)
                    self?.detailTitles[2] = birthday
                    let cell = self?.tableView.cellForRow(at: IndexPath.init(row: 2, section: 0))
                    cell?.detailTextLabel?.text = birthday
                }catch {
                    MBProgressHUD.showErrorAdded(message: (error as NSError).domain , to: self?.view)
                }
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())! , to: self?.view)
            }
        }
    }
    
    func updateSexRequest(sex: Int) {
        let request = UpdateInfoRequest(parameter: ["access_token": access_token, "sex": sex])
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            hub.hide(animated: true)
            if error == nil {
                do {
                    try CoreDataManager().updateUser(with: ["sex": Int64(sex)])
                }catch {
                    MBProgressHUD.showErrorAdded(message: (error as NSError).domain , to: self?.view)
                }
                let sexTitle = self?.sexs[sex]
                self?.detailTitles[3] = sexTitle!
                let cell = self?.tableView.cellForRow(at: IndexPath.init(row: 3, section: 0))
                cell?.detailTextLabel?.text = sexTitle
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())! , to: self?.view)
            }
        }
    }
}

// MARK: - 上传头像，更改用户头像
extension MineInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func uploadUserPicture() {
        
        func cameraGet() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                present(imagePickerController, animated: true, completion: nil)
            }else {
                print("模拟器中不能打开相机")
            }
        }
        
        func photoGet() {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
        
        
        let sheet = UIAlertController(title: "选择", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "拍照", style: .default) { (action) in
            cameraGet()
        }
        let photo = UIAlertAction(title: "相册", style: .default) { (action) in
            photoGet()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        sheet.addAction(camera)
        sheet.addAction(photo)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
    }
    
    func updateImageView(image: UIImage) {
        
        //let user_picture = String.init(data: UIImageJPEGRepresentation(image, 0.5)!, encoding: .utf8)
        
        func changeImageView() {
            let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))
            for view in (cell?.accessoryView?.subviews)! {
                if view is UIImageView {
                    (view as! UIImageView).image = image
                }
            }
        }
        
        let request = UpdateInfoRequest(parameter: ["access_token": access_token, "user_picture": UIImageJPEGRepresentation(image, 0.5)!])
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            hub.hide(animated: true)
            if error == nil {
                changeImageView()
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage]
        print(image!)
        updateImageView(image: image as! UIImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

