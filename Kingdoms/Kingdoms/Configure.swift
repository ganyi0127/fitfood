//
//  Configure.swift
//  Kingdoms
//
//  Created by YiGan on 25/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import SpriteKit

//尺寸
let view_size = UIScreen.main.bounds.size
let scene_size = CGSize(width: 1242, height: 2208)
let matrix_size = CGSize(width: scene_size.width, height: scene_size.width)
let ground_size = CGSize(width: scene_size.width, height: scene_size.height - matrix_size.height)
var cube_size: CGSize?

//文字
let font_name = "Copperplate"

//移动间隔时间
let move_time: TimeInterval = 0.3

//消息
let notify_manager = NotificationCenter.default
let notify_cubes = NSNotification.Name("cubes")

//层级
struct ZPos{
    static let background: CGFloat = 5
    static let middleground: CGFloat = 6
    static let enemy: CGFloat = 7
    static let player: CGFloat = 8
    static let frontground: CGFloat = 9
    static let cube: CGFloat = 20
    static let effect: CGFloat = 30
}
