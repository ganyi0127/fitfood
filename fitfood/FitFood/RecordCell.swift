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
                if let foodType = value as? Int32{
                    detailText = "\(foodType)"
                }else{
                    detailText = "-"
                }
            case .foodSubType:
                if let foodSubType = value as? Int32{
                    detailText = "\(foodSubType)"
                }else{
                    detailText = "-"
                }
            case .foodAmountG:
                if let foodAmountG = value as? CGFloat{
                    detailText = "\(foodAmountG)kg"
                }else{
                    detailText = "-"
                }
            case .foodDate:
                if let foodDate = value as? Date{
                    detailText = format.string(from: foodDate)
                }else{
                    let defaultDate = Date()
                    RecordTV.sportDate = defaultDate
                    detailText = format.string(from: defaultDate)
                }
            case .waterType:
                if let waterTypeIndex = value as? Int{
                    let waterType = WaterType(rawValue: waterTypeIndex)!
                    detailText = waterNameMap[waterType]!
                }else{
                    detailText = "-"
                }
            case .waterAmountG:
                if let waterAmountG = value as? Int32{
                    detailText = "\(waterAmountG)ml"
                }else{
                    detailText = "-"
                }
            case .waterDate:
                if let waterDate = value as? Date{
                    detailText = format.string(from: waterDate)
                }else{
                    let defaultDate = Date()
                    RecordTV.sportDate = defaultDate
                    detailText = format.string(from: defaultDate)
                }
            case .sportType:
                if let sportType = value as? SportType{
                    detailText = sportNameMap[sportType]!
                }else{
                    detailText = "-"
                }
            case .sportDate:
                if let sportDate = value as? Date{
                    detailText = format.string(from: sportDate)
                }else{
                    let defaultDate = Date()
                    RecordTV.sportDate = defaultDate
                    detailText = format.string(from: defaultDate)
                }
            case .sportDuration:
                if let duration = value as? TimeInterval{
                    let hour = Int(duration) / (60 * 60)
                    let minute = (Int(duration) - hour * 60 * 60) / 60
                    detailText = "\(hour)小时\(minute)分钟"
                    
                    if let localSportStartDate = RecordTV.sportDate{
                        let constDuration = Date().timeIntervalSince(localSportStartDate)
                        if constDuration < duration{
                            detailLabel?.textColor = UIColor.red.withAlphaComponent(0.5)
                        }else{
                            detailLabel?.textColor = word_default_color
                        }
                    }
                }else{
                    detailText = "-"
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
