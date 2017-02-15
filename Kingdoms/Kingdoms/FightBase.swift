//
//  FightBase.swift
//  Kingdoms
//
//  Created by YiGan on 25/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import SpriteKit
class FightBase: SKSpriteNode {
    
    fileprivate var rowCount: Int!
    fileprivate var lineCount: Int!
    
    //touch
    enum Direction{
        case up
        case down
        case left
        case right
    }
    fileprivate var direction: Direction?
    fileprivate var startIndexpath: (row: Int, line: Int)?                  //开始点位置
    fileprivate var endIndexpath: (row: Int, line: Int)? {                  //结束点位置
        didSet{
            guard let staIdxPth = startIndexpath, let endIdxPth = endIndexpath else {
                return
            }
            
            //判断start, end是否合法交换
            guard staIdxPth != endIdxPth else {
                return
            }
            
            //判断是否为上下交换
            guard staIdxPth.row == endIdxPth.row || staIdxPth.line == endIdxPth.line else {
                return
            }
            
            guard !isLocked else {
                return
            }
            
            isLocked = true
            
            //获取start方块
            guard let startCube = cubeList.filter({$0.coordinate == staIdxPth}).first else{
                return
            }
            
            //获取end方块
            guard let endCube = cubeList.filter({$0.coordinate == endIdxPth}).first else{
                return
            }
            
            startIndexpath = nil
            startCube.coordinate = endIdxPth
            endCube.coordinate = staIdxPth
            
            //操作后重置
            _ = delay(move_time){
                self.initMatrix{
                    count in
                    debugPrint(count)
                    self.isLocked = false
                    
                    //判断操作是否有效
                    if count == 0 {
                        startCube.coordinate = staIdxPth
                        endCube.coordinate = endIdxPth
                    }
                }
            }
        }
    }
    
    //存储所有cube
    fileprivate var cubeList = Set<FightCube>()
    
    //存储隐藏状态
    var isBaseHidden = false
    
    //存储移动状态
    fileprivate var isLocked = false
    
    //MARK:- init
    init(rowCount: Int, lineCount: Int){
        super.init(texture: nil, color: .clear, size: matrix_size)
        
        //计算cube尺寸
        cube_size = CGSize(width: matrix_size.width / CGFloat(lineCount), height: matrix_size.height / CGFloat(rowCount))
        
        //存储row, line
        self.rowCount = rowCount
        self.lineCount = lineCount
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        position = CGPoint(x: 0, y: matrix_size.height / 2 - scene_size.height / 2)
        isUserInteractionEnabled = true
    }
    
    private func createContents(){
        
        initMatrix{_ in }
    }
    
    //MARK:- 隐藏整个页面
    func hidden(_ flag: Bool){
        
        guard !isLocked else {
            return
        }
        
        isBaseHidden = flag
        
        if flag {
            cubeList.enumerated().forEach{
                offset, cube in
                cube.removeAllActions()
                let moveAct = SKAction.moveTo(y: -matrix_size.height * 0.6, duration: TimeInterval(cubeList.count - offset) * 0.01)
                moveAct.timingMode = .easeOut
                cube.run(moveAct)
            }
        }else{
            cubeList.forEach{$0.removeAllActions()}
            initMatrix{_ in }
        }
    }
    
