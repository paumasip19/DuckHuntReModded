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

    var initPos = CGPoint(x: -100, y: 900)
    
    var roundManager: Round!
    
    //Points
    var score = 0
    
    var points = Points()
    
    var inChecker = 0
    
    var gameOverTimer = 0
    let gameOverTimeTransition = 5
    
    override func didMove(to _: SKView) {
        //Enemies
        roundManager = Round(gLimX: gameLimitsX, gLimY: gameLimitsY)
        
        //Background
        initBackground(number: roundManager.backgroundIndex);
        
        //Points
        initPoints()
        
        //Aim
        initAim()
        
        initMistakes()
        initHealth()
    }
    
    func addDucks(){
        for (index, _) in roundManager.ducks.enumerated()
        {
            addChild(roundManager.ducks[index].node)
        }
    }
    
    func loadMenu()
    {
        let gameScene = GameScene(fileNamed: "MenuScene")!
        gameScene.scaleMode = .aspectFill
        self.scene?.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if(!roundManager.gameOver)
            {
                if(isInBounds(limitsX: gameLimitsX, limitsY: gameLimitsY, pos: touch.location(in: self)) && roundManager.numBullets > 0 && !roundManager.billboardFlags[0])
                {
                    aimSprite.position = touch.location(in: self)
                    
                    var isBulletShot = [true, true]
                    
                    for (index, _) in roundManager.ducks.enumerated()
                    {
                        if(roundManager.ducks[index].checkHit(position: touch.location(in: self)))
                        {
                            if(roundManager.ducks[index].isDead())
                            {
                                points.updateScore(pointsAdded: roundManager.ducks[index].getPoints())
                            }
                        }
                        
                        
                        var eliminate = [CGPoint]()
                        
                        for (index2, _) in roundManager.ducks[index].attacks.enumerated()
                        {
                            if(roundManager.ducks[index].attacks[index2].hitAttack(position: touch.location(in: self)))
                            {
                                isBulletShot[index] = false
                                if(roundManager.ducks[index].attacks[index2].mustDeleteAttack())
                                {
                                    eliminate.append(CGPoint(x: index, y: index2))
                                }
                            }
                        }
                        
                        if(eliminate.count != 0)
                        {
                            for (index2, _) in eliminate.enumerated()
                            {
                                roundManager.ducks[Int(eliminate[index2].x)].attacks.remove(at: Int(eliminate[index2].y))
                            }
                        }
                    }
                    
                    if(isBulletShot[0] && isBulletShot[1])
                    {
                        roundManager.shootBullet()
                        initBullets(num: roundManager.numBullets)
                    }
                }
                else
                {
                    aimSprite.position = CGPoint(x:-1000, y:-1000);
                }
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
        
        if(!roundManager.gameOver)
        {
            var roundResult = roundManager.nextRound()
            for (index, _) in roundManager.ducks.enumerated()
            {
                if(roundResult == 2) //Sigue jugando
                {
                    roundManager.ducks[index].shouldKillDuck()
                    roundManager.ducks[index].movementLogic()
                    
                    if(roundManager.ducks[index].addAttack)
                    {
                        let num = roundManager.ducks[index].attacks.count-1
                        addChild(roundManager.ducks[index].attacks[num].node)
                        roundManager.ducks[index].addAttack = false
                    }
                    
                    var eliminate = [CGPoint]()
                    for (index2, _) in roundManager.ducks[index].attacks.enumerated()
                    {
                        if(roundManager.ducks[index].attacks[index2].checkPlayerHit()) //Hits Player
                        {
                            roundManager.playerHealth -= 1
                            eliminate.append(CGPoint(x: index, y: index2))
                            
                            if(roundManager.playerHealth == 0) { roundManager.gameOver = true }
                            initHealth()
                        }
                        else
                        {
                            roundManager.ducks[index].attacks[index2].rockMovement()
                        }
                    }
                    
                    if(eliminate.count != 0)
                    {
                        for (index2, _) in eliminate.enumerated()
                        {
                            roundManager.ducks[Int(eliminate[index2].x)].attacks[Int(eliminate[index2].y)].node.removeFromParent()
                            roundManager.ducks[Int(eliminate[index2].x)].attacks.remove(at: Int(eliminate[index2].y))
                        }
                    }
                }
            }
            
            if(roundResult == 0) //Spawnea patos
            {
                roundManager.billboard.removeFromParent()
                roundManager.roundSprite[0].removeFromParent()
                roundManager.roundSprite[1].removeFromParent()
                roundManager.billboardOn = false
                
                if(roundManager.isBossRound && !roundManager.coinRound)
                {
                    //Start Boss Fight
                    addDucks() //Temporary
                }
                else
                {
                    addDucks()
                }
                
                
                initBullets(num: roundManager.numBullets)
                roundResult = -1
            }
            else if(roundResult == 1) //Muestra ronda
            {
                if(roundManager.addMistake)
                {
                    roundManager.addMistake = false
                    roundManager.addMistakeFunc(mistakes: roundManager.ducksAlive)
                    initMistakes()
                }
                
                if(!roundManager.billboardOn && !roundManager.gameOver)
                {
                    if(arrayToScore(array: roundManager.roundNumbers) % roundManager.bossRound == 0 && !roundManager.isBossRound && !roundManager.coinRound)
                    {
                        roundManager.isBossRound = true
                    }
                    else if(roundManager.isBossRound)
                    {
                        roundManager.isBossRound = false
                        roundManager.coinRound = true
                        
                        initMistakes()
                    }
                    else if(roundManager.coinRound)
                    {
                        roundManager.coinRound = false
                        initMistakes()
                    }
                    
                    initRoundNumber()
                    roundManager.billboardOn = true
                }
            }
        }
        else
        {
            if(roundManager.startGameOver)
            {
                saveNewScore(points: points)
                initGameOver()
                gameOverTimer = 0
            }
            
            gameOverTimer += 10
            
            if(gameOverTimer % (700 * gameOverTimeTransition) == 0)
            {
                loadMenu()
            }
        }
    }
}
