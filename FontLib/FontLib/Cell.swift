//
//  Cell.swift
//  FontLib
//
//  Created by YiGan on 21/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class Cell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    
    var closure: (()->())?
    
    private var gradient: CAGradientLayer?
    var isFavorite = false{
        didSet{
            let buttonSize = markButton.bounds.size
            let img: UIImage, hlImg: UIImage
            if isFavorite {
                gradient?.colors = [default_color.cgColor, default_color.cgColor]
                img = UIImage(named: "resource/delete")!.transfromImage(size: buttonSize)!
                hlImg = UIImage(named: "resource/delete_hl")!.transfromImage(size: buttonSize)!
            }else{
                gradient?.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
                img = UIImage(named: "resource/mark")!.transfromImage(size: buttonSize)!
                hlImg = UIImage(named: "resource/mark_hl")!.transfromImage(size: buttonSize)!
            }
            
            //设置按钮图片
            markButton.setImage(img, for: .normal)
            markButton.setImage(hlImg, for: .highlighted)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        //绘制渐变
        guard gradient == nil else {
            return
        }
        gradient = CAGradientLayer()
        gradient?.frame = CGRect(x: 8,
                                 y: 8,
                                 width: contentView.bounds.width - 16,
                                 height: contentView.bounds.height - 16)
        gradient?.locations = [0.2, 0.8]
        gradient?.startPoint = CGPoint(x: 0, y: 0)
        gradient?.endPoint = CGPoint(x: 0, y: 1)
        gradient?.colors = [default_color.cgColor, default_color.cgColor]
        gradient?.cornerRadius = cornerRadius
        gradient?.shadowColor = UIColor.black.cgColor
        layer.insertSublayer(gradient!, at: 0)
        
    }
    
    @IBAction func mark(_ sender: UIButton) {
        closure?()
    }
}
