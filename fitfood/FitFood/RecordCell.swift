//
//  RecordCell.swift
//  FitFood
//
//  Created by YiGan on 06/06/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class RecordCell: UIView {
    
    //类型
    var recordSubType: RecordSubType!
    
    var value: Any?{
        didSet{
            
            //日期格式
            let format = DateFormatter()
            format.dateFormat = "yyy-M-d h:mm"
            
            //文字
            var detailText = ""
            switch recordSubType as RecordSubType{
            case .foodType:
                var eligibleValue: FoodCategory = FoodCategory.cerealCrop
                if let foodType = value as? FoodCategory{
                    eligibleValue = foodType
                }else if let foodType = RecordSelector.selectedFoodType{
                    eligibleValue = foodType
                }
                detailText = eligibleValue.name()
                RecordTV.foodType = eligibleValue
                RecordSelector.foodSubList = FoodManager.share().getDocument()[eligibleValue]!
            case .foodSubType:
                var eligibleValue: Food? = nil
                if let foodSubType = value as? Food{
                    eligibleValue = foodSubType
                }else if let foodSubType = RecordSelector.selectedSubFoodType{
                    eligibleValue = foodSubType
                }
                detailText = eligibleValue?.name ?? "-"
                RecordTV.foodSubType = eligibleValue
            case .foodAmountG:
                var eligibleValue: Int32 = 1000
                if let foodAmountG = value as? Int32{
                    eligibleValue = foodAmountG
                }
                let amountKG = String(format: "%.1f", CGFloat(eligibleValue) / 1000)
                detailText = "\(amountKG)kg"
                RecordTV.foodAmountG = eligibleValue
            case .foodDate:
                var eligibleValue = Date()
                if let foodDate = value as? Date{
                    eligibleValue = foodDate
                }
                detailText = format.string(from: eligibleValue)
                RecordTV.foodDate = eligibleValue
            case .waterType:
                var eligibleValue: Int32 = 0
                if let waterTypeIndex = value as? Int32{
                    eligibleValue = waterTypeIndex
                }
                let waterType = WaterType(rawValue: eligibleValue)!
                detailText = waterNameMap[waterType]!
                RecordTV.waterType = waterType
            case .waterAmountG:
                var eligibleValue: Int32 = 500
                if let waterAmountG = value as? Int32{
                    eligibleValue = waterAmountG
                }
                detailText = "\(eligibleValue)ml"
                RecordTV.waterAmountG = eligibleValue
            case .waterDate:
                var eligibleValue = Date()
                if let waterDate = value as? Date{
                    eligibleValue = waterDate
                }
                detailText = format.string(from: eligibleValue)
                RecordTV.waterDate = eligibleValue
            case .sportType:
                var eligibleValue = SportType.pushUp
                if let sportType = value as? SportType{
                    eligibleValue = sportType
                }
                detailText = sportNameMap[eligibleValue]!
                RecordTV.sportType = eligibleValue
            case .sportDate:
                var eligibleValue = Date()
                if let sportDate = value as? Date{
                    eligibleValue = sportDate
                }
                RecordTV.sportDate = eligibleValue
                detailText = format.string(from: eligibleValue)
            case .sportDuration:
                var eligibleValue: Int32 = 30
                if let duration = value as? Int32{
                    eligibleValue = duration
                }
                let hour = eligibleValue / (60 * 60)
                let minute = eligibleValue % (60 * 60) / 60
                detailText = "\(hour)小时\(minute)分钟"
                RecordTV.sportDuration = eligibleValue
                
                if let localSportStartDate = RecordTV.sportDate{
                    let constDuration = Int32(Date().timeIntervalSince(localSportStartDate))
                    if constDuration < eligibleValue{
                        detailLabel?.textColor = UIColor.red.withAlphaComponent(0.5)
                    }else{
                        detailLabel?.textColor = word_light_color
                    }
                }
            }
            detailLabel?.text = detailText
            
            selectedClosure?(recordSubType, value)
        }
    }
    
    //回调
    var clickClosure: ((_ type: RecordSubType)->())?
    var selectedClosure: ((_ type: RecordSubType, _ value: Any?)->())?    //当数据为非法eligible == false
    
    //显示cell类型
    private lazy var titleLabel: UILabel? = {
        let labelFrame = CGRect(x: 4, y: 0, width: self.frame.size.width / 2, height: self.frame.size.height)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .left
        label.textColor = word_light_color
        label.font = font_middle
        self.addSubview(label)
        return label
    }()
    
    //显示下拉按钮
    fileprivate lazy var arrowButton: UIButton? = {
        let buttonFrame = CGRect(x: self.frame.width - self.frame.height, y: 0, width: self.frame.height, height: self.frame.height)
        let button: UIButton = UIButton(frame: buttonFrame)
        let img = UIImage(named: "resource/record/arrow")?.transfromImage(size: CGSize(width: self.frame.height / 3, height: self.frame.height / 3))
        button.setImage(img, for: .normal)
        button.addTarget(self, action: #selector(self.click(sender:)), for: .touchUpInside)
        return button
    }()
    
    //显示内容
    private lazy var detailLabel: UILabel? = {
        let labelFrame = CGRect(x: self.frame.width - self.frame.size.width / 2 - self.arrowButton!.frame.width, y: 0, width: self.frame.size.width / 2, height: self.frame.size.height)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .right
        label.textColor = word_light_color
        label.font = font_middle
        label.text = "its detail label"
        return label
    }()
    
    //MARK:- 内容视图
    private var contentView: UIView?
    
    //MARK:- 选择器
    private var recordSelector: RecordSelector?
    
    //MARK:- 展开或收起
    var isOpen = false{
        didSet{
            //移除之前动画
            if isOpen {
                
                //按钮旋转
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = 0
                animation.toValue = Double.pi
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                arrowButton?.layer.add(animation, forKey: nil)
                
                //展开内容
                showContent(true)
                
            }else{
                
                //按钮旋转
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = Double.pi
                animation.toValue = 0
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                arrowButton?.layer.add(animation, forKey: nil)
                
                //关闭内容
                showContent(false)
            }
        }
    }
    
    
    //MARK:- init
    init(with recordSubType: RecordSubType){
        let frame = CGRect(x: 0, y: 0, width: view_size.width - 8 * 2, height: 44)
        super.init(frame: frame)
        
        self.recordSubType = recordSubType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .white
        isUserInteractionEnabled = true
        
        //主文字
        var titleText: String
        switch recordSubType! {
        case .foodType:
            titleText = "食物类型"
        case .foodSubType:
            titleText = "食物名称"
        case .foodAmountG, .waterAmountG:
            titleText = "用量"
        case .foodDate, .waterDate, .sportDate:
            titleText = "时间"
        case .waterType:
            titleText = "类型"
        case .sportType:
            titleText = "运动类型"
        case .sportDuration:
            titleText = "用时"
        default:
            titleText = ""
        }
        titleLabel?.text = titleText
        
        value = nil
    }
    
    private func createContents(){
        
        //手动添加分割线
        let separatorFrame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        let separatorLine = UIView(frame: separatorFrame)
        separatorLine.backgroundColor = word_light_color
        addSubview(separatorLine)
        
        //添加箭头
        addSubview(arrowButton!)
        addSubview(detailLabel!)
    }
    
    //MARK:- 点击按钮响应
    @objc fileprivate func click(sender: UIButton){
        
        clickClosure?(recordSubType)
    }
    
    //MARK:- 是否展开内容视图
    private var contentHeight: CGFloat = 0
    private func showContent(_ flag: Bool){
        if flag{
            
            guard let parent = superview else {
                return
            }
            let otherCellCount = parent.subviews.count - 2
            guard otherCellCount > 0 else {
                return
            }
            contentHeight = parent.frame.height - CGFloat(otherCellCount) * frame.height
            
            let contentFrame = CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight)
            contentView = UIView(frame: contentFrame)
            contentView?.backgroundColor = .white
            contentView?.isUserInteractionEnabled = true
            contentView?.alpha = 0
            addSubview(contentView!)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.contentView?.alpha = 1
            }, completion: nil)
            
            //显示选择器
            if let selector = recordSelector {
                selector.removeFromSuperview()
            }
            recordSelector = RecordSelector(type: recordSubType, frame: contentView!.bounds)
            recordSelector?.alpha = 0
            contentView?.addSubview(recordSelector!)
            recordSelector?.closure = {
                selType, selValue in
                self.value = selValue
            }
            value = recordSelector?.selectedValue
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                self.recordSelector?.alpha = 1
            }, completion: {
                complete in
            })
        }else{
            
            contentHeight = 0
            
            self.recordSelector?.alpha = 0
            self.recordSelector?.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 1)
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.contentView?.alpha = 0
                self.contentView?.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 1)
                
            }, completion: {
                complete in
                self.recordSelector?.removeFromSuperview()
                self.recordSelector = nil
                self.contentView?.removeFromSuperview()
                self.contentView = nil
            })
        }
    }
    
    //MARK:- 重写uiview点击范围
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isOpen{
            if point.x >= 0 && point.x <= frame.width && point.y >= 0 && point.y <= frame.height + contentHeight{
                return true
            }
            return false
        }else{
            if point.x >= 0 && point.x <= frame.width && point.y >= 0 && point.y <= 0 + frame.height{
                return true
            }
            return false
        }
    }
}

//MARK:- 点击事件
extension RecordCell{
    
    //点击结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if recordSubType == .waterAmountG {
            if let touch = touches.first{
                let location = touch.location(in: self)
                let y = location.y
                if y < 44{
                    click(sender: arrowButton!)
                }
            }
        }else{
            click(sender: arrowButton!)
        }
    }
}
