//
//  Configue.swift
//  Alone
//
//  Created by YiGan on 29/11/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit

//MARK:- 尺寸
let view_size = UIScreen.main.bounds.size
let win_size = CGSize(width: 2208, height: 1242)
let default_ground_size = CGSize(width: win_size.width * 3, height: win_size.height * 2)

//图片集
let atlas = SKTextureAtlas(named: "Resource.atlas")

//MARK:- 物理体
struct Mask{
    static let edgeLoop: UInt32 = 0x01 << 0
    static let box: UInt32 = 0x01 << 1
    static let cat: UInt32 = 0x01 << 2
}

//MARK:- 层级
struct ZPos{
    static let background: CGFloat = 1
    static let object: CGFloat = 8
    static let cat: CGFloat = 10
    static let menu: CGFloat = 20
}
