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
        background.zPosition = -1
        addChild(background)
    }
    
    func initAim()
    {
        self.aimSprite = SKSpriteNode(imageNamed: "Aim")
        self.aimSprite.name = "Aim"
        self.aimSprite.size = CGSize(width: 200, height: 200)
        
        self.aimSprite.position = CGPoint(x: 300, y: 300)
        self.addChild(self.aimSprite)
    }
}
