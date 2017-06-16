//
//  RecordSelector.swift
//  FitFood
//
//  Created by YiGan on 08/06/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class RecordSelector: UIView {
    
    //体重整数位
    fileprivate lazy var foodAmountGDataList: [Int32] = {
        var list = [Int32]()
        (0..<20).forEach{
            i in
            list.append(i)
        }
        return list
    }()
    
    //体重小数位
    fileprivate var foodAmountGDotDataList: [Int32]{
        var list = [Int32]()
        (0..<10).forEach{
            i in
            list.append(i)
        }
        return list
    }
    
    fileprivate var type: RecordSubType!
    
    private var datePickerView: UIDatePicker?
    private var pickerView: UIPickerView?
    
    var selectedValue: Any?
    var closure: ((_ type: RecordSubType, _ value: Any?)->())?     //返回是否合法
    
    
    //当前选择的运动类型
    static var selectedFoodType: FoodCategory?
    static var selectedSubFoodType: Food?
    static fileprivate var selectedWaterType: WaterType?
    static fileprivate var selectedSportType: SportCategory?
    
    //MARK:- init **********************************************************************
    init(type: RecordSubType, frame: CGRect){
        super.init(frame: frame)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        isUserInteractionEnabled = true
        
        if type == .sportType{
            sportData = SportManager.share().getDocument()
        }else if type == .foodType || type == .foodSubType{
            fooddata = FoodManager.share().getDocument()
        }
    }
    
    //MARK:- 选择活动类型
    private var collectionView: UICollectionView?
    fileprivate var pageControl: UIPageControl?
    fileprivate var fooddata: FoodData!
    fileprivate var foodPageCount: Int = {
        let count = FoodCategory.allCategory.count
        var pages = count / 9
        if count % 9 != 0 {
            pages += 1
        }
        return pages
    }()
    static var foodSubList = [Food]()
    
    fileprivate var sportData: SportData!
    fileprivate var sportPageCount: Int = {
        let count = SportCategory.allCategory.count
        var pages = count / 9
        if count % 9 != 0 {
            pages += 1
        }
        return pages
    }()
    
    //MARK:- 选择活动强度
    fileprivate var levelImageView: UIImageView?
    fileprivate var levelMask: UIView?
    private func createContents(){
        switch type as RecordSubType {
        case .foodAmountG, .waterType, .foodSubType:
            pickerView = UIPickerView(frame: frame)
            pickerView?.delegate = self
            pickerView?.dataSource = self
            addSubview(pickerView!)
            
            //设置默认值
            if type == .foodAmountG{
                var foodAmountG: Int32 = 1000
                if let localFoodAmountG = RecordTV.foodAmountG {
                    foodAmountG = localFoodAmountG
                }
                
                pickerView?.selectRow(Int(foodAmountG / 1000), inComponent: 0, animated: true)
                pickerView?.selectRow(Int(foodAmountG % 1000 / 100), inComponent: 1, animated: true)
                selectedValue = foodAmountG
                
            }else if type == .waterType {
                var waterTypeIndex: Int32 = 0
                if let index = RecordTV.waterType{
                    waterTypeIndex = index.rawValue
                }
                pickerView?.selectRow(Int(waterTypeIndex), inComponent: 0, animated: true)
                selectedValue = waterTypeIndex
            }else if type == .foodSubType{
                var foodSubTypeIndex: Int = 0
                if let foodSubType = RecordSelector.selectedSubFoodType{
                    for (index, foodSub) in RecordSelector.foodSubList.enumerated(){
                        if foodSub.serial == foodSubType.serial {
                            foodSubTypeIndex = index
                            selectedValue = foodSub
                        }
                    }
                }
                pickerView?.selectRow(foodSubTypeIndex, inComponent: 0, animated: true)
            }
        case .foodType, .sportType:
            //自定义选择器
            let pageContolHeight: CGFloat = 20
            if collectionView == nil{
                let layout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = 4
                layout.minimumLineSpacing = 4
                layout.scrollDirection = .horizontal        //横向移动
                
                let collectionFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height - pageContolHeight)
                collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
                collectionView?.allowsMultipleSelection = false
                collectionView?.delegate = self
                collectionView?.dataSource = self
                if type == .foodType {
                    collectionView?.register(FoodTypeCell.self, forCellWithReuseIdentifier: "custom0")
                }else if type == .foodSubType{
                    collectionView?.register(SubFoodTypeCell.self, forCellWithReuseIdentifier: "custom1")
                }else{
                    collectionView?.register(SportTypeCell.self, forCellWithReuseIdentifier: "custom2")
                }
                collectionView?.isPagingEnabled = true
                collectionView?.showsVerticalScrollIndicator = false
                collectionView?.showsHorizontalScrollIndicator = false
                collectionView?.backgroundColor = .white
                collectionView?.allowsSelection = true
                addSubview(collectionView!)
            }
            
            if type == .sportType{
                selectedValue = RecordTV.sportType
            }else if type == .foodType{
                selectedValue = RecordTV.foodType
            }
            
            if pageControl == nil{
                let pageControlFrame = CGRect(x: 0, y: frame.height - pageContolHeight, width: frame.width, height: pageContolHeight)
                pageControl = UIPageControl(frame: pageControlFrame)
                pageControl?.currentPage = 0
                pageControl?.numberOfPages = type == .foodType ? foodPageCount : sportPageCount
                pageControl?.currentPageIndicatorTintColor = .gray
                pageControl?.pageIndicatorTintColor = word_light_color
                addSubview(pageControl!)
            }
        case .waterAmountG:
            //自定义选择器
            let length: CGFloat = min(self.bounds.width, self.bounds.height) * 0.7
            let imageFrame = CGRect(x: (self.bounds.width - length) / 2, y: (self.bounds.height - length) / 2, width: length, height: length)
            
            let backImageView = UIImageView(frame: imageFrame)
            backImageView.backgroundColor = .white
            backImageView.tintColor = word_light_color
            addSubview(backImageView)
            
            //backImageView.isUserInteractionEnabled = true
            
            if levelImageView == nil{
                levelImageView = UIImageView(frame: imageFrame)
                levelImageView?.isUserInteractionEnabled = true
                levelImageView?.backgroundColor = .white
                levelImageView?.tintColor = word_light_color
                addSubview(levelImageView!)
                
                //添加蒙版
                var sportLevel: CGFloat = 0.2
                if let amountG = RecordTV.waterAmountG{
                    sportLevel = CGFloat(amountG) / CGFloat(maxWaterAmountG)
                }
                drawWaterAmountG(withProgressValue: sportLevel)
            }
            
            selectedValue = waterAmountG
            
            //设置为强度背景
            if let waterType = RecordSelector.selectedWaterType{
                let name = "\(waterType)"
                let length: CGFloat = min(levelImageView!.bounds.width, levelImageView!.bounds.height) * 0.8
                levelImageView?.image = UIImage(named: "resource/sporticons/bigicon/" + name)?.transfromImage(size: CGSize(width: length, height: length))?.withRenderingMode(.alwaysTemplate)
                backImageView.image = UIImage(named: "resource/sporticons/bigicon/" + name)?.transfromImage(size: CGSize(width: length, height: length))?.withRenderingMode(.alwaysTemplate)

            }
        case .foodDate, .waterDate, .sportDate:
            datePickerView = UIDatePicker(frame: frame)
            datePickerView?.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
            datePickerView?.datePickerMode = .dateAndTime
            datePickerView?.maximumDate = Date()
            datePickerView?.minimumDate = Date(timeInterval: -1 * 60 * 60 * 24, since: Date()) //1天前
            addSubview(datePickerView!)
            
            var date = Date()
            if type == .foodDate{
                if let localFoodDate = RecordTV.foodDate{
                    date = localFoodDate
                }
            }else if type == .waterDate{

                if let localWaterDate = RecordTV.waterDate{
                    date = localWaterDate
                }
            }else if type == .sportDate{
                if let localSportDate = RecordTV.sportDate{
                    date = localSportDate
                }
            }
            datePickerView?.setDate(date, animated: true)
            
            selectedValue = date
        case .sportDuration:
            datePickerView = UIDatePicker(frame: frame)
            datePickerView?.datePickerMode = .countDownTimer
            datePickerView?.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
            addSubview(datePickerView!)
            
            var countDownDuration: Int32 = 60
            if let localSportDuration = RecordTV.sportDuration{
                countDownDuration = localSportDuration
            }
            if let localSportStartDate = RecordTV.sportDate{
                let duration = Int32(Date().timeIntervalSince(localSportStartDate))
                if duration < countDownDuration{
                    countDownDuration = duration
                }
            }

            datePickerView?.countDownDuration = TimeInterval(countDownDuration)
            selectedValue = countDownDuration

        default:
            break
        }
    }
    
    //MARK:- 日期选择器回调
    @objc private func selectDate(sender: UIDatePicker){
        switch type as RecordSubType {
        case .sportDuration:
            closure?(type, sender.countDownDuration)
        default:
            closure?(type, sender.date)
        }
    }
    
    //MARK:- 饮水量绘制 0~1
    private var levelMaskView: UIView?
    fileprivate let maxWaterAmountG: Int32 = 5000       //5000毫升
    fileprivate var waterAmountG: Int32?                //0..<max
    fileprivate let progressTopHeight: CGFloat = 20
    fileprivate let progressBottomHeight: CGFloat = 20
    fileprivate func drawWaterAmountG(withProgressValue progressValue: CGFloat){
        
        //绘制
        if levelMaskView == nil {
            levelMaskView = UIView(frame: levelImageView!.bounds)
            levelMaskView?.backgroundColor = .white
            addSubview(levelMaskView!)
            levelImageView?.mask = levelMaskView
        }
        
        var value = Double(progressValue)
        if value > 1{
            value = 1
        }else if value < 0{
            value = 0
        }
        
        waterAmountG = Int32(lround(Double(maxWaterAmountG) * value))
        
        //动画
        let moveAnim = CABasicAnimation(keyPath: "position.y")
        moveAnim.toValue = ((levelImageView!.bounds.height - progressTopHeight - progressBottomHeight) * CGFloat(1 - value) - progressBottomHeight) + levelImageView!.bounds.height / 2
        moveAnim.duration = 1.5
        moveAnim.fillMode = kCAFillModeBoth
        moveAnim.isRemovedOnCompletion = false
        levelMaskView?.layer.add(moveAnim, forKey: nil)
    }
}

