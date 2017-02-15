//
//  EditVC.swift
//  FontLib
//
//  Created by YiGan on 21/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class EditVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var fontsizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var fontsizeSlider: UISlider!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    private var red: CGFloat = 255{
        didSet{
            redLabel.text = "\(Int(red))"
            redSlider.value = Float(red)
            updateWord()
        }
    }
    private var green: CGFloat = 255{
        didSet{
            greenLabel.text = "\(Int(green))"
            greenSlider.value = Float(green)
            updateWord()
        }
    }
    private var blue: CGFloat = 255{
        didSet{
            blueLabel.text = "\(Int(blue))"
            blueSlider.value = Float(blue)
            updateWord()
        }
    }
    private var fontsize: CGFloat = 17{
        didSet{
            fontsizeLabel.text = "font size: \(Int(fontsize))"
            fontsizeSlider.value = Float(fontsize)
            updateWord()
        }
    }
    
    //MARK:- -------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
    }
    
    private func config(){
        red = Font.share.red
        green = Font.share.green
        blue = Font.share.blue
        fontsize = Font.share.size
        
        textView.text = Font.share.text
        
        cancelButton.setTitleColor(default_color, for: .normal)
        cancelButton.backgroundColor = .white
        acceptButton.backgroundColor = default_color
        
        textView.layer.cornerRadius = cornerRadius
        cancelButton.layer.cornerRadius = cornerRadius
        acceptButton.layer.cornerRadius = cornerRadius
        
        //添加阴影
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 0, height: 5)
        textView.layer.shadowRadius = 2
        textView.layer.shadowOpacity = 0.5
    }
    
    //MARK:- 修改值
    @IBAction func slider(_ sender: UISlider) {
        let tag = sender.tag
        
        switch tag {
        case 0:
            red = CGFloat(Int(sender.value))
        case 1:
            green = CGFloat(Int(sender.value))
        case 2:
            blue = CGFloat(Int(sender.value))
        default:
            fontsize = CGFloat(Int(sender.value))
        }
        
    }
    
    //MARK:- 更新文字
    private func updateWord(_ withModel: Bool = false){
        
        let color = UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
        textView.textColor = color
        colorLabel.textColor = color
        textView.font = UIFont(name: Font.share.fontname, size: fontsize)
        textView.reloadInputViews()
        
        //转换为代码颜色
        colorLabel.text = "#" + getHexFrom(value: Int16(red)) + getHexFrom(value: Int16(green)) + getHexFrom(value: Int16(blue))        
    }
    
    private func getHexFrom(value: Int16) -> String{
        func transformHex(digit: Int16) -> String{
            switch digit {
            case 10:
                return "A"
            case 11:
                return "B"
            case 12:
                return "C"
            case 13:
                return "D"
            case 14:
                return "E"
            case 15:
                return "F"
            default:
                return "\(digit)"
            }
        }
        
        let t = value / 16
        let d = value % 16
        return transformHex(digit: t) + transformHex(digit: d)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func accept(_ sender: UIButton) {
        
        Font.share.updateColor(red: red, green: green, blue: blue, fontSize: fontsize, wordText: textView.text)
        dismiss(animated: true, completion: nil)
    }
}

extension EditVC: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let existedLength = textView.text?.lengthOfBytes(using: String.Encoding.utf8)
        let selectedLength = range.length
        let replaceLength = text.lengthOfBytes(using: String.Encoding.utf8)
        if existedLength! - selectedLength + replaceLength > 500{
            return false
        }
        
        return true
    }
}
