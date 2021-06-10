//
//  MenuScene.swift
//  DuckHunt
//
//  Created by Alumne on 7/6/21.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {

    var logoSprite: SKSpriteNode!
    let logoPoint = CGPoint(x: -150, y: 500)

    var logoAction: SKAction?
    var logoActionKey: String?

    var startSprite: SKSpriteNode!
    let startPoint = CGPoint(x: 200, y: 400)
    let outPoint = CGPoint(x: -600, y: 400)

    var scoreSprite: SKSpriteNode!
    let scorePoint = CGPoint(x: 100, y: 200)
    var pointNodes: [SKSpriteNode]! = []
    var pointsPoint = CGPoint(x: 500, y: 225)

    let changeTime = 1
    var changeBool = true
    var timer = -1

    override func didMove(to _: SKView) {

        logoAnimation()
    }

    func logoAnimation() {
        logoSprite = SKSpriteNode(imageNamed: "MenuLogo")
        logoSprite.name = "MenuLogo"
        let bSize = logoSprite.size
        logoSprite.size = CGSize(width: bSize.width * 0.8,
                             height: bSize.height * 0.8)
        logoSprite.anchorPoint = CGPoint(x: 0, y: 0)
        logoSprite.position = CGPoint(x: logoPoint.x, y: logoPoint.y + 1000)
        logoSprite.zPosition = 100
        addChild(logoSprite)

        logoAction = SKAction.move(to: logoPoint, duration: 5)
        logoActionKey = "LogoAction"

        logoSprite.run(logoAction!, withKey: logoActionKey!)
    }

    func startText() {
        startSprite = SKSpriteNode(imageNamed: "TapToStart")
        startSprite.name = "MenuLogo"
        let bSize = startSprite.size
        startSprite.size = CGSize(width: bSize.width * 1.1,
                                  height: bSize.height * 1.1)
        startSprite.anchorPoint = CGPoint(x: 0, y: 0)
        startSprite.position = CGPoint(x: startPoint.x, y: startPoint.y)
        startSprite.zPosition = 100
        addChild(startSprite)
    }

    func getScore() -> [Int] {
        var score = [Int]()
        var index = 0

        let defaults = UserDefaults.standard

        for _ in 1...6 {
            score.append(defaults.integer(forKey: "BestScore_" + String(index)))
            index += 1
        }

        return score
    }

    func startPoints() {
        scoreSprite = SKSpriteNode(imageNamed: "TopScore")
        scoreSprite.name = "TopScore"
        let bSize = scoreSprite.size
        scoreSprite.size = CGSize(width: bSize.width * 1.1,
                                  height: bSize.height * 1.1)
        scoreSprite.anchorPoint = CGPoint(x: 0, y: 0)
        scoreSprite.position = CGPoint(x: scorePoint.x, y: scorePoint.y)
        scoreSprite.zPosition = 100
        addChild(scoreSprite)

        let internalScore = getScore()

        var index = 0

        for _ in 1...6 {
            do {
                pointNodes.append(SKSpriteNode(imageNamed: "Points_" + String(internalScore[index])))

                pointNodes[index].name = "PointSprite_" + String(index)
                pointNodes[index].position = CGPoint(x: pointsPoint.x, y: pointsPoint.y)
                pointNodes[index].size = CGSize(width: 28, height: 29)
                pointNodes[index].zPosition = 200
                addChild(pointNodes[index])

                pointsPoint.x += self.pointNodes[index].size.width

                index += 1
            }
        }
    }

    func startAnimation() {
        if logoSprite.position == logoPoint {
            timer += 10

            if timer % (700 * changeTime) == 0 {
                if changeBool {
                    startSprite.position = outPoint
                    changeBool = false
                } else {
                    timer = 0
                    startSprite.position = startPoint
                    changeBool = true
                }
            }

            print(timer / 700)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            if logoSprite.position == logoPoint {
                let gameScene = GameScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                self.scene?.view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
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
        let canAnimate = (logoSprite.position == logoPoint)
        if canAnimate && timer < 0 {
            startText()
            startPoints()
            timer = 0
        } else if canAnimate {
            startAnimation()
        }
    }
}