//MARK:- 触摸事件
extension RecordSelector{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == RecordSubType.waterAmountG, let touch = touches.first, let imageView = levelImageView {
            let curLocation = touch.location(in: imageView)
            
            let currentProgressValue = (imageView.bounds.height - (curLocation.y - progressTopHeight)) / (imageView.bounds.height - progressTopHeight - progressBottomHeight)
            drawWaterAmountG(withProgressValue: currentProgressValue)
            
            if let amountG = waterAmountG, RecordSelector.selectedWaterType != nil {
                closure?(RecordSubType.waterAmountG, amountG)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == RecordSubType.waterAmountG, let amountG = waterAmountG, RecordSelector.selectedWaterType != nil {
            closure?(RecordSubType.waterAmountG, amountG)
        }
    }
}

//MARK:- picker选择器回调
extension RecordSelector: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type as RecordSubType {
        case .foodAmountG:
            return 3
        case .waterType:
            return 1
        case .foodSubType:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type as RecordSubType {
        case .foodAmountG:
            if component == 0 {
                return foodAmountGDataList.count
            }else if component == 1{
                return foodAmountGDotDataList.count
            }
            return 1
        case .waterType:
            return waterNameMap.count
        case .foodSubType:
            return RecordSelector.foodSubList.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        switch type as RecordSubType {
        case .foodAmountG:
            return frame.width / 3
        default:
            return frame.width
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type as RecordSubType {
        case .foodAmountG:
            switch component {
            case 0:
                return "\(foodAmountGDataList[row])"
            case 1:
                return ".\(foodAmountGDotDataList[row])"
            default:
                return "kg"
            }
        case .waterType:
            let type = WaterType(rawValue: Int32(row))!
            return waterNameMap[type]
        case .foodSubType:
            return RecordSelector.foodSubList[row].name
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch type as RecordSubType {
        case .waterType:
            selectedValue = Int32(row)
            RecordSelector.selectedWaterType = WaterType(rawValue: Int32(row))
        case .foodAmountG:
            
            let row0 = pickerView.selectedRow(inComponent: 0)   //整数位
            let row1 = pickerView.selectedRow(inComponent: 1)   //小数位
            
            selectedValue = foodAmountGDataList[row0] * 1000 + foodAmountGDotDataList[row1] * 100
        case .foodSubType:
            if row < RecordSelector.foodSubList.count{
                let food = RecordSelector.foodSubList[row]
                selectedValue = food
                RecordSelector.selectedSubFoodType = food
            }
        default:
            selectedValue = nil
        }
        closure?(type, selectedValue)
    }
}

//Collection delegate
extension RecordSelector: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type as RecordSubType {
        case .foodType:
            return FoodCategory.allCategory.count
        case .sportType:
            return SportCategory.allCategory.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        switch type as RecordSubType {
        case .foodType:
            let identifier = "custom0"
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FoodTypeCell
            
            if row >= FoodCategory.allCategory.count{
                cell.category = nil
                return cell
            }
            
            cell.category = FoodCategory.allCategory[row]
            return cell
        default:
            let identifier = "custom2"
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SportTypeCell
            
            if row >= SportCategory.allCategory.count{
                cell.type = nil
                return cell
            }
            
            cell.type = SportCategory(rawValue: Int32(row))
            return cell
        }
    }
    
    //获取记录
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch type as RecordSubType {
        case .foodType:
            if let localFoodType = RecordTV.foodType{
                if localFoodType == (cell as! FoodTypeCell).category{
                    cell.isSelected = true
                }
            }
        default:
            if let localSportType = RecordTV.sportType{
                if localSportType == (cell as! SportTypeCell).type{
                    cell.isSelected = true
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(ceil(Double(scrollView.contentOffset.x / frame.width)))
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //返回等同于窗口大小的尺寸
        return CGSize(width: frame.width / 3, height: (frame.height - 20) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //delegate
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let row = indexPath.row
        if row >= (type == .sportType ? SportCategory.allCategory.count : FoodCategory.allCategory.count) {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        switch type as RecordSubType {
        case .foodType:
            if row < FoodCategory.allCategory.count{
                //选择回调
                let cell = collectionView.cellForItem(at: indexPath) as! FoodTypeCell
                RecordSelector.selectedFoodType = cell.category
                RecordSelector.selectedSubFoodType = nil
                RecordTV.foodSubType = nil
                RecordSelector.foodSubList.removeAll()
                RecordSelector.foodSubList.append(contentsOf: fooddata[cell.category!]!)
                if let cellType = cell.category{
                    closure?(type, cellType)
                }
                collectionView.reloadData()
            }
        default:
            if row < SportCategory.allCategory.count{
                //选择回调
                let cell = collectionView.cellForItem(at: indexPath) as! SportTypeCell
                RecordSelector.selectedSportType = cell.type
                if let cellType = cell.type{                    
                    closure?(type, cellType)
                }
                collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
