//
//  GameScene.swift
//  DuckHunt
//
//  Created by Alumne on 22/4/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let gameLimitsX = CGPoint(x: 40, y: 710)
    let gameLimitsY = CGPoint(x: 480, y: 1000)
        
    var aimSprite: SKSpriteNode!

    var initPos = CGPoint(x: -100, y: 900)
    
    var roundManager: Round!
    
    //Points
    var score = 0
    
    var points = Points()
    
    var inChecker = 0
    
    
    
    override func didMove(to _: SKView) {
        //Enemies
        roundManager = Round(gLimX: gameLimitsX, gLimY: gameLimitsY)
        
        //Background
        initBackground(number: roundManager.backgroundIndex);
        
        //Points
        initPoints()
        
        //Aim
        initAim()
    }
    
    func addDucks(){
        for (index, _) in roundManager.ducks.enumerated()
        {
            addChild(roundManager.ducks[index].node)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //print(touch.location(in: self))
            if(isInBounds(limitsX: gameLimitsX, limitsY: gameLimitsY, pos: touch.location(in: self)) && roundManager.numBullets > 0 && !roundManager.billboardFlags[0])
            {
                aimSprite.position = touch.location(in: self)
                
                roundManager.shootBullet()
                initBullets(num: roundManager.numBullets)
                
                for (index, _) in roundManager.ducks.enumerated()
                {
                    if(roundManager.ducks[index].checkHit(position: touch.location(in: self)))
                    {
                        if(roundManager.ducks[index].isDead())
                        {
                            points.updateScore(pointsAdded: roundManager.ducks[index].getPoints())
                        }
                    }
                    //roundManager.ducks[index].node.position = aimSprite.position
                    //print(roundManager.ducks[index].node.position)
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
        
        var roundResult = roundManager.nextRound()
        for (index, _) in roundManager.ducks.enumerated()
        {
            if(roundResult == 2) //Sigue jugando
            {
                roundManager.ducks[index].shouldKillDuck()
                roundManager.ducks[index].movementLogic()
            }
        }
        
        if(roundResult == 0) //Spawnea patos
        {
            roundManager.billboard.removeFromParent()
            roundManager.roundSprite[0].removeFromParent()
            roundManager.roundSprite[1].removeFromParent()
            roundManager.billboardOn = false
            addDucks()
            initBullets(num: roundManager.numBullets)
            roundResult = -1
        }
        else if(roundResult == 1) //Muestra ronda
        {
            if(!roundManager.billboardOn)
            {
                initRoundNumber()
                roundManager.billboardOn = true
            }
        }
    }
}
