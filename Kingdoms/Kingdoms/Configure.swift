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
var cube_size: CGSize?

//移动间隔时间
let move_time: TimeInterval = 0.3

//消息
let notify_manager = NotificationCenter.default
let notify_cubes = NSNotification.Name("cubes")
