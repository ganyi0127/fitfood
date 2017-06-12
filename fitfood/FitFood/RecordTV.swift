//
//  RecordTV.swift
//  FitFood
//
//  Created by YiGan on 06/06/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
//MARK:-记录类型
enum RecordType{
    case food
    case water
    case sport
}
//MARK:-记录子属性
enum RecordSubType {
    case foodType
    case foodSubType
    case foodAmountG
    case foodDate
    
    case waterType
    case waterAmountG
    case waterDate
    
    case sportType
    case sportDate
    case sportDuration
}

//MARK:-配置自定义滑块
let recordAttributeMap: [RecordType: [RecordSubType]] = [
    .food: [.foodType, .foodSubType, .foodAmountG, .foodDate],
    .water: [.waterType, .waterAmountG, .waterDate],
    .sport: [.sportType, .sportDate, .sportDuration]
]

//MARK:-运动类型
enum SportType: Int{
    case setUp = 0
    case pushUp
    case running
    case walking
}
let sportNameMap: [SportType: String] = [
    .setUp: "set up",
    .pushUp: "push up",
    .running: "running",
    .walking: "walking"
]

//MARK:-水份类型
enum WaterType: Int{
    case juice = 0
    case energyDrink
    case tea
    case coffee
}
let waterNameMap: [WaterType: String] = [
    .juice: "juice",
    .energyDrink: "energy drink",
    .tea: "tea",
    .coffee: "coffee"
]

class RecordTV: UIView {
    
    let openOriginY: CGFloat = 64 + 8                   //展开Y轴位置
    let closeOriginY = view_size.height * 0.5           //收起Y轴位置
    
    //MARK:- 类型
    private var type: RecordType!
    
    //MARK:- 存储需显示的数据名称列表
    private var attributeList: [RecordSubType]?
    private var subCells = [RecordCell]()
    
    //MARK:- footer
    var header: RecordHeader?
    private var footer: RecordFooter?
    
    //是否展开
    var openClosure: ((_ type: RecordType, _ isOpen: Bool)->())?
    var isOpen = false {
        didSet{
            openClosure?(type, isOpen)
            //重新排列cell位置
            var signIndex: Int?
            self.subCells.enumerated().forEach{
                index, cell in
                
                if signIndex == nil{
                    
                    //判断是否有已点击的cell，标记之后，以下cell从底部开始排列
                    if let selType = self.selectedSubType{
                        if selType == cell.recordSubType{
                            signIndex = index
                            cell.isOpen = true
                        }else{
                            cell.isOpen = false
                        }
                    }else{
                        cell.isOpen = false
                    }
                    
                    //正序
                    cell.frame.origin.y = cell.frame.height * CGFloat(index)
                }else{
                    //反序
                    cell.isOpen = false
                    cell.frame.origin.y = self.frame.height - cell.frame.height * CGFloat(self.subCells.count - index)
                }
            }
            //动画
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                
                //self移动到顶部
                self.frame.origin.y = self.isOpen ? self.openOriginY : self.closeOriginY
                
                //隐藏头部
                self.header?.alpha = self.isOpen ? 0 : 1
                
                
                //footer移动到底部
                let lastCell = self.subCells.last!
                self.footer?.frame.origin.y = lastCell.frame.origin.y + lastCell.frame.height - 1
                
            }, completion: {
                complete in
                
                
            })
        }
    }
    
    //存储当前选择的subType
    private var selectedSubType: RecordSubType?
    
    //MARK:-需存储的数据
    static var foodType: Int32?
    static var foodSubType: Int32?
    static var foodAmountG: Int32?
    static var foodDate: Date?
    
    static var waterType: Int?
    static var waterAmountG: Int32?
    static var waterDate: Date?
    
    static var sportType: SportType?
    static var sportDate: Date?
    static var sportDuration: TimeInterval?
    
    //MARK:- init ************************************************************************************
    init(withRecordType type: RecordType) {
        
        let frame = CGRect(x: 8, y: closeOriginY, width: view_size.width - 8 * 2, height: view_size.height - openOriginY - 16)
        super.init(frame: frame)
        
        //存储类型
        self.type = type
        
        config()
        createContents()
    }
    
    override func didMoveToSuperview() {
        isOpen = false
    }
    
    deinit {
        cancel(task)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private var task: Task?     //记录展开的定时器
    private func createContents(){
        
        guard let t = type else {
            return
        }
        
        //添加属性
        guard let attributeList = recordAttributeMap[t] else{
            return
        }
        
        //添加cell
        attributeList.enumerated().forEach{
            index, attribute in
            
            let recordTableViewCell = RecordCell(with: attribute)
            recordTableViewCell.frame.origin.y = recordTableViewCell.frame.height * CGFloat(index)
            subCells.append(recordTableViewCell)
            addSubview(recordTableViewCell)
            
            //设置点击回调
            recordTableViewCell.clickClosure = {
                recordSubType in
                
                if let selSubType = self.selectedSubType{   //当前已展开
                    
                    self.selectedSubType = nil
                    
                    if selSubType == recordSubType{
                        self.isOpen = false
                    }else{
                        self.isOpen = false
                        
                        //再次展开
                        cancel(self.task)
                        self.task = delay(0.3){
                            self.selectedSubType = recordSubType
                            self.isOpen = true
                        }
                    }
                }else{                                      //当前未展开
                    self.selectedSubType = recordSubType
                    self.isOpen = true
                }
            }
            
            //设置选择回调
            recordTableViewCell.selectedClosure = {
                cellType, value in
                
                switch cellType as RecordSubType{
                case .foodType:
                    if let foodType = value as? Int32{
                        RecordTV.foodType = foodType
                    }
                case .foodSubType:
                    if let foodSubType = value as? Int32{
                        RecordTV.foodSubType = foodSubType
                    }
                case .foodAmountG:
                    if let foodAmountG = value as? Int32{
                        RecordTV.foodAmountG = foodAmountG
                    }
                case .foodDate:
                    if let date = value as? Date{
                        self.header?.leftDate = date
                        RecordTV.foodDate = date
                    }else{
                        let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                        RecordTV.sportDate = defaultDate
                        self.header?.leftDate = defaultDate
                    }
                case .waterType:
                    if let waterType = value as? Int{
                        RecordTV.waterType = waterType
                    }
                case .waterAmountG:
                    if let waterAmountG = value as? Int32{
                        RecordTV.waterAmountG = waterAmountG
                    }
                case .waterDate:
                    if let date = value as? Date{
                        self.header?.leftDate = date
                        RecordTV.waterDate = date
                    }else{
                        let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                        self.header?.leftDate = defaultDate
                        RecordTV.waterDate = defaultDate
                    }
                case .sportType:
                    if let sportType = value as? SportType{
                        RecordTV.sportType = sportType
                    }
                case .sportDate:
                    if let date = value as? Date{
                        self.header?.rightDate = date
                        RecordTV.sportDate = date
                    }else{
                        let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                        self.header?.rightDate = defaultDate
                        RecordTV.sportDate = defaultDate
                    }
                case .sportDuration:
                    if let duration = value as? TimeInterval, let header = self.header{
                        self.header?.rightDate = Date(timeInterval: duration, since: header.leftDate)
                        RecordTV.sportDuration = duration
                    }
                default:
                    break
                }
            }
        }
        
        //添加头部
        header = RecordHeader(type: type!)
        addSubview(header!)
        
        //添加尾部
        footer = RecordFooter(originY: CGFloat(attributeList.count) * 44 - 1)
        addSubview(footer!)
    }
}
