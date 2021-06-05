//
//  Round.swift
//  DuckHunt
//
//  Created by Alumne on 18/5/21.
//

import GameplayKit
import SpriteKit

enum RoundType { case NORMAL; case COINS; case BOSS }

struct Round {
    
    var roundType = RoundType.NORMAL
    
    var timer = 0
    
    var billboardFlags = [false, false]
    
    var billboard = SKSpriteNode(imageNamed: "Billboard")
    var roundSprite = [SKSpriteNode(imageNamed: "Points_0"),
                       SKSpriteNode(imageNamed: "Points_0")]
    var billboardOn = false
    var roundNumbers = [0, 1]
    
    var backgroundIndex = 0
    
    var bullets = [0, 0]
    var bulletsSprite = [SKSpriteNode(imageNamed: "Points_0"),
                         SKSpriteNode(imageNamed: "Points_0")]
    var numBullets = 0
    
    var ducksAlive = 2
    
    var initPos = [CGPoint]()
    
    var ducks = [Duck]()
    
    var extraLife = 0.0
    var extraSpeed = 1.0
    
    var playerHealth = 5
    var playerMistakes = 10
    
    let gameLimitsX: CGPoint
    let gameLimitsY: CGPoint
    
    let timeBetweenRounds = 3
    
    init(gLimX: CGPoint, gLimY: CGPoint) {
        self.gameLimitsX = gLimX
        self.gameLimitsY = gLimY
        
        spawnDucks()
    }
    
    mutating func spawnDucks()
    {
        var index = 0
        var num = 0
        for _ in 1...2 {
            do {
                let random = Int.random(in: 1...3)
                ducks.append(Duck(duckType: random, duckNumber: index, dir: CGPoint(x: 1, y: 0), gLimX: gameLimitsX, gLimY: gameLimitsY, extraSpeed: CGFloat(extraSpeed), extraLife: CGFloat(extraLife)))
                
                num += ducks[index].life
                
                index = index + 1
            }
        }
        
        num *= 2
        calculateBullets(num: num)
        numBullets = num
    }
    
    mutating func calculateBullets(num: Int)
    {
        if(num < 10)
        {
            bullets[0] = 0
            bullets[1] = num
        }
        else
        {
            bullets[1] = num % 10;
            bullets[0] = (num - bullets[1])
            bullets[0] /= 10;
        }
    }
    
    mutating func shootBullet()
    {
        numBullets -= 1
        calculateBullets(num: numBullets)
    }
    
    mutating func nextRound() -> Int
    {
        if(ducks.count != 0)
        {
            ducksAlive = 0
            var index = 0
            for _ in 1...2 {
                do {
                    if(ducks[index].endRound && ducks [index].node.position == ducks[index].initialPos)
                    {
                        removeDucks()
                        ducks.removeAll()
                        billboardFlags[0] = true
                        timer = 0
                        break
                    }
                    else if(ducks[index].node.parent != nil)
                    {
                        ducksAlive += 1
                    }
                    index += 1
                }
            }
            
            if(ducksAlive == 0)
            {
                ducks.removeAll()
                billboardFlags[0] = true
                timer = 0
            }
        }
        
        if(ducks.count == 0)
        {
            if(billboardFlags[0])
            {
                timer += 10
                
                print(timer / 700)
                
                if(timer % (700 * timeBetweenRounds) == 0)
                {
                    timer = 0
                    billboardFlags[0] = false
                    billboardFlags[1] = true
                }
            }
            if(billboardFlags[1])
            {
                spawnDucks()
                ducksAlive = 2
                billboardFlags[1] = false
                return 0
            }
            
            return 1
        }
        
        return 2
    }
    
    mutating func removeDucks()
    {
        var index = 0
        for _ in 1...2 {
            do {
                ducks[index].node.removeFromParent()
                index += 1
            }
        }
    }
    
    mutating func increaseLifeAndSpeed()
    {
        self.extraLife += 1
        self.extraSpeed += 0.25
    }
}
