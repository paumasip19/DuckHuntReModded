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
    var roundNumbers = [0, 9] //Cambiar a 1
    
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
    
    var playerMistakes = 0
    var playerMaxMistakes = 10
    var mistakeSprite = SKSpriteNode(imageNamed: "Mistakes_0")
    var addMistake = false
    
    var playerHealth = 0
    var playerMaxHealth = 5
    var healthSprite = SKSpriteNode()
    
    var gameOver = false
    var startGameOver = true
    var gameOverSprite = SKSpriteNode(imageNamed: "GameOver")
    
    var gameLimitsX: CGPoint
    var gameLimitsY: CGPoint
    
    let timeBetweenRounds = 3
    
    //Coins && Boss
    let bossRound = 10
    var isBossRound = false
    
    var coinRound = false
    var coinCount = 0
    let maxCoins = 10
    
    var coinsShot = 0
    var lastCoinsShot = 0
    var returnToMistakes = false
    
    init(gLimX: CGPoint, gLimY: CGPoint) {
        self.gameLimitsX = gLimX
        self.gameLimitsY = gLimY
        
        self.gameLimitsX.x += 25
        self.gameLimitsX.y -= 25
        
        self.gameLimitsY.x += 25
        self.gameLimitsY.y -= 25
        
        playerHealth = playerMaxHealth
        
        spawnDucks()
    }
    
    mutating func spawnBoss()
    {
        var num = 0
        let random = Int.random(in: 1...3)
        ducks.append(Duck(duckType: random, duckNumber: 0, dir: CGPoint(x: 1, y: 0), gLimX: gameLimitsX, gLimY: gameLimitsY, extraSpeed: CGFloat(extraSpeed), extraLife: CGFloat(extraLife)))
        
        num += ducks[0].life
        
        num *= 2
        calculateBullets(num: num)
        numBullets = num
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
    
    mutating func spawnCoin()
    {
        var num = 0
        
        ducks.append(Duck(duckType: 5, duckNumber: 0, dir: CGPoint(x: 1, y: 0), gLimX: gameLimitsX, gLimY: gameLimitsY, extraSpeed: CGFloat(extraSpeed), extraLife: CGFloat(extraLife)))
        
        num += ducks[0].life
        
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
    
    mutating func addMistakeFunc(mistakes: Int)
    {
        for _ in 1...mistakes {
            do {
                if(playerMistakes + 1 != playerMaxMistakes)
                {
                    playerMistakes += 1
                }
                else { gameOver = true }
            }
        }
    }
    
    mutating func nextRound() -> Int
    {
        if(ducks.count != 0)
        {
            ducksAlive = 0
            var index = 0
            for _ in 1...ducks.count {
                do {
                    if(ducks[index].endRound && ducks[index].node.position == ducks[index].initialPos)
                    {
                        ducksAlive = 0
                        var index2 = 0
                        for _ in 1...2 {
                            do {
                                if(ducks[index2].node.parent != nil) { ducksAlive += 1 }
                                index2 += 1
                            }
                        }
                        if(ducksAlive != 0) {
                            addMistake = true
                        }
                        
                        removeAllAttacks()
                        removeDucks()
                        ducks.removeAll()
                        if(!coinRound)
                        {
                            billboardFlags[0] = true
                            timer = 0
                        }
                        
                        break
                    }
                    else if(ducks[index].node.parent != nil)
                    {
                        ducksAlive += 1
                    }
                    
                    if(coinRound)
                    {
                        if(!ducks[index].endRound && isInBounds(limitsX: gameLimitsX, limitsY: gameLimitsY, pos: ducks[index].node.position))
                        {
                            ducks[index].endRound = true
                        }
                        if((ducks[index].node.position.x < gameLimitsX.x - 50 ||
                           ducks[index].node.position.x > gameLimitsX.y + 50) && ducks[index].endRound)
                        {
                            removeDucks()
                            ducks.removeAll()
                        }
                    }
                    
                    index += 1
                }
            }
            
            if(ducksAlive == 0)
            {
                removeAllAttacks()
                ducks.removeAll()
                if(!coinRound)
                {
                    billboardFlags[0] = true
                    timer = 0
                }
                else
                {
                    coinsShot += 1
                }
            }
        }
        
        if(ducks.count == 0)
        {
            if(coinRound && !billboardFlags[0] && !billboardFlags[0])
            {
                if(coinsShot != lastCoinsShot)
                {
                    returnToMistakes = true
                    lastCoinsShot = coinsShot
                }
                
                if(coinCount == maxCoins - 1)
                {
                    coinCount = 0
                    coinRound = false
                    returnToMistakes = true
                    billboardFlags[0] = true
                }
                else
                {
                    coinCount += 1
                    spawnCoin()
                    return 0
                }
            }
            
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
                if(isBossRound && !coinRound)
                {
                    //Start Boss Fight
                    spawnBoss()
                    ducksAlive = 1
                    print("Boss Fight")
                }
                else if(coinRound)
                {
                    spawnCoin()
                    ducksAlive = 1
                }
                else
                {
                    spawnDucks()
                    ducksAlive = 2
                }
                
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
        for _ in 1...ducks.count {
            do {
                ducks[index].node.removeFromParent()
                index += 1
            }
        }
    }
    
    mutating func removeAllAttacks()
    {
        var index = 0
        for _ in 1...ducks.count {
            do {
                ducks[index].removeAllAttacks()
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
