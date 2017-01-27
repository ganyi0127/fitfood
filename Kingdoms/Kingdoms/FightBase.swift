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
            
            checkMatrix(){
                count in
                debugPrint(count)
            }
        }
    }
    
    //存储所有cube
    fileprivate var cubeList = Set<FightCube>()
    
    //MARK:- init
    init(rowCount: Int, lineCount: Int){
        super.init(texture: nil, color: .blue, size: matrix_size)
        
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
        
        initMatrix()
    }
    
    //MARK:- 生成矩阵
    private func initMatrix(){
        cubeList.forEach(){
            cube in
            cube.removeFromParent()
        }
        cubeList.removeAll()
        
        (0..<rowCount).forEach(){
            row in
            (0..<lineCount).forEach(){
                line in
                
                //判断当前位置是否存在cube,随机创建cube
                let isnotexist = cubeList.filter(){$0.coordinate == (row: row, line: line)}.isEmpty
                if isnotexist{
                    let cubeRaw = Int(arc4random_uniform(4)) + 1
                    if let cubeType = FightCubeType(rawValue: cubeRaw){
                        let cube = FightCube(cubeType)
                        cube.coordinate = (row: row, line: line)
                        cubeList.insert(cube)
                        addChild(cube)
                    }
                }
            }
        }
        
        checkMatrix(){
            count in
            debugPrint(count)
        }
    }
    
    //MARK:- 检测矩阵是否可消除
    private func checkMatrix(closure: (Int)->()){
        
        //生成删除列表
        var deleteList = Set<FightCube>()
        
        //遍历
        (0..<rowCount).forEach(){
            row in
            (0..<lineCount).forEach(){
                line in
                
                //判断并获取当前cube
                if var cube = getCube(fromCoordinate: row, line: line) {
                    let curType = cube.type
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
                    if tempList.count > 2{
                        deleteList = deleteList.union(tempList)
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
                    
                    if tempList.count > 2{
                        deleteList = deleteList.union(tempList)
                    }
                }
            }
        }
        
        //从列表中移除cubes
        cubeList = cubeList.subtracting(deleteList)
        deleteList.forEach(){
            cube in
            cube.removeFromParent()
        }
        
        //回调数量
        closure(deleteList.count)
    }
    
    //MARK:- 根据坐标获取cube
    private func getCube(fromCoordinate row: Int, line: Int) -> FightCube?{
        let list = cubeList.filter(){$0.coordinate == (row: row, line: line)}
        guard list.isEmpty else {
            return list[0]
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
        touches.forEach(){
            touch in
            let location = touch.location(in: self)
            startIndexpath = getCoordinate(fromLocation: location)      //存储开始点
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(){
            touch in
            
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touches.forEach(){
            _ in
            
        }
        //滑动结束调用
        startIndexpath = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        startIndexpath = nil
    }
}
