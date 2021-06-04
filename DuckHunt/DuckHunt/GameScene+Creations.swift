//
//  GameScene+Creations.swift
//  DuckHunt
//
//  Created by Alumne on 29/4/21.
//

import GameplayKit
import SpriteKit

extension GameScene {
    
    
    
    func initBackground(number: Int)
    {
        //childNode(withName: "Background" + String(number)).removeFromParent()
        let background = SKSpriteNode(imageNamed: "Background" + String(number))
        let bgSize = background.size
        background.size = CGSize(width: bgSize.width * 3,
                                 height: bgSize.height * 3)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: UIScreen.main.bounds.height/2+50)
        background.zPosition = -1
        addChild(background)
        
        let black1 = SKSpriteNode(imageNamed: "Black")
        let bkSize = black1.size
        black1.size = CGSize(width: bkSize.width / 3,
                                 height: bkSize.height / 5)
        black1.anchorPoint = CGPoint(x: 0, y: 0)
        black1.position = CGPoint(x: 0, y: 1000)
        black1.zPosition = 10000
        addChild(black1)
        
        let black2 = SKSpriteNode(imageNamed: "Black")
        black2.size = CGSize(width: bkSize.width / 3,
                                 height: bkSize.height / 5)
        black2.anchorPoint = CGPoint(x: 0, y: 0)
        black2.position = CGPoint(x: 0, y: -100)
        black2.zPosition = 10000
        addChild(black2)
    }
    
    func initAim()
    {
        self.aimSprite = SKSpriteNode(imageNamed: "Aim")
        self.aimSprite.name = "Aim"
        self.aimSprite.size = CGSize(width: 80, height: 80)
        self.aimSprite.zPosition = 15
        
        self.aimSprite.position = CGPoint(x: 300, y: 300)
        self.addChild(self.aimSprite)
    }
    
    func getZeroZero(node: SKSpriteNode) -> CGPoint
    {
        var point = CGPoint()
        
        point.x = node.position.x - node.size.width/2
        point.y = node.position.y - node.size.height/2
        
        return point
    }
    
    func initPoints()
    {
        var index = 0
        for _ in 1...6 {
            do {
                addChild(points.nodes[index])
                index += 1
            
                //Change Pos to put in
                initPos.x += 150
            }
        }
        
    }
    
    
}