    //MARK:- 生成矩阵
    fileprivate func initMatrix(closure: @escaping (Int)->()){
        
        //判断是否产生新cube
        var hasNewcube = false
        
        (0..<rowCount).forEach{
            row in
            (0..<lineCount).forEach{
                line in
                
                let curRow = rowCount - 1 - row
                var reverseRow = curRow
                var cube = getCube(fromCoordinate: reverseRow, line: line)
                //当cube不存在时，往上查找
                while cube == nil{
                    
                    reverseRow -= 1
                    if reverseRow < 0{
                        
                        hasNewcube = true
                        
                        let cubeRaw = Int(arc4random_uniform(4)) + 1
                        let cubeType = FightCubeType(rawValue: cubeRaw)!
                        cube = FightCube(cubeType)
                        let posX = CGFloat(line) * cube_size!.width + cube_size!.width / 2 - matrix_size.width / 2
                        let posY = matrix_size.width / 2 + cube_size!.height / 2
                        cube?.position = CGPoint(x: posX, y: posY)
                        cubeList.insert(cube!)
                        addChild(cube!)
                        cube?.coordinate = (row: curRow, line: line)
                    }else{
                        cube = getCube(fromCoordinate: reverseRow, line: line)
                    }
                }
                cube?.coordinate = (row: curRow, line: line)
            }
        }
        
        var deleteCount = 0
        _ = delay(hasNewcube ? move_time : 0){
            self.checkMatrix{
                count in
                
                deleteCount += count
                if count > 0{
                    //判断每轮消除个数
                    debugPrint("sub:", count)

                    self.initMatrix{
                        c in
                        deleteCount += c
                        closure(deleteCount)
                    }
                }else{
                    closure(0)
                }
            }
        }
    }
    
    //MARK:- 检测矩阵是否可消除
    private func checkMatrix(closure: (Int)->()){
        
        //生成删除列表
        var deleteList = Set<FightCube>()
        
        //遍历
        (0..<rowCount).forEach{
            row in
            (0..<lineCount).forEach{
                line in
                
                //判断并获取当前cube
                if var cube = getCube(fromCoordinate: row, line: line) {
                    
                    //当cubetype不为特殊类型的情况下，查找
                    let curType = cube.type
                    if curType != .special{
                        let originCube = cube
                        
                        //下
                        var nextRow = row
                        
                        var tempList = Set<FightCube>()
                        repeat{
                            tempList.insert(cube)
                            nextRow += 1
                            if let nextCube = getCube(fromCoordinate: nextRow, line: line){
                                cube = nextCube
                            }else{
                                break
                            }
                        }while curType == cube.type
                        
                        //超过2个进入删除列表
                        if let tuple = decideDeleteCount(fromTemplist: tempList, unionDelete: !deleteList.intersection(tempList).isEmpty){
                            if let first = tuple.specialCube{
                                deleteList.remove(first)
                            }
                            deleteList = deleteList.union(tuple.deleteList)
                        }
                        
                        //右
                        cube = originCube
                        var nextLine = line
                        
                        tempList.removeAll()
                        repeat{
                            tempList.insert(cube)
                            nextLine += 1
                            if let nextCube = getCube(fromCoordinate: row, line: nextLine){
                                cube = nextCube
                            }else{
                                break
                            }
                        }while curType == cube.type
                        
                        //超过2个进入删除列表
                        if let tuple = decideDeleteCount(fromTemplist: tempList, unionDelete: !deleteList.intersection(tempList).isEmpty){
                            if let first = tuple.specialCube{
                                deleteList.remove(first)
                            }
                            deleteList = deleteList.union(tuple.deleteList)
                        }
                    }
                }
            }
        }

        //从列表中移除cubes
        cubeList = cubeList.subtracting(deleteList)
        deleteList.forEach{$0.removeFromParent()}
        
        //回调数量
        closure(deleteList.count)
    }
    
    //MARK:- 判断消除个数并返回消除数组
    private func decideDeleteCount(fromTemplist templist: Set<FightCube>, unionDelete: Bool) -> (deleteList: Set<FightCube>, specialCube: FightCube?)?{
        var temp = templist
        guard temp.count > 2 else {
            return nil
        }
        
        if unionDelete {
            
            //判断单次消除个数
            let first = temp.removeFirst()
            first.type = .special
            return (temp, first)
        }else{
            //***此处发送消除消息***
            let powerList = temp.filter{$0.isPower}
            let isPower = powerList.isEmpty ? false : true
            let userInfo = ["type": temp.first!.type!,
                            "power" : isPower,
                            "count": temp.count > 5 ? 5 : temp.count] as [String : Any]
            notify_manager.post(name: notify_cubes, object: nil, userInfo: userInfo)
            
            //判断单次消除个数
            if temp.count == 4{
                temp.removeFirst().isPower = true
            }else if temp.count > 4{
                temp.removeFirst().type = .special
            }
            return (temp, nil)
        }
    }
    
