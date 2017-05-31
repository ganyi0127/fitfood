//
//  InformationVC.swift
//  FitFood
//
//  Created by YiGan on 24/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
@IBDesignable
class InformationVC: UIViewController {
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    
    //锁定
    fileprivate var isLocked = true{
        didSet{
            lockButton.setTitle(isLocked ? "unlock" : "lock", for: .normal)
            refuseButton.setTitle(isLocked ? "<" : "x", for: .normal)
            genderButton.isEnabled = !isLocked
            swipe?.isEnabled = false
            
            //隐藏输入
            if isLocked{
                self.nameTextfield.endEditing(true)
                self.hiddenSelector()
            }
            
            //动画
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                
                self.acceptButton.isHidden = self.isLocked
                self.linesLayer.isHidden = self.isLocked
                
                self.heightLine.isHidden = self.isLocked
                self.weightLine.isHidden = self.isLocked
                self.weightLeftShape.isHidden = self.isLocked
                self.weightRightShape.isHidden = self.isLocked
                
                let gradientX: CGFloat = self.isLocked ? -15 : -10
                self.genderlabelGradient.frame.origin.x = gradientX
                self.namelabelGradient.frame.origin.x = gradientX
                self.birthdayLabelGradient.frame.origin.x = gradientX
                
                if self.isLocked{
                    self.weightLabel.textColor = word_white_color
                    self.heightLabel.textColor = word_white_color
                    self.nameLabel.textColor = word_white_color
                    self.birthdayLabel.textColor = word_white_color
                }else{
                    
                }
            }, completion: nil)
        }
    }
    
    //昵称
    fileprivate var nickName: String = ""{
        didSet{
            
            let prefixText = "Nickname: "
            let text = prefixText + nickName
            let attributeString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: font_middle, NSForegroundColorAttributeName: UIColor.green])
            attributeString.addAttributes([NSFontAttributeName: font_small, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, prefixText.characters.count))
            nameLabel.attributedText = attributeString
        }
    }
    
    //生日
    fileprivate var birthday = Date(){
        didSet{
            let calendar = Calendar.current
            let birthdayYear = calendar.component(.year, from: birthday)
            let currentYear = calendar.component(.year, from: Date())
            let age = currentYear - birthdayYear
            
            let prefixText = "Age: "
            let text = prefixText + "\(age)"
            let attributeString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: font_middle, NSForegroundColorAttributeName: UIColor.green])
            attributeString.addAttributes([NSFontAttributeName: font_small, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, prefixText.characters.count))
            birthdayLabel.attributedText = attributeString
        }
    }
    
    //体重
    fileprivate var weightTenTimes: CGFloat = 650.0{
        didSet{
            weight = weightTenTimes / 10
        }
    }
    fileprivate var weight: CGFloat = 65.0 {
        didSet{
            if weight > 250 {
                weight = 250
                return
            }else if weight < 20{
                weight = 20
                return
            }
            
            weight = CGFloat(lroundf(Float(weight) * 10 / 5) * 5) / 10
            changeWeight()
        }
    }
    
    //身高
    fileprivate var heightTenTimes: CGFloat = 1700.0{
        didSet{
            height = heightTenTimes / 10
        }
    }
    fileprivate var height: CGFloat = 170.0 {
        didSet{
            if height > 230 {
                height = 230
                return
            }else if height < 30{
                height = 30
                return
            }
            
            height = CGFloat(lroundf(Float(height) * 10)) / 10
            changeHeight()
        }
    }
    
    //性别
    fileprivate var genderIsGirl = false{
        didSet{
            genderButton.isSelected = genderIsGirl
            bigWhiteView.genderIsGirl = genderIsGirl
        }
    }
    
    //体重显示
    private lazy var weightView: UIView = {                 //weight指示
        let weightViewFrame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height * 0.8 + 8, width: 1, height: 17 * 2)
        let weightView: UIView = UIView(frame: weightViewFrame)
        weightView.backgroundColor = .clear
        weightView.addSubview(self.weightLabel)
        weightView.layer.addSublayer(self.weightLeftShape)
        weightView.layer.addSublayer(self.weightRightShape)
        weightView.layer.addSublayer(self.weightLine)
        return weightView
    }()
    private lazy var weightLabel: UILabel = {               //weight标签
        let labelFrame = CGRect(x: -80, y: 20, width: 160, height: 44)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .center
        label.font = font_big
        label.textColor = .green
        return label
    }()
    private lazy var weightLeftShape: CAShapeLayer = {      //weight左边界
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: 0, y: 17))
        bezier.close()
        let shape = CAShapeLayer()
        shape.path = bezier.cgPath
        shape.lineWidth = 2
        shape.lineCap = kCALineCapRound
        shape.strokeColor = UIColor.white.cgColor
        return shape
    }()
    private lazy var weightRightShape: CAShapeLayer = {      //weight右边界
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: 0, y: 17))
        bezier.close()
        let shape = CAShapeLayer()
        shape.path = bezier.cgPath
        shape.lineWidth = 2
        shape.lineCap = kCALineCapRound
        shape.strokeColor = UIColor.white.cgColor
        return shape
    }()
    private lazy var weightLine: CAShapeLayer = {
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: 8))
        bezier.addLine(to: CGPoint(x: 1, y: 17))
        bezier.close()
        let shape = CAShapeLayer()
        shape.path = bezier.cgPath
        shape.lineWidth = 2
        shape.lineCap = kCALineCapRound
        shape.strokeColor = UIColor.white.cgColor
        return shape
    }()
    
    //身高显示
    private lazy var heightView: UIView = {                 //height指示
        let heightViewFrame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: self.view.frame.width / 2, height: 10)
        let heightView: UIView = UIView(frame: heightViewFrame)
        heightView.backgroundColor = .clear
        heightView.addSubview(self.heightLabel)
        heightView.layer.addSublayer(self.heightLine)
        return heightView
    }()
    private lazy var heightLabel: UILabel = {               //height标签
        let labelFrame = CGRect(x: self.view.frame.width / 2 - 180 - 20, y: 2, width: 180, height: 44)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .right
        label.font = font_big
        label.textColor = .green
        return label
    }()
    private lazy var heightLine: CAShapeLayer = {
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 64, y: 0))
        bezier.addLine(to: CGPoint(x: self.view.frame.width / 2 - 20, y: 0))
        bezier.close()
        let shape = CAShapeLayer()
        shape.path = bezier.cgPath
        shape.lineWidth = 2
        shape.lineCap = kCALineCapRound
        shape.strokeColor = UIColor.white.cgColor
        return shape
    }()
    
    //标签底图
    private lazy var genderlabelGradient: CAGradientLayer = {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: -15, y: self.genderButton.frame.origin.y, width: 20, height: self.genderButton.frame.height)
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.colors = [UIColor.white.cgColor, UIColor.purple.cgColor]
        gradient.cornerRadius = 10
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowOffset = .zero
        gradient.shadowOpacity = 0.5
        gradient.shadowRadius = 5
        return gradient
    }()
    private lazy var namelabelGradient: CAGradientLayer = {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: -15, y: self.nameLabel.frame.origin.y, width: 20, height: self.nameLabel.frame.height)
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.colors = [UIColor.white.cgColor, UIColor.red.cgColor]
        gradient.cornerRadius = 10
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowOffset = .zero
        gradient.shadowOpacity = 0.5
        gradient.shadowRadius = 5
        return gradient
    }()
    private lazy var birthdayLabelGradient: CAGradientLayer = {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: -15, y: self.birthdayLabel.frame.origin.y, width: 20, height: self.birthdayLabel.frame.height)
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.colors = [UIColor.white.cgColor, UIColor.yellow.cgColor]
        gradient.cornerRadius = 10
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowOffset = .zero
        gradient.shadowOpacity = 0.5
        gradient.shadowRadius = 5
        return gradient
    }()
    
    private let bigWhiteView = BigWhiteView()               //大白
    private let linesLayer = CALayer()                      //网格
    
    fileprivate var isHorizontalScroll: Bool?               //判断滑动方向
    fileprivate var swipe: UISwipeGestureRecognizer?            //下滑
    
    
    //MARK:- init*****************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    deinit {
        if let s = swipe{
            view.removeGestureRecognizer(s)
        }
    }
    
    private func config(){
        
        //键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //下滑事件
        swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(swipe:)))
        swipe?.direction = .down
        view.addGestureRecognizer(swipe!)
        
        //初始化
        genderButton.setTitle("boy", for: .normal)
        genderButton.setTitle("girl", for: .selected)
        genderButton.setTitleColor(.blue, for: .normal)
        genderButton.setTitleColor(.magenta, for: .selected)
        nameLabel.font = font_small
        birthdayLabel.font = font_small
        
        //初始化默认值
        if let user = coredateHandler.currentUser(){
            nickName = user.nickName!
            birthday = user.birthday! as Date
            heightTenTimes = CGFloat(user.height) * 10
            genderIsGirl = user.gender == 0
        }
        
        if let weightItem = coredateHandler.currentWeightItem(){
            weightTenTimes = CGFloat(weightItem.weight) * 10
        }else{
            weightTenTimes = 65 * 10
        }
        
        isLocked = true
    }
    
    @objc private func swipeDown(swipe: UISwipeGestureRecognizer){
        
        hiddenSelector()
        nameTextfield.endEditing(true)
    }
    
    private func createContents(){
        
        //间隔
        let intervalLength: CGFloat = view_size.width * 0.1
        
        //行列数
        let lineCount = lroundf(Float(view_size.height / intervalLength))
        let columnCount = lroundf(Float(view_size.width / intervalLength))
    
        //绘制行
        for line in 0..<lineCount {
            if line == 0{
                continue
            }
            let bezier = UIBezierPath()
            let y = CGFloat(line) * intervalLength
            bezier.move(to: CGPoint(x: 0, y: y))
            bezier.addLine(to: CGPoint(x: view_size.width, y: y))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezier.cgPath
            shapeLayer.lineWidth = 1
            shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
            linesLayer.addSublayer(shapeLayer)
        }
        
        //绘制列
        for column in 0..<columnCount{
            if column == 0 {
                continue
            }
            let bezier = UIBezierPath()
            let x = CGFloat(column) * intervalLength
            bezier.move(to: CGPoint(x: x, y: 0))
            bezier.addLine(to: CGPoint(x: x, y: view_size.height))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezier.cgPath
            shapeLayer.lineWidth = 1
            shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
            linesLayer.addSublayer(shapeLayer)
        }
        view.layer.insertSublayer(linesLayer, at: 0)
        
        //添加大白视图
        view.addSubview(bigWhiteView)
        
        //添加体重身高显示视图
        view.addSubview(weightView)
        view.addSubview(heightView)
        
        //添加标签背图
        view.layer.addSublayer(genderlabelGradient)
        view.layer.addSublayer(namelabelGradient)
        view.layer.addSublayer(birthdayLabelGradient)
        
        //移动大白z位置
        view.bringSubview(toFront: nameTextfield)
        
        //判断是否添加过体重
        if coredateHandler.currentWeightItem() == nil {
            let text = "Weight....kg"
            let attributeString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: font_small, NSForegroundColorAttributeName: UIColor.red])
            weightLabel.attributedText = attributeString
        }
    }
    
    //MARK:- 修改体重
    private func changeWeight(){
        bigWhiteView.weight = weight
        
        updateWeightView()
    }
    
    //MARK:- 更新体重显示
    private func updateWeightView(){
        let left = -bigWhiteView.width / 2
        let right = bigWhiteView.width / 2
        
        let lineBezier = UIBezierPath()
        lineBezier.move(to: CGPoint(x: left - 1, y: self.weightLine.frame.origin.y))
        lineBezier.addLine(to: CGPoint(x: right + 1, y: self.weightLine.frame.origin.y))
        lineBezier.close()
        
        let leftBezier = UIBezierPath()
        leftBezier.move(to: CGPoint(x: left, y: 0))
        leftBezier.addLine(to: CGPoint(x: left, y: 17))
        leftBezier.close()
        
        let rightBezier = UIBezierPath()
        rightBezier.move(to: CGPoint(x: right, y: 0))
        rightBezier.addLine(to: CGPoint(x: right, y: 17))
        rightBezier.close()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.weightLeftShape.path = leftBezier.cgPath
            self.weightRightShape.path = rightBezier.cgPath
            self.weightLine.path = lineBezier.cgPath
        })
        
        let prefixText = "Weight"
        let unitText = "kg"
        let text = prefixText + "\(weight)" + unitText
        let attributeString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: font_middle, NSForegroundColorAttributeName: UIColor.green])
        attributeString.addAttributes([NSFontAttributeName: font_small, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, prefixText.characters.count))
        attributeString.addAttributes([NSFontAttributeName: font_small, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(text.characters.count - unitText.characters.count, unitText.characters.count))
        weightLabel.attributedText = attributeString
    }
    
    //MARK:- 修改身高
    private func changeHeight(){
        bigWhiteView.height = height
        
        updateHeightView()
    }
    
    //MARK:- 更新身高显示
    private func updateHeightView(){
        let top = bigWhiteView.top
        UIView.animate(withDuration: 0.1, animations: {
            self.heightView.frame.origin = CGPoint(x: self.heightView.frame.origin.x, y: top)
        })

        let prefixText = "Height"
        let unitText = "cm"
        let text = prefixText + "\(height)" + unitText
        let attributeString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: font_middle, NSForegroundColorAttributeName: UIColor.green])
        attributeString.addAttributes([NSFontAttributeName: font_small, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, prefixText.characters.count))
        attributeString.addAttributes([NSFontAttributeName: font_small, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(text.characters.count - unitText.characters.count, unitText.characters.count))
        heightLabel.attributedText = attributeString
    }
    
    //MARK:- 锁定按钮
    @IBAction func lock(_ sender: UIButton) {
        isLocked = !isLocked
    }
    
    //MARK:- 放弃并返回
    @IBAction func refuse(_ sender: Any) {
        
        //判断是否有修改项目
        let weightItem = coredateHandler.currentWeightItem()
        if let currentWeight = weightItem?.weight {
            guard currentWeight.isEqual(to: Float(weight)) else {
                self.alertDismiss(needComplete: false)
                return
            }
        }else{
            self.alertDismiss(needComplete: true)
            return
        }
        
        guard user.nickName == nickName, user.height.isEqual(to: Float(height)), user.gender == (genderIsGirl ? 0 : 1), user.birthday!.isEqual(to: birthday), weightItem!.weight.isEqual(to: Float(weight)) else {
            self.alertDismiss(needComplete: false)
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:退出提示
    private func alertDismiss(needComplete: Bool){
        let title = needComplete ? "体重要*初*始*化*" : "不保存的话...."
        let message = needComplete ? "留我何用???（ˇ＾ˇ)" : "白设置了....（ˇ＾ˇ)"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "不要不要", style: .default, handler: {
            _ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(continueAction)
        if !needComplete {
            let saveAction = UIAlertAction(title: "*右*上*角* =_=凸", style: .default, handler: {
                _ in
                self.accept(self.acceptButton)
            })
            alert.addAction(saveAction)
        }
        let cancelAction = UIAlertAction(title: "马上", style: .default, handler: nil)
        alert.addAction(cancelAction)
        alert.setCustomStyle()
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- 修改并保存
    @IBAction func accept(_ sender: Any) {
        //存储个人数据
        user?.nickName = nickName
        user?.birthday = birthday as NSDate
        user?.height = Float(height)
        user?.gender = genderIsGirl ? 0 : 1
        //计算合理体重
        user?.standardWeight = genderIsGirl ? Float(height) - 110 : Float(height) - 105
        
        if coredateHandler.addWeight(weight: Float(weight)) {
            showNotif(withTitle: "保存成功!", duration: 2, closure: {
                self.dismiss(animated: true, completion: nil)
                infoChanged = true
            })
        }else{
            showNotif(withTitle: "另人意外地保存失败", duration: 2, closure: nil)
        }
    }
    
    @IBAction func switchGender(_ sender: Any) {
        genderIsGirl = !genderIsGirl
        
        nameTextfield.endEditing(true)
        hiddenSelector()
    }
    @IBAction func clickNameLabel(_ sender: Any) {
        guard !isLocked else {
            return
        }
        
        hiddenSelector()
        
        swipe?.isEnabled = true
        
        nameTextfield.isHidden = false
        nameTextfield.text = nickName
        nameTextfield.becomeFirstResponder()
    }
    @IBAction func clickBirthdayLabel(_ sender: Any) {
        guard !isLocked else {
            return
        }
        
        nameTextfield.endEditing(true)
        nameTextfield.resignFirstResponder()
        
        swipe?.isEnabled = true
        
        showSelector(with: .birthday, closure: {
            accepted, value in
            
            self.swipe?.isEnabled = false
            
            guard accepted else{
                return
            }
            
            guard let date = value as? Date else{
                return
            }
            
            self.birthday = date
        })
    }
    
    @IBAction func nameChanged(_ sender: UITextField) {
        guard sender.text != nil else{
            return
        }
        
        //判断长度
        let maxLength: Int = 20                      //输入最大长度
        
        //限制字符数
        if (sender.text?.lengthOfBytes(using: String.Encoding.utf8))! > maxLength{
            while sender.text!.lengthOfBytes(using: String.Encoding.utf8) > maxLength {
                
                let endIndex = sender.text!.index(sender.text!.endIndex, offsetBy: -1)
                let range = Range(sender.text!.startIndex..<endIndex)
                sender.text = sender.text!.substring(with: range)
            }
        }
    }
}

//MARK:- 触摸事件
extension InformationVC{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isLocked else {
            return
        }
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: view)
        
        isHorizontalScroll = location.y > view.frame.height * 0.8
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard !isLocked else {
            return
        }
        
        guard let touch = touches.first else {
            return
        }
        
        let curLocation = touch.location(in: view)
        let preLocation = touch.previousLocation(in: view)
        
        //当距离过小，不处理
        /*
        let distance = sqrt(pow(curLocation.x - preLocation.x, 2) + pow(curLocation.y - preLocation.y, 2))
        guard distance > 5 else {
            return
        }
         */

        //当其他字段处于编辑状态，不处理
        guard !nameTextfield.isEditing && !isSelectorShow() else {
            return
        }
        
        guard let isHorizontal = isHorizontalScroll else {
            return
        }
        
        if isHorizontal {
            let deltaHorizontal = curLocation.x - preLocation.x
            weightTenTimes += deltaHorizontal
        }else{
            let deltaVertical = curLocation.y - preLocation.y
            heightTenTimes -= deltaVertical
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHorizontalScroll = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHorizontalScroll = nil
    }
}

//MARK:- textfield delegate
extension InformationVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isHidden = true
        swipe?.isEnabled = false
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        nickName = textField.text ?? ""
        return true
    }
    
    //键盘弹出
    func keyboardWillShow(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let keyboardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let offset = keyboardBounds.size.height
        
        let animations = {
            let keyboardTransform = CGAffineTransform(translationX: 0, y: -offset)
            self.nameTextfield.transform = keyboardTransform
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    
    //键盘回收
    func keyboardWillHide(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations = {
            let keyboardTransform = CGAffineTransform.identity
            self.nameTextfield.transform = keyboardTransform
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    //复制判断
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existedLength = textField.text?.lengthOfBytes(using: .utf8)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytes(using: .utf8)
        
        let maxLenght: Int = 20
        
        if existedLength! - selectedLength + replaceLength > maxLenght{
            return false
        }
        
        return true
    }
}
