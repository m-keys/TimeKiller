//
//  GameOverScreen.swift
//  TimeKiller
//
//  Created by Лев Дубровский on 12.11.17.
//  Copyright © 2017 Лев Дубровский. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScreen: SKScene {
    
    let button = SKSpriteNode(imageNamed: "killer-time-logo")
     let scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "bg3")
        bg.size = screen.size
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.zPosition = -1
        addChild(bg)
        
        button.position = CGPoint(x: screen.midX, y: screen.minY)
        button.anchorPoint = CGPoint(x: 0.5, y: 0)
        button.size = CGSize(width: 300 , height: 300)
        addChild(button)
        
        scoreLabel.text = "Результат: " + "\(String(score))"
        scoreLabel.fontSize = 30
        scoreLabel.zPosition = 23
        scoreLabel.fontColor = SKColor.blue
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: screen.midX, y: screen.midY)
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchFirst = touches.first {
            let touchLocation = touchFirst.location(in: self)
            
            if button.contains(touchLocation) {
                if let view = self.view  {
                    let gameOverScene = MenuScreen(size: size)
                    gameOverScene.scaleMode = scaleMode
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.6)
                    view.presentScene(gameOverScene, transition: reveal)
                }
            }
            
        }
    }
    
    

}
