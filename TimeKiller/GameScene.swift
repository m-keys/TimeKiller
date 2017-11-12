//
//  GameScene.swift
//  TimeKiller
//
//  Created by Лев Дубровский on 11.11.17.
//  Copyright © 2017 Лев Дубровский. All rights reserved.
//

import SpriteKit
import GameplayKit

 let screen = UIScreen.main.bounds
 var score = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let exit = SKSpriteNode(imageNamed: "exit")
    
    
    let scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
   
    
    var interval = 0.7
    var deathName = String()
    
    let tube = SKSpriteNode(imageNamed: "pipe")
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.8)
        createSceneBorders()
        
        addFireEmitter()
        
       exit.anchorPoint = CGPoint(x: 1, y: 0)
        exit.zPosition = 50
        exit.size = CGSize(width: 80, height: 70)
        exit.position = CGPoint(x: screen.maxX, y: screen.minY)
        exit.alpha = 0.8
        addChild(exit)
        
        let bg = SKSpriteNode(imageNamed: "bgPic")
        bg.size = screen.size
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.zPosition = -1
        addChild(bg)
        
        tube.position = CGPoint(x: screen.minX, y: screen.maxY + 10)
        tube.anchorPoint = CGPoint(x: 0, y: 1)
        tube.size = CGSize(width: 100, height: 100)
        tube.zPosition = 20
        let move = SKAction.moveTo(x: screen.maxX - tube.size.width, duration: 8)
        let moveback = SKAction.moveTo(x: screen.minX, duration: 8)
        move.timingMode = .easeInEaseOut
        moveback.timingMode = .easeInEaseOut
        let seq2 = SKAction.sequence([move, moveback])
        tube.run(SKAction.repeatForever(seq2))
        
        scoreLabel.text = String(score)
        scoreLabel.fontSize = 30
        scoreLabel.zPosition = 23
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 50, y: -40)
        tube.addChild(scoreLabel)
        

        addChild(tube)
        
        repeatCreation()
        
        let konveer = SKAction.run {
            self.createKonveer()
            self.createKonveer2()
        }
        let wait = SKAction.wait(forDuration: 0.5)
        let seq = SKAction.sequence([konveer, wait])
        
        run(SKAction.repeatForever(seq))
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        enumerateChildNodes(withName: "clock") { (objectNode, stop) in
            if objectNode.position.y < 100 {
                let alphaAction = SKAction.fadeAlpha(to: 0, duration: 1)
                let removeAction = SKAction.removeFromParent()
                let scoreAction = SKAction.run {
                  
                    if objectNode.name == "clock"{
                        score += 1
                        self.scoreLabel.text = String(score)
                           self.addCoinsLabel(who: objectNode, int: +1)
                    }
                    
                    
                }
                objectNode.run(SKAction.sequence([alphaAction, removeAction,scoreAction]))
                
            }
        }
        enumerateChildNodes(withName: "object") { (objectNode, stop) in
            if objectNode.position.y < 100 {
                let alphaAction = SKAction.fadeAlpha(to: 0, duration: 1)
                let removeAction = SKAction.removeFromParent()
                let scoreAction = SKAction.run {
                    if objectNode.name == "object"{
                           self.addCoinsLabel(who: objectNode, int: -1)
                    score -= 1
                    self.scoreLabel.text = String(score)
                    }
                   
                    
                    
                }
                objectNode.run(SKAction.sequence([alphaAction, removeAction,scoreAction]))
               
            }
        }
    }
    
    func repeatCreation() {
        let createAction = SKAction.run {
            self.createObjects(point: self.tube.position)
            
        }
        let waitAction = SKAction.wait(forDuration: TimeInterval(interval))
        let createAction2 = SKAction.run {
            self.repeatCreation()
        }
        let seq = SKAction.sequence([createAction, waitAction, createAction2])
        run(seq)
    }
    
    func createSceneBorders() {
        self.scaleMode = .aspectFill
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func createObjects(point: CGPoint) {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue:9)
        let randomNumber = distribution.nextInt()
        let imageName = "\(randomNumber)"
        let foodTexture = SKTexture(imageNamed: imageName)
        let object = SKSpriteNode(texture: foodTexture)
        object.size = CGSize(width: 60, height: 60)
        object.zPosition = 1
        object.physicsBody?.allowsRotation = false
        object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width / 2 )
        
        object.position = CGPoint(x: tube.position.x + (tube.size.width / 2), y: tube.position.y - object.size.height)
        //
        switch randomNumber {
        case 8...9:
            object.name = "clock"
        case 1...7:
            object.name = "object"
        default:
            print("def")
        }
      
        object.zPosition = 2
        
        addChild(object)
    }
    
    func createClocks(point: CGPoint) {
        let distribution = GKRandomDistribution(lowestValue: 3, highestValue:3)
        let randomNumber = distribution.nextInt()
        let imageName = "\(randomNumber)"
        let foodTexture = SKTexture(imageNamed: imageName)
        let clock = SKSpriteNode(texture: foodTexture)
        clock.size = CGSize(width: 60, height: 60)
        clock.zPosition = 1
        clock.physicsBody?.allowsRotation = false
        clock.physicsBody = SKPhysicsBody(circleOfRadius: clock.size.width / 2 )
       
        clock.position = CGPoint(x: tube.position.x + (tube.size.width / 2), y: tube.position.y - clock.size.height)
       
        clock.name = "clock"
        clock.zPosition = 2
        
        addChild(clock)
    }
        
        // TOUCHES
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchFirst = touches.first {
            let touchLocation = touchFirst.location(in: self)
            
            if exit.contains(touchLocation) {
                if let view = self.view  {
                    let gameOverScene = GameOverScreen(size: size)
                    gameOverScene.scaleMode = scaleMode
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.6)
                    view.presentScene(gameOverScene, transition: reveal)
                }
            }
            
            
            
            for i in nodes(at: touchLocation) {
                if i.name == "object" {
                   
                      makeWhitePhoof(who: i)
                    let scale = SKAction.scale(to: 0, duration: 1)
                    let remove = SKAction.removeFromParent()
                    i.run(SKAction.sequence([scale, remove]))
                    
                }
                
                if i.name == "clock" {
                   makeExplotion(who: i)
                       addCoinsLabel(who: i, int: -1)
                    let scale = SKAction.scale(to: 0, duration: 1)
                    let remove = SKAction.removeFromParent()
                    i.run(SKAction.sequence([scale, remove]))
                    score -= 1
                     self.scoreLabel.text = String(score)
                   
                }
                
            }
            
            
            
            
        }
    }
    
    func createKonveer() {
        let circle = SKSpriteNode(imageNamed: "swift-logo")
        circle.size = CGSize(width: 20, height: 20)
        circle.position = CGPoint(x: screen.minX, y: screen.midY + 70)
        circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width / 2 )
        circle.physicsBody?.affectedByGravity = false
        circle.physicsBody?.isDynamic = false
        
        let a = SKAction.move(to: CGPoint(x: screen.midX, y: screen.midY + 60) , duration: 3)
        let b =   SKAction.moveBy(x: 0, y: -10, duration: 0.51)
        let c =   SKAction.moveTo(x: screen.minX, duration: 3)
        let remove = SKAction.removeFromParent()
        let rotateAction = SKAction.rotate(byAngle: -10, duration: 1)
        let action = SKAction.repeatForever(rotateAction)
        circle.run(action)
        let seq = SKAction.sequence([a, b, c, remove])
        circle.run(seq)
        addChild(circle)
    }
    
    func createKonveer2() {
        let circle2 = SKSpriteNode(imageNamed: "swift-logo")
        circle2.size = CGSize(width: 20, height: 20)
        circle2.position = CGPoint(x: screen.maxX, y: screen.midY - 100)
        circle2.physicsBody = SKPhysicsBody(circleOfRadius: circle2.size.width / 2 )
        circle2.physicsBody?.affectedByGravity = false
        circle2.physicsBody?.isDynamic = false
        let a = SKAction.moveTo(x: screen.midX, duration: 3)
        let b =   SKAction.moveBy(x: 0, y: -10, duration: 0.51)
        let c =   SKAction.moveTo(x: screen.maxX, duration: 3)
        let remove = SKAction.removeFromParent()
        let rotateAction = SKAction.rotate(byAngle: 10, duration: 1)
        let action = SKAction.repeatForever(rotateAction)
        circle2.run(action)
        let seq = SKAction.sequence([a, b, c, remove])
        circle2.run(seq)
        addChild(circle2)
    }
    
    func addFireEmitter() {
        let firePath = Bundle.main.path(forResource: "FireParticle", ofType: "sks")
        let firePart = NSKeyedUnarchiver.unarchiveObject(withFile: firePath!) as! SKEmitterNode
        firePart.zPosition = 4
        firePart.position = CGPoint(x: screen.midX, y: screen.minY)
        addChild(firePart)
    }
    
    func addFireBoom(point: CGPoint) {
        let firePath = Bundle.main.path(forResource: "FireBoom", ofType: "sks")
        let firePart2 = NSKeyedUnarchiver.unarchiveObject(withFile: firePath!) as! SKEmitterNode
        firePart2.zPosition = 4
        firePart2.position = point
        firePart2.setScale(0)
        let alpa = SKAction.fadeAlpha(to: 0, duration: 1)
        let scale = SKAction.scale(to: 1, duration: 1)
        let remove = SKAction.removeFromParent()
        firePart2.run(SKAction.sequence([scale, alpa, remove]))
        addChild(firePart2)
    }
    
    func makeWhitePhoof(who: SKNode) {
        var arrayOfTextures = [SKTexture]()
        for i in 1...16 {
            let number = String(format: "%02d", i)
            arrayOfTextures.append(SKTexture(imageNamed: "whitePuff00\(number)"))
        }
        let animation = SKAction.animate(with: arrayOfTextures, timePerFrame: 0.05)
        who.run(animation)
        print("ani")
    }
    
    func makeExplotion(who: SKNode) {
        var arrayOfTextures = [SKTexture]()
        for i in 1...8 {
            let number = String(format: "%02d", i)
            arrayOfTextures.append(SKTexture(imageNamed: "explosion00\(number)"))
        }
        let animation = SKAction.animate(with: arrayOfTextures, timePerFrame: 0.05)
        who.run(animation)
    
    }
    
    func addCoinsLabel(who: SKNode, int: Int) {
        let scoreLabel2 = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        scoreLabel2.text = String(int)
        scoreLabel2.fontSize = 20
        scoreLabel2.zPosition = 24
        scoreLabel2.alpha = 0.7
        if int == 1 {
             scoreLabel2.fontColor = SKColor.white
        } else {
        scoreLabel2.fontColor = SKColor.red
        }
        scoreLabel2.horizontalAlignmentMode = .center
        scoreLabel2.verticalAlignmentMode = .top
        scoreLabel2.position = who.position
        addChild(scoreLabel2)
        
        let move = SKAction.moveBy(x: 0, y: 50, duration: 2)
        let remove = SKAction.removeFromParent()
        let up = SKAction.scale(to: 2, duration: 0.5)
        up.timingMode = .easeInEaseOut
        let down = SKAction.scale(to: 1, duration: 0.2)
        down.timingMode = .easeInEaseOut
        let upDown = SKAction.sequence([up, down])
        let seq = SKAction.sequence([move, upDown, remove ])
        scoreLabel2.run(seq)
    }
    
    
    
}
