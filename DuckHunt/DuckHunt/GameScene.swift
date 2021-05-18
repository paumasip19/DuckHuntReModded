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
    
    var ducks_1: [Duck]! = []
    var ducks_2: [Duck]! = []
    var ducks_3: [Duck]! = []
    var duckIndex = 0
    var initPos = CGPoint(x: -100, y: 900)
    
    var duck2_1: Duck!
    var duck2_2: Duck!
    var duck2_3: Duck!
    
    var duck3_1: Duck!
    var duck3_2: Duck!
    var duck3_3: Duck!
    
    //Points
    var score = 0
    
    var points = Points()
    
    var inChecker = 0
    
    override func didMove(to _: SKView) {
        //Background
        initBackground(number: 0);
        
        //Enemies Trial
        
        let direct = CGPoint(x: 1, y: 0)
        
        var index = 0
        for _ in 1...6 {
            do {
                ducks_1.append(Duck(duckType: 1, duckNumber: duckIndex, duckPosition: CGPoint(x: initPos.x + 150, y: initPos.y), dir: direct))
                addChild(ducks_1[index].node)
                    
                ducks_2.append(Duck(duckType: 2, duckNumber: duckIndex, duckPosition: CGPoint(x: initPos.x + 150, y: initPos.y - 150), dir: direct))
                addChild(ducks_2[index].node)
                    
                ducks_3.append(Duck(duckType: 3, duckNumber: duckIndex, duckPosition: CGPoint(x: initPos.x + 150, y: initPos.y - 300), dir: direct))
                addChild(ducks_3[index].node)
                    
                index += 1
            
                initPos.x += 150
            }
        }
        
        //Points
        initPoints()
        
        //Aim
        initAim()
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if(isInBounds(limitsX: gameLimitsX, limitsY: gameLimitsY, pos: touch.location(in: self)))
            {
                aimSprite.position = touch.location(in: self)
                
                for (index, _) in ducks_1.enumerated()
                {
                    if(ducks_1[index].checkHit(position: touch.location(in: self)))
                    {
                        if(ducks_1[index].isDead())
                        {
                            points.updateScore(pointsAdded: ducks_1[index].getPoints())
                        }
                        ducks_1[0].direction = CGPoint(x: 0, y: 1)
                        ducks_1[0].changeMovement()
                    }                   
                }
                
                for (index, _) in ducks_2.enumerated()
                {
                    if(ducks_2[index].checkHit(position: touch.location(in: self)))
                    {
                        if(ducks_2[index].isDead())
                        {
                            points.updateScore(pointsAdded: ducks_2[index].getPoints())
                        }
                        
                    }
                }
                
                for (index, _) in ducks_3.enumerated()
                {
                    if(ducks_3[index].checkHit(position: touch.location(in: self)))
                    {
                        if(ducks_3[index].isDead())
                        {
                            points.updateScore(pointsAdded: ducks_3[index].getPoints())
                        }
                    }
                }
            }
            else
            {
                aimSprite.position = CGPoint(x:-1000, y:-1000);
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
        for (index, _) in ducks_1.enumerated()
        {
            ducks_1[index].shouldKillDuck()
            ducks_1[index].timerCount()
        }
        for (index, _) in ducks_2.enumerated()
        {
            ducks_2[index].shouldKillDuck()
            ducks_2[index].timerCount()
        }
        for (index, _) in ducks_3.enumerated()
        {
            ducks_3[index].shouldKillDuck()
            ducks_3[index].timerCount()
        }
    }
}
