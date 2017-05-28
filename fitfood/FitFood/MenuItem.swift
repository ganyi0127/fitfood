//
//  MenuItem.swift
//  FitFood
//
//  Created by YiGan on 19/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
enum MenuType: String{
    case home = "home"
    case food = "food"
    case water = "water"
    case sport = "sport"
}
class MenuItem {
    
    static var sharedItems:[MenuItem] {
        var items = [MenuItem]()
        
        items.append(MenuItem(withMenuType: .food))
        items.append(MenuItem(withMenuType: .water))
        items.append(MenuItem(withMenuType: .sport))
        
        return items
    }
    
    let title: String
    let color: UIColor
    let menuType: MenuType
    
    init(withMenuType menuType: MenuType) {
        self.menuType = menuType
        
        switch menuType {
        case .home:
            title = "主页"
            color = .darkGray
        case .food:
            title = "进食"
            color = .orange
        case .water:
            title = "饮水"
            color = .cyan
        case .sport:
            title = "运动"
            color = .red
        }
    }
}
