//
//  GameScene.swift
//  DuckHunt
//
//  Created by Alumne on 22/4/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var background = SKSpriteNode()

    let gameLimitsX = CGPoint(x: 0, y: 750)
    let gameLimitsY = CGPoint(x: 480, y: 1000)

    var aimSprite: SKSpriteNode!

    var initPos = CGPoint(x: -100, y: 900)

    var roundManager: Round!

    // Points
    var score = 0

    var points = Points()

    var inChecker = 0

    var gameOverTimer = 0
    let gameOverTimeTransition = 5

    override func didMove(to _: SKView) {
        // Enemies
        roundManager = Round(gLimX: gameLimitsX, gLimY: gameLimitsY)

        // Background
        initBackground(number: roundManager.backgroundIndex)

        // Points
        initPoints()

        // Aim
        initAim()

        initMistakes()
        initHealth()
    }

    func addDucks() {
        for (index, _) in roundManager.ducks.enumerated() {
            addChild(roundManager.ducks[index].node)
        }
    }

    func addBoss() {
        addChild(roundManager.boss.node)
        addChild(roundManager.boss.explosionNode)
    }

    func loadMenu() {
        let gameScene = GameScene(fileNamed: "MenuScene")!
        gameScene.scaleMode = .aspectFill
        self.scene?.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if !roundManager.gameOver {
                if isInBounds(limitsX: gameLimitsX, limitsY: gameLimitsY, pos: touch.location(in: self)) && roundManager.numBullets > 0 && !roundManager.billboardFlags[0] {
                    aimSprite.position = touch.location(in: self)

                    var isBulletShot = [true, true]

                    for (index, _) in roundManager.ducks.enumerated() {
                        if roundManager.ducks[index].checkHit(position: touch.location(in: self)) {
                            if roundManager.ducks[index].isDead() {
                                points.updateScore(pointsAdded: roundManager.ducks[index].getPoints())
                            }
                        }

                        var eliminate = [CGPoint]()

                        for (index2, _) in roundManager.ducks[index].attacks.enumerated() {
                            if roundManager.ducks[index].attacks[index2].hitAttack(position: touch.location(in: self)) {
                                isBulletShot[index] = false
                                if roundManager.ducks[index].attacks[index2].mustDeleteAttack() {
                                    eliminate.append(CGPoint(x: index, y: index2))
                                }
                            }
                        }

                        if eliminate.count != 0 {
                            for (index2, _) in eliminate.enumerated() {
                                roundManager.ducks[Int(eliminate[index2].x)].attacks.remove(at: Int(eliminate[index2].y))
                            }
                        }
                    }

                    if roundManager.isBossRound {
                        if roundManager.boss.checkHit(position: touch.location(in: self)) {
                            if roundManager.boss.isDead() {
                                points.updateScore(pointsAdded: roundManager.boss.getPoints())
                            }
                        }

                        var eliminate = [CGPoint]()

                        for (index, _) in roundManager.boss.attacks.enumerated() {
                            if roundManager.boss.attacks[index].hitAttack(position: touch.location(in: self)) {
                                isBulletShot = [false, false]
                                if roundManager.boss.attacks[index].mustDeleteAttack() {
                                    eliminate.append(CGPoint(x: 0, y: index))
                                }
                            }
                        }

                        if eliminate.count != 0 {
                            var index = eliminate.count-1
                            for (_) in eliminate.enumerated() {
                                roundManager.boss.attacks.remove(at: Int(eliminate[index].y))
                                index -= 1
                            }
                        }
                    }

                    if isBulletShot[0] && isBulletShot[1] {
                        roundManager.shootBullet()
                        initBullets(num: roundManager.numBullets)
                    }
                } else {
                    aimSprite.position = CGPoint(x: -1000, y: -1000)
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
    
    // swiftlint:disable identifier_name
    func checkPerDuck(_roundResult: Int, _index: Int, _currentTime: TimeInterval)
    {
        if(_roundResult == 2) // Sigue jugando
        {
            roundManager.ducks[_index].shouldKillDuck()
            roundManager.ducks[_index].movementLogic()

            if roundManager.ducks[_index].addAttack {
                let num = roundManager.ducks[_index].attacks.count-1
                addChild(roundManager.ducks[_index].attacks[num].node)
                roundManager.ducks[_index].addAttack = false
            }

            var eliminate = [CGPoint]()
            for (index2, _) in roundManager.ducks[_index].attacks.enumerated() {
                if(roundManager.ducks[_index].attacks[index2].checkPlayerHit()) // Hits Player
                {
                    roundManager.playerHealth -= 1
                    eliminate.append(CGPoint(x: _index, y: index2))

                    if roundManager.playerHealth == 0 { roundManager.gameOver = true }
                    initHealth()
                } else {
                    roundManager.ducks[_index].attacks[index2].rockMovement(round: false, delta: _currentTime, orientation: 0)
                }
            }

            if eliminate.count != 0 {
                for (index2, _) in eliminate.enumerated() {
                    roundManager.ducks[Int(eliminate[index2].x)].attacks[Int(eliminate[index2].y)].node.removeFromParent()
                    roundManager.ducks[Int(eliminate[index2].x)].attacks.remove(at: Int(eliminate[index2].y))
                }
            }
        }
    }
    // swiftlint:enable identifier_name
    
    func showRound()
    {
        aimSprite.position.x = -2000
        if roundManager.addMistake {
            roundManager.addMistake = false
            roundManager.addMistakeFunc(mistakes: roundManager.ducksAlive)
            initMistakes()
        }

        if roundManager.returnToMistakes {
            initMistakes()
            roundManager.returnToMistakes = false
        }

        if !roundManager.billboardOn && !roundManager.gameOver {
            if arrayToScore(array: roundManager.roundNumbers) % roundManager.bossRound == 0 && !roundManager.isBossRound && !roundManager.coinRound {
                roundManager.isBossRound = true
            } else if roundManager.isBossRound {
                roundManager.isBossRound = false
                roundManager.coinRound = true

                initMistakes()
            } else if roundManager.coinRound && roundManager.coinCount == roundManager.maxCoins {
                roundManager.coinRound = false
                initMistakes()
            }

            initRoundNumber()
            roundManager.billboardOn = true
        }
    }

    override func update(_ currentTime: TimeInterval) {

        if !roundManager.gameOver {
            var roundResult = roundManager.nextRound()
            for (index, _) in roundManager.ducks.enumerated() {
                checkPerDuck(_roundResult: roundResult, _index: index, _currentTime: currentTime)
            }

            if(roundResult == 0) // Spawnea patos
            {
                roundManager.billboard.removeFromParent()
                roundManager.roundSprite[0].removeFromParent()
                roundManager.roundSprite[1].removeFromParent()
                roundManager.billboardOn = false

                if roundManager.returnToMistakes {
                    initMistakes()
                    roundManager.returnToMistakes = false
                }

                if roundManager.isBossRound && !roundManager.coinRound {
                    // Start Boss Fight
                    addBoss()

                } else {
                    addDucks()
                }

                initBullets(num: roundManager.numBullets)
                roundResult = -1
            } else if(roundResult == 1) // Muestra ronda
            {
                showRound()
            } else if roundManager.isBossRound && roundResult == 2 {
                roundManager.boss.bossMovement()

                if roundManager.boss.addAttack {
                    var index = 0
                    for _ in 1...2 {
                        addChild(roundManager.boss.attacks[index].node)
                        index += 1
                    }

                    roundManager.boss.addAttack = false
                }

                var eliminate = [CGPoint]()
                for (index, _) in roundManager.boss.attacks.enumerated() {
                    if(roundManager.boss.attacks[index].checkPlayerHit()) // Hits Player
                    {
                        if roundManager.playerHealth != 0 { roundManager.playerHealth -= 1 }
                        eliminate.append(CGPoint(x: 0, y: index))

                        if roundManager.playerHealth == 0 { roundManager.gameOver = true }
                        initHealth()
                    } else {
                        roundManager.boss.attacks[index].rockMovement(round: true, delta: currentTime, orientation: index)
                    }
                }

                if eliminate.count != 0 {
                    var index = eliminate.count-1
                    for (_) in eliminate.enumerated() {
                        roundManager.boss.attacks[Int(eliminate[index].y)].node.removeFromParent()
                        roundManager.boss.attacks.remove(at: Int(eliminate[index].y))
                        index -= 1
                    }
                }
            }
        } else {
            if roundManager.startGameOver {
                saveNewScore(points: points)
                initGameOver()
                gameOverTimer = 0
            }

            gameOverTimer += 10

            if gameOverTimer % (700 * gameOverTimeTransition) == 0 {
                loadMenu()
            }
        }
    }
}
