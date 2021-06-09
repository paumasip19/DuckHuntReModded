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
        
        self.aimSprite.position = CGPoint(x: 2000, y: 2000)
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
    
    func initRoundNumber()
    {
        if(!roundManager.isBossRound && !roundManager.coinRound)
        {
            roundManager.billboard = SKSpriteNode(imageNamed: "Billboard")
            roundManager.billboard.name = "Billboard"
            let bSize = roundManager.billboard.size
            roundManager.billboard.size = CGSize(width: bSize.width,
                                     height: bSize.height)
            roundManager.billboard.anchorPoint = CGPoint(x: 0, y: 0)
            roundManager.billboard.position = CGPoint(x: 375 - bSize.width/2, y: 700)
            roundManager.billboard.zPosition = 100
            addChild(roundManager.billboard)
            
            roundManager.roundSprite[0] = SKSpriteNode(imageNamed: "Points_" + String(roundManager.roundNumbers[0]))
            roundManager.roundSprite[0].name = "RoundSprite_0"
            roundManager.roundSprite[0].size = CGSize(width: 24 * 1.2, height: 25 * 1.2)
            roundManager.roundSprite[0].anchorPoint = CGPoint(x: 0, y: 0)
            roundManager.roundSprite[0].position = CGPoint(x: 348 , y: 717)
            roundManager.roundSprite[0].zPosition = 105
            addChild(roundManager.roundSprite[0])
            
            roundManager.roundSprite[1] = SKSpriteNode(imageNamed: "Points_" + String(roundManager.roundNumbers[1]))
            roundManager.roundSprite[1].name = "RoundSprite_0"
            roundManager.roundSprite[1].size = CGSize(width: roundManager.roundSprite[0].size.width,
                                                      height: roundManager.roundSprite[0].size.height)
            roundManager.roundSprite[1].anchorPoint = CGPoint(x: 0, y: 0)
            roundManager.roundSprite[1].position = CGPoint(x: roundManager.roundSprite[0].position.x + roundManager.roundSprite[0].size.width, y: roundManager.roundSprite[0].position.y)
            roundManager.roundSprite[1].zPosition = 105
            addChild(roundManager.roundSprite[1])
            
            if(roundManager.roundNumbers[0] != 0 &&
                roundManager.roundNumbers[1] == 1)
            {
                if(!roundManager.isBossRound && !roundManager.coinRound)
                {
                    if(roundManager.backgroundIndex == 1) { roundManager.backgroundIndex = 0 }
                    else if(roundManager.backgroundIndex == 0) { roundManager.backgroundIndex = 1 }
                    
                    initBackground(number: roundManager.backgroundIndex);
                }
            }
            
            if(roundManager.roundNumbers[1] == 5)
            {
                roundManager.increaseLifeAndSpeed()
            }
            
            if(roundManager.roundNumbers[1] == 9)
            {
                roundManager.roundNumbers[1] = 0
                roundManager.roundNumbers[0] += 1
            }
            else
            {
                roundManager.roundNumbers[1] += 1
                roundManager.isBossRound = false
            }
        }
        
        if(roundManager.isBossRound && !roundManager.coinRound)
        {
            roundManager.billboard = SKSpriteNode(imageNamed: "BossBillboard")
            roundManager.billboard.name = "BossBillboard"
            let bSize = roundManager.billboard.size
            roundManager.billboard.size = CGSize(width: bSize.width,
                                     height: bSize.height)
            roundManager.billboard.anchorPoint = CGPoint(x: 0, y: 0)
            roundManager.billboard.position = CGPoint(x: 375 - bSize.width/2, y: 700)
            roundManager.billboard.zPosition = 100
            addChild(roundManager.billboard)
        }
        else if(roundManager.coinRound)
        {
            roundManager.billboard = SKSpriteNode(imageNamed: "CoinBillboard")
            roundManager.billboard.name = "CoinBillboard"
            let bSize = roundManager.billboard.size
            roundManager.billboard.size = CGSize(width: bSize.width,
                                     height: bSize.height)
            roundManager.billboard.anchorPoint = CGPoint(x: 0, y: 0)
            roundManager.billboard.position = CGPoint(x: 375 - bSize.width/2, y: 700)
            roundManager.billboard.zPosition = 100
            addChild(roundManager.billboard)
            
            initBackground(number: 2)
            
            roundManager.roundNumbers[1] = 1
        }
    }
    
    func initGameOver()
    {
        roundManager.startGameOver = false
        roundManager.gameOverSprite.name = "GameOver"
        let bSize = roundManager.gameOverSprite.size
        roundManager.gameOverSprite.size = CGSize(width: bSize.width,
                                 height: bSize.height)
        roundManager.gameOverSprite.anchorPoint = CGPoint(x: 0, y: 0)
        roundManager.gameOverSprite.position = CGPoint(x: 375 - bSize.width/2, y: 700)
        roundManager.gameOverSprite.zPosition = 100
        addChild(roundManager.gameOverSprite)
    }
    
    func initBullets(num: Int)
    {
        roundManager.bulletsSprite[0].removeFromParent()
        roundManager.bulletsSprite[1].removeFromParent()
        
        roundManager.bulletsSprite[0] = SKSpriteNode(imageNamed: "Points_" + String(roundManager.bullets[0]))
        roundManager.bulletsSprite[0].name = "Bullets_0"
        roundManager.bulletsSprite[0].size = CGSize(width: 22, height: 23)
        roundManager.bulletsSprite[0].anchorPoint = CGPoint(x: 0, y: 0)
        roundManager.bulletsSprite[0].position = CGPoint(x: 86 , y: 362)
        roundManager.bulletsSprite[0].zPosition = 105
        addChild(roundManager.bulletsSprite[0])
        
        roundManager.bulletsSprite[1] = SKSpriteNode(imageNamed: "Points_" + String(roundManager.bullets[1]))
        roundManager.bulletsSprite[1].name = "Bullets_1"
        roundManager.bulletsSprite[1].size = CGSize(width: roundManager.bulletsSprite[0].size.width,
                                                    height: roundManager.bulletsSprite[0].size.height)
        roundManager.bulletsSprite[1].anchorPoint = CGPoint(x: 0, y: 0)
        roundManager.bulletsSprite[1].position = CGPoint(x: roundManager.bulletsSprite[0].position.x + roundManager.bulletsSprite[0].size.width, y: roundManager.bulletsSprite[0].position.y)
        roundManager.bulletsSprite[1].zPosition = 105
        addChild(roundManager.bulletsSprite[1])
    }
    
    func initMistakes()
    {
        if(!roundManager.coinRound)
        {
            roundManager.mistakeSprite.removeFromParent()
            
            roundManager.mistakeSprite = SKSpriteNode(imageNamed: "Mistakes_" + String(roundManager.playerMistakes))
            roundManager.mistakeSprite.name = "Mistakes"
            roundManager.mistakeSprite.size = CGSize(width: roundManager.mistakeSprite.size.width * 3, height: roundManager.mistakeSprite.size.height * 2.9)
            roundManager.mistakeSprite.anchorPoint = CGPoint(x: 0, y: 0)
            roundManager.mistakeSprite.position = CGPoint(x: 280, y: 365)
            roundManager.mistakeSprite.zPosition = 105
            addChild(roundManager.mistakeSprite)
        }
        else
        {
            roundManager.mistakeSprite = SKSpriteNode(imageNamed: "GoodCoins_" + String(roundManager.coinCount))
            roundManager.mistakeSprite.name = "GoodCoins"
            roundManager.mistakeSprite.size = CGSize(width: roundManager.mistakeSprite.size.width * 3, height: roundManager.mistakeSprite.size.height * 2.9)
            roundManager.mistakeSprite.anchorPoint = CGPoint(x: 0, y: 0)
            roundManager.mistakeSprite.position = CGPoint(x: 280, y: 365)
            roundManager.mistakeSprite.zPosition = 105
            addChild(roundManager.mistakeSprite)
        }
    }
    
    func initHealth()
    {
        roundManager.healthSprite.removeFromParent()
        
        roundManager.healthSprite = SKSpriteNode(imageNamed: "Hearts_" + String(roundManager.playerHealth))
        roundManager.healthSprite.name = "Health"
        roundManager.healthSprite.size = CGSize(width: roundManager.healthSprite.size.width * 3, height: roundManager.healthSprite.size.height * 2.9)
        roundManager.healthSprite.anchorPoint = CGPoint(x: 0, y: 0)
        roundManager.healthSprite.position = CGPoint(x: 280, y: 340)
        roundManager.healthSprite.zPosition = 105
        addChild(roundManager.healthSprite)
    }
}
