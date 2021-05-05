//
//  GameScene.swift
//  DuckHunt
//
//  Created by Alumne on 22/4/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let gameLimitsX = CGPoint(x: 0, y: 750)
    let gameLimitsY = CGPoint(x: 480, y: 1000)
        
    var aimSprite: SKSpriteNode!

    var duck1_1: Duck!
    var duck1_2: Duck!
    var duck1_3: Duck!
    
    var duck2_1: Duck!
    var duck2_2: Duck!
    var duck2_3: Duck!
    
    var duck3_1: Duck!
    var duck3_2: Duck!
    var duck3_3: Duck!
    
    override func didMove(to _: SKView) {
        //Background
        initBackground(number: 0);
        
        //Enemy Trial
        duck1_1 = Duck(duckType: 1, duckNumber: 0, duckPosition: CGPoint(x: 100, y: 500))
        duck1_2 = Duck(duckType: 1, duckNumber: 1, duckPosition: CGPoint(x: 300, y: 500))
        duck1_3 = Duck(duckType: 1, duckNumber: 2, duckPosition: CGPoint(x: 500, y: 500))
        
        /*duck2_1 = Duck(duckType: 2, duckNumber: 3, duckPosition: CGPoint(x: 100, y: 200))
        duck2_2 = Duck(duckType: 2, duckNumber: 4, duckPosition: CGPoint(x: 200, y: 200))
        duck2_3 = Duck(duckType: 2, duckNumber: 5, duckPosition: CGPoint(x: 300, y: 200))
        
        duck3_1 = Duck(duckType: 3, duckNumber: 6, duckPosition: CGPoint(x: 100, y: 300))
        duck3_2 = Duck(duckType: 3, duckNumber: 7, duckPosition: CGPoint(x: 200, y: 300))
        duck3_3 = Duck(duckType: 3, duckNumber: 8, duckPosition: CGPoint(x: 300, y: 300))*/
        
        
        addChild(duck1_1.node)
        addChild(duck1_2.node)
        addChild(duck1_3.node)
        
        /*addChild(duck2_1.node)
        addChild(duck2_2.node)
        addChild(duck2_3.node)
        
        addChild(duck3_1.node)
        addChild(duck3_2.node)
        addChild(duck3_3.node)*/
        
        //Aim
        initAim()
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if(isInBounds(limitsX: gameLimitsX, limitsY: gameLimitsY, pos: touch.location(in: self)))
            {
                aimSprite.position = touch.location(in: self)
                print(touch.location(in: self))
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
        // Called before each frame is rendered
    }
}
