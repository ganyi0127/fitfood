//
//  GameViewController.swift
//  Kingdoms
//
//  Created by YiGan on 25/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let sceneNode = SKScene(fileNamed: "GameScene") as! GameScene? {
            
            sceneNode.scaleMode = .aspectFill
            
            if let view = self.view as! SKView? {
                view.presentScene(sceneNode)
                
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("memory warning!")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
