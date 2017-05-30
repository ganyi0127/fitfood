//
//  MainVC.swift
//  FitFood
//
//  Created by YiGan on 17/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
var infoChanged = false
class MainVC: UIViewController {
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var targetView: UIView!
    @IBOutlet var mainView: MainView!
    
    //切换子页面
    var menuItem: MenuItem?{
        didSet{
            
            guard let item = menuItem else {
                return
            }
            
            var identifier: String?
            switch item.menuType {
            case .food:
                identifier = "food"
            case .water:
                identifier = "water"
            case .sport:
                identifier = "sport"
            default:
                break
            }
            
            if let id = identifier{
                self.performSegue(withIdentifier: id, sender: nil)
            }
        }
    }
    
    //子按钮
    private lazy var subButtonList: [MainRecordButton]? = {
        var list = [MainRecordButton]()
        let buttonImageSize = CGSize(width: 48, height: 48)
        (0..<3).forEach{
            i in
            let subButton: MainRecordButton = MainRecordButton(index: i, initFrame: self.mainButton.frame)
            subButton.addTarget(self, action: #selector(self.clickSubMenuButton(sender:)), for: .touchUpInside)
            list.append(subButton)
            self.view.insertSubview(subButton, belowSubview: self.mainButton)
        }
        return list
    }()
    
    //MARK:主按钮状态
    private var isMainButtonOpen = false{
        didSet{
            
            mainButton.isSelected = isMainButtonOpen
            
            //移除之前动画
            let key = "rotation"
            mainButton.layer.removeAnimation(forKey: key)
            
            //创建按钮动画
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            if isMainButtonOpen {
                animation.fromValue = 0
                animation.toValue = Double.pi / 4 + .pi
            }else{
                animation.fromValue = Double.pi / 4 + .pi
                animation.toValue = 0
            }
            animation.duration = 0.2
            animation.repeatCount = 1
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeBoth
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            mainButton.layer.add(animation, forKey: key)
            
            //子按钮操作
            self.subButtonList?.forEach{
                button in
                button.setHidden(flag: !isMainButtonOpen)
            }
            
            //动画
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.effectView.isHidden = !self.isMainButtonOpen
            }, completion: {
                complete in
            })
        }
    }
    
    //毛玻璃
    fileprivate lazy var effectView = { () -> UIVisualEffectView in
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.view.bounds
        effectView.isHidden = true
        return effectView
    }()
    
    //MARK:- 属性
    private var caloriaValue: CGFloat = 0{
        didSet{
            intakeCaloria = caloriaValue
        }
    }
    private var waterValue: CGFloat = 0{
        didSet{
            intakeWater = waterValue
        }
    }
    private var intakeCaloria: CGFloat = 0 {
        didSet{
            mainView.intakeCaloria = intakeCaloria
        }
    }
    private var intakeWater: CGFloat = 0{
        didSet{
            mainView.waters = intakeWater
        }
    }
    
    
    
    
    //MARK:- init ***************************************************************
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        view.layer.cornerRadius = 0
        
        view.bringSubview(toFront: mainButton)
        view.insertSubview(effectView, belowSubview: mainButton)
        
        //刷新
        if infoChanged {
            infoChanged = false
            //千卡
            intakeCaloria = caloriaValue
            //毫升
            intakeWater = waterValue
        }else{
            //千卡
            caloriaValue = 1000
            //毫升
            waterValue = 1500
        }
    }
    
    private func config(){
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 跳转到个人设置页
    func performSegueInformation(){
        performSegue(withIdentifier: "information", sender: nil)
    }
    
    //MARK:- 点击子按钮
    @objc private func clickSubMenuButton(sender: UIButton){
        let tag = sender.tag
        
        //关闭子按钮
        showRecord(mainButton)
        
        menuItem = MenuItem.sharedItems[tag]
    }
    
    //MARK:- 点击展开记录列表
    @IBAction func showRecord(_ sender: Any) {
        isMainButtonOpen = !isMainButtonOpen
    }
    
    @IBAction func showMenu(_ sender: Any) {
        (navigationController?.parent as! InitVC).hideMenu(false)
    }
}


//MARK:- 触摸时间
extension MainVC{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