    //MARK:- 根据坐标获取cube
    private func getCube(fromCoordinate row: Int, line: Int) -> FightCube?{
        let list = cubeList.filter{$0.coordinate == (row: row, line: line)}
        guard list.isEmpty else {
            let firstCube = list[0]
            if firstCube.isMarked {
                return nil
            }
            return firstCube
        }
        return nil
    }
}

//MARK:- touch
extension FightBase{
    
    //MARK:- 根据位置获取坐标
    private func getCoordinate(fromLocation location: CGPoint) -> (row: Int, line: Int)?{
        //let loc = convert(location, from: parent!)
        let row = Int(-location.y + matrix_size.height / 2) / Int(cube_size!.height)
        let line = Int(location.x + matrix_size.width / 2) / Int(cube_size!.width)
        guard row >= 0, row < rowCount, line >= 0, line < lineCount else {
            return nil
        }
        return (row: row, line: line)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard event?.allTouches?.count == 1 else {
            return
        }
        
        guard touches.count == 1 else {
            return
        }
        
        guard let touch = touches.first else {
            return
        }

        guard touch.tapCount == 1 else {
            return
        }
        
        let location = touch.location(in: self)
        startIndexpath = getCoordinate(fromLocation: location)      //存储开始点
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard event?.allTouches?.count == 1 else {
            return
        }
        
        guard touches.count == 1 else {
            return
        }
        
        guard let touch = touches.first else {
            return
        }

        guard touch.tapCount == 1 else {
            return
        }
        
        let curLocation = touch.location(in: self)
        let preLocation = touch.previousLocation(in: self)
        
        let deltaX = preLocation.x - curLocation.x
        let deltaY = preLocation.y - curLocation.y
        
        //判定滑动方向
        if fabs(deltaX) > fabs(deltaY){
            //横滑
            if deltaX > 0{
                direction = .right
            }else{
                direction = .left
            }
        }else{
            //竖滑
            if deltaY > 0{
                direction = .up
            }else{
                direction = .down
            }
        }
        
        //判断结束点位置
        endIndexpath = getCoordinate(fromLocation: curLocation)     //存储结束点
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard event?.allTouches?.count == 1 else {
            return
        }
        
        guard let touch = touches.first else {
            return
        }
        
        guard touch.tapCount == 1 else {
            return
        }
        
        //判断是否点击super cube
        let location = touch.location(in: self)
        let indexpath = getCoordinate(fromLocation: location)
        
        if let staIdxPth = startIndexpath, let idxPth = indexpath {
            if staIdxPth == idxPth {
                
                //获取super cube
                guard let cube = cubeList.filter({$0.coordinate == idxPth}).first, cube.type == .special else{
                    return
                }

                cube.removeFromParent()
                cubeList.remove(cube)
                
                //***此处发送消除消息***
                let userInfo = ["type": FightCubeType.special,
                                "power" : false,
                                "count": 1] as [String : Any]
                notify_manager.post(name: notify_cubes, object: nil, userInfo: userInfo)
                
                //操作后重置
                _ = delay(move_time){
                    self.initMatrix{
                        count in
                        debugPrint(count)
                        self.isLocked = false
                    }
                }
            }
        }
        
        //滑动结束调用
        startIndexpath = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard event?.allTouches?.count == 1 else {
            return
        }
        
        guard let touch = touches.first else {
            return
        }
        
        guard touch.tapCount == 1 else {
            return
        }
        
        //滑动结束调用
        startIndexpath = nil
    }
}
