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
        print(background.position)
        background.zPosition = -1
        addChild(background)
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
