//
//  MenuScreen.swift
//  TimeKiller
//
//  Created by Лев Дубровский on 12.11.17.
//  Copyright © 2017 Лев Дубровский. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScreen: SKScene {
    
    let button = SKSpriteNode(imageNamed: "playButton")
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "one")
        bg.size = screen.size
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.zPosition = -1
        addChild(bg)
        
        button.position = CGPoint(x: screen.midX, y: screen.midY)
        button.size = CGSize(width: 100 , height: 100)
        addChild(button)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchFirst = touches.first {
            let touchLocation = touchFirst.location(in: self)
            
            if button.contains(touchLocation) {
                if let view = self.view  {
                            let gameOverScene = GameScene(size: size)
                            gameOverScene.scaleMode = scaleMode
                            let reveal = SKTransition.flipHorizontal(withDuration: 0.6)
                            view.presentScene(gameOverScene, transition: reveal)
                        }
            }
            
        }
    }
    
    
    
//    if let view = self.view  {
//        let gameOverScene = StoreScene(size: size)
//        gameOverScene.scaleMode = scaleMode
//        let reveal = SKTransition.flipHorizontal(withDuration: 0.6)
//        view.presentScene(gameOverScene, transition: reveal)
//    }

}
