//
//  GameScene.swift
//  DuckHunt
//
//  Created by Alumne on 22/4/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var aimSprite: SKSpriteNode!
    
    override func didMove(to _: SKView) {
        self.backgroundColor = .red
        
        self.aimSprite = SKSpriteNode(imageNamed: "Aim")
        self.aimSprite.name = "Aim"
        self.aimSprite.size = CGSize(width: 200, height: 200)
        
        self.aimSprite.position = CGPoint(x: 300, y: 300)
        self.addChild(self.aimSprite)
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            aimSprite.position = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
