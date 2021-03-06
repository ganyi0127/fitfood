//
//  Selector.swift
//  FitFood
//
//  Created by YiGan on 26/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
enum SelectorType {
    case birthday
    case date
}
private let selectorSize = CGSize(width: view_size.width - 20 * 2, height: 256)
class Selector: UIView {
    
    private var selectorType: SelectorType!
    private var closure: ((_ accepted: Bool, _ value: Any?)->())?
    private var value: Any?
    
    private let cornerRadius: CGFloat = 15
    
    private var datePickerView: UIDatePicker?
    
    //MARK:- init********************************************************************************
    private static let __once = Selector()
    class var `default`: Selector{
        return __once
    }
    
    private init(){
        let frame = CGRect(x: (view_size.width - selectorSize.width) / 2, y: view_size.height, width: selectorSize.width, height: selectorSize.height)
        super.init(frame: frame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        backgroundColor = .clear
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        let proportion =  38 / Float(selectorSize.height)
        let startLocation = NSNumber(value: proportion)
        let endLocation = NSNumber(value: proportion)
        gradient.locations = [startLocation, endLocation]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        gradient.cornerRadius = cornerRadius
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowOffset = CGSize(width: 0, height: 0)
        gradient.shadowOpacity = 0.5
        gradient.shadowRadius = 5
        layer.addSublayer(gradient)
    }
    
    private func createContents(){
        
        //添加放弃按钮
        let refuseButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 38))
        refuseButton.setTitle("cancel", for: .normal)
        refuseButton.setTitleColor(.gray, for: .normal)
        refuseButton.setTitleColor(.lightGray, for: .selected)
        refuseButton.addTarget(self, action: #selector(refuse(sender:)), for: .touchUpInside)
        addSubview(refuseButton)
        
        let acceptButton = UIButton(frame: CGRect(x: selectorSize.width - 64, y: 0, width: 64, height: 38))
        acceptButton.setTitle("done", for: .normal)
        acceptButton.setTitleColor(.gray, for: .normal)
        acceptButton.setTitleColor(.lightGray, for: .selected)
        acceptButton.addTarget(self, action: #selector(accept(sender:)), for: .touchUpInside)
        addSubview(acceptButton)
        
    }
    
    //MARK:- 取消
    @objc private func refuse(sender: Any){
        closure?(false, nil)
        hidden()
    }
    
    //MARK:- 同意
    @objc private func accept(sender: Any){
        closure?(true, value)
        hidden()
    }
    
    //MARK:- 创建选择器内容
    private func createSelectorContents(){
        clearSelectorContents()
        
        let type = selectorType as SelectorType
        switch type {
        case .birthday, .date:
            let datePickerFrame = CGRect(x: 0, y: 38, width: bounds.width, height: bounds.height - 38)
            datePickerView = UIDatePicker(frame: datePickerFrame)
            datePickerView?.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
            
            if type == .birthday {
                datePickerView?.datePickerMode = .date
                datePickerView?.maximumDate = Date()
                datePickerView?.minimumDate = Date(timeIntervalSinceNow: -80 * 360 * 60 * 60 * 24)     //80年前
                
                var defaultDate = Date(timeInterval: -25 * 360 * 60 * 60 * 24, since: Date())
                if let birthday = user.birthday as Date?{
                    defaultDate = birthday
                }                
                datePickerView?.date = defaultDate
                value = defaultDate
                datePickerView?.setDate(defaultDate, animated: true)
            }else if type == .date{
                datePickerView?.datePickerMode = .date
            }
            addSubview(datePickerView!)
        default:
            break
        }
    }
    
    //MARK:- 清除已有选择器内容
    private func clearSelectorContents(){
        datePickerView?.removeFromSuperview()
        datePickerView = nil
    }
    
    //MARK:- 日期选择器回调
    @objc private func selectDate(sender: UIDatePicker){
        switch selectorType as SelectorType {
        case .birthday, .date:
            value = sender.date
        default:
            break
        }
    }
    
    //MARK:- 显示
    func show(with selectorType: SelectorType, closure: ((_ accepted: Bool, _ value: Any?)->())?){
        
        if superview != nil{
            self.removeFromSuperview()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.frame.origin.y = view_size.height
                self.alpha = 0.5
            }, completion: {
                complete in
                
                self.showAnim(with: selectorType, closure: closure)
            })
            return
        }
        
        showAnim(with: selectorType, closure: closure)
    }
    
    private func showAnim(with selectorType: SelectorType, closure: ((_ accepted: Bool, _ value: Any?)->())?){
        self.closure = closure
        self.selectorType = selectorType
        
        alpha = 0.5
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.frame.origin.y = view_size.height - selectorSize.height - 20
            self.alpha = 1
        }, completion: {
            complete in
            self.createSelectorContents()
        })
    }
    
    //MARK:- 隐藏
    func hidden(){
        closure?(false, nil)
        closure = nil
        value = nil
        
        clearSelectorContents()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.frame.origin.y = view_size.height
            self.alpha = 0.5
        }, completion: {
            complete in
            if self.superview != nil{
                self.removeFromSuperview()
            }
        })
    }
}
