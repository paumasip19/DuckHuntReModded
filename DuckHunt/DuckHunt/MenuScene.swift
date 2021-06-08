//
//  MenuScene.swift
//  DuckHunt
//
//  Created by Alumne on 7/6/21.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {

    var logoSprite: SKSpriteNode!
    let logoPoint = CGPoint(x: -150, y: 500)
    
    var logoAction: SKAction?
    var logoActionKey: String?
    
    var startSprite: SKSpriteNode!
    let startPoint = CGPoint(x: 200, y: 400)
    let outPoint = CGPoint(x: -600, y: 400)
    
    let changeTime = 1
    var changeBool = true
    var timer = -1
    
    override func didMove(to _: SKView) {

        logoAnimation()
    }
    
    func logoAnimation()
    {
        logoSprite = SKSpriteNode(imageNamed: "MenuLogo")
        logoSprite.name = "MenuLogo"
        let bSize = logoSprite.size
        logoSprite.size = CGSize(width: bSize.width * 0.8,
                             height: bSize.height * 0.8)
        logoSprite.anchorPoint = CGPoint(x: 0, y: 0)
        logoSprite.position = CGPoint(x: logoPoint.x, y: logoPoint.y + 1000)
        logoSprite.zPosition = 100
        addChild(logoSprite)
        
        logoAction = SKAction.move(to: logoPoint, duration: 5)
        logoActionKey = "LogoAction"
        
        logoSprite.run(logoAction!, withKey: logoActionKey!)
    }
    
    func startText()
    {
        startSprite = SKSpriteNode(imageNamed: "TapToStart")
        startSprite.name = "MenuLogo"
        let bSize = startSprite.size
        startSprite.size = CGSize(width: bSize.width * 1.1,
                                  height: bSize.height * 1.1)
        startSprite.anchorPoint = CGPoint(x: 0, y: 0)
        startSprite.position = CGPoint(x: startPoint.x, y: startPoint.y)
        startSprite.zPosition = 100
        addChild(startSprite)
    }
    
    func startAnimation()
    {
        if(logoSprite.position == logoPoint)
        {
            timer += 10
            
            if(timer % (700 * changeTime) == 0)
            {
                if(changeBool)
                {
                    startSprite.position = outPoint
                    changeBool = false
                }
                else
                {
                    timer = 0
                    startSprite.position = startPoint
                    changeBool = true
                }
            }
            
            print(timer / 700)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil
        {
            if(logoSprite.position == logoPoint)
            {
                let gameScene = GameScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                self.scene?.view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let canAnimate = (logoSprite.position == logoPoint)
        if(canAnimate && timer < 0)
        {
            startText()
            timer = 0
        }
        else if(canAnimate)
        {
            startAnimation()
        }
    }
}
