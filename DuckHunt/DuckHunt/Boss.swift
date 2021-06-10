//
//  Boss.swift
//  DuckHunt
//
//  Created by Alumne on 9/6/21.
//

import GameplayKit
import SpriteKit

struct Boss // let bombSound = SKAction.playSoundFileNamed("bomb.wav", waitForCompletion: false)
{
    let runAnimation: [SKTexture]?
    var runAction: SKAction?
    let runActionKey: String?

    let smellAnimation: [SKTexture]?
    var smellAction: SKAction?
    let smellActionKey: String?

    let jumpAnimation: [SKTexture]?
    var jumpAction: SKAction?
    let jumpActionKey: String?

    let fallAnimation: [SKTexture]?
    var fallAction: SKAction?
    let fallActionKey: String?

    let initialPos: CGPoint
    var lastPos: CGPoint

    var life: Int = -1

    let gameLimitsX: CGPoint
    let gameLimitsY: CGPoint

    var direction: CGPoint
    var originalScale: CGSize

    var speed: CGFloat
    var generalSpeed: CGFloat = 100
    var finalSpeed: CGPoint

    var points: [Int]

    var attackProbability: Int
    var addAttack = false

    var attacks = [Attack]()

    var timer = 0
    var attackTimer = 0
    var hasJumped = false

    var node: SKSpriteNode
    var explosionNode: SKSpriteNode

    let explosionAnimation: [SKTexture]?
    var explosionAction: SKAction?
    let explosionActionKey: String?

    var jumpPoints = [CGPoint(), CGPoint()]
    var isFalling = false

    init(gLimX: CGPoint, gLimY: CGPoint, extraSpeed: CGFloat) {
        speed = generalSpeed * extraSpeed

        let rand = Int.random(in: 0...1)
        initialPos = initialPositions[rand]

        if rand == 0 {
            direction = CGPoint(x: 1, y: 0)
        } else {
            direction = CGPoint(x: -1, y: 0)
        }

        node = SKSpriteNode(imageNamed: "Boss_0")
        node.name = "Boss"
        node.size = CGSize(width: 200, height: 200)
        node.position = initialPos
        node.zPosition = 10

        explosionNode = SKSpriteNode(imageNamed: "BossHits_0")
        explosionNode.name = "BossExplosion"
        explosionNode.size = CGSize(width: 500, height: 500)
        explosionNode.position = CGPoint(x: -2000, y: 0)
        explosionNode.zPosition = 11

        self.lastPos = self.node.position

        self.gameLimitsX = CGPoint(x: gLimX.x + node.size.width/2, y: gLimX.y - node.size.width/2)
        self.gameLimitsY = gLimY

        jumpPoints[0] = CGPoint(x: 375, y: 640)

        points = [0, 0, 8, 0, 0, 0]

        self.attackProbability = 20

        self.runAnimation = runAnim
        self.runActionKey = runActionK

        self.smellAnimation = smellAnim
        self.smellActionKey = smellActionK

        self.jumpAnimation = jumpAnim
        self.jumpActionKey = jumpActionK

        self.fallAnimation = fallAnim
        self.fallActionKey = fallActionK

        self.explosionAnimation = explosionAnim
        self.explosionActionKey = explosionActionK

        self.smellAction = SKAction.animate(with: self.smellAnimation!, timePerFrame: 0.1)
        self.jumpAction = SKAction.animate(with: self.jumpAnimation!, timePerFrame: 0.1)
        self.fallAction = SKAction.animate(with: self.fallAnimation!, timePerFrame: 0.1)

        self.finalSpeed = CGPoint(x: direction.x * speed * 10, y: direction.y * speed * 10)

        let movement = SKAction.moveBy(x: self.finalSpeed.x, y: self.finalSpeed.y, duration: 2)

        let animation0 = SKAction.animate(with: self.runAnimation!, timePerFrame: Double(generalSpeed)/1000)
        self.runAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])

        self.node.run(self.runAction!, withKey: self.runActionKey!)

        self.originalScale = CGSize(width: self.node.xScale, height: self.node.yScale)

        setScale(scale: CGPoint(x: direction.x, y: 1))

        self.explosionAction = SKAction.animate(with: self.explosionAnimation!, timePerFrame: 0.03)
    }

    mutating func bossMovement() {
        changeDirection()

        actions()
    }

    func moveExplosion() {
        self.explosionNode.position.x = -2000
    }

    func addExplosion() {
        self.explosionNode.run(explosionAction!, completion: moveExplosion)
    }

    mutating func setRunAction() {
        finalSpeed = CGPoint(x: direction.x * speed * 10, y: direction.y * speed * 10)

        node.removeAllActions()

        let movement = SKAction.moveBy(x: self.finalSpeed.x, y: self.finalSpeed.y, duration: 2)
        let animation0 = SKAction.animate(with: self.runAnimation!, timePerFrame: Double(generalSpeed)/1000)
        self.runAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
        self.node.run(self.runAction!, withKey: self.runActionKey!)
    }

    mutating func changeDirection() {
        if node.position.x <= gameLimitsX.x || node.position.x >= gameLimitsX.y {
            direction.x = -direction.x
            setRunAction()
            setScale(scale: CGPoint(x: direction.x, y: 1))
        }
    }

    func smell() {
        self.node.removeAllActions()
        self.node.run(jumpAction!, completion: jump)
    }

    func jump() {
        self.node.removeAllActions()
        self.node.run(fallAction!, completion: removeAction)
    }

    func removeAction() {
        self.node.removeAllActions()
    }

    func fall() {
        self.node.removeAllActions()
        self.node.run(fallAction!)
    }

    mutating func prepareJump() {
        if (self.node.position.x > jumpPoints[0].x && direction.x == 1) ||
            (self.node.position.x < jumpPoints[0].x && direction.x == -1) {
            direction.x = -direction.x
            setScale(scale: CGPoint(x: direction.x, y: 1))
        }

        jumpPoints[1] = CGPoint(x: jumpPoints[0].x + (direction.x * (abs(jumpPoints[0].x - self.node.position.x))), y: self.node.position.y)

        self.jumpAction = SKAction.group([SKAction.animate(with: self.jumpAnimation!, timePerFrame: 0.1), SKAction.move(to: jumpPoints[0], duration: 0.5)])

        self.fallAction = SKAction.group([SKAction.animate(with: self.fallAnimation!, timePerFrame: 0.1), SKAction.move(to: jumpPoints[1], duration: 0.5)])

        self.hasJumped = true

    }

    mutating func addAttackFunc() {
        let at = Int.random(in: 0...25)
        if at < self.attackProbability {
            var index = 0
            var offset: CGPoint
            for _ in 1...2 {

                if index == 0 {
                    offset = CGPoint(x: jumpPoints[0].x + 30, y: jumpPoints[0].y)
                } else {
                    offset = CGPoint(x: jumpPoints[0].x - 30, y: jumpPoints[0].y)
                }
                attacks.append(Attack(pos: offset, gX: gameLimitsX, gY: gameLimitsY))
                addAttack = true
                index += 1
            }
        }
    }

    mutating func actions() {
        timer += 10

        if !self.isIn(limitsX: gameLimitsX, limitsY: gameLimitsY) {
            self.node.position = self.lastPos
        } else {
            self.lastPos = self.node.position
        }

        if !node.hasActions() {
            if !isFalling {
                fall()
                isFalling = true
            }

            if isFalling {
                setRunAction()
                isFalling = false
            }

        }

        if hasJumped {
            attackTimer += 10

            if attackTimer % Int(700 * 0.6) == 0 {
                attackTimer = 0
                hasJumped = false
                addAttackFunc()
            }
        }

        if timer % (700 * 5) == 0 {
            prepareJump()

            self.node.removeAllActions()
            self.node.run(smellAction!, completion: smell)
        }

        if(timer % (700 * 10) == 0) // Resetar temporizador
        {
            timer = 0
        }
    }

    func isDead() -> Bool {
        if life == 0 {
            return true
        }

        return false
    }

    mutating func removeAllAttacks() {
        if attacks.count != 0 {
            for (index, _) in attacks.enumerated() {
                attacks[index].node.removeFromParent()
            }

            attacks.removeAll()
        }
    }

    func shouldKillBoss() {
        if isDead() {
            node.removeFromParent()
            explosionNode.removeFromParent()
        }
    }

    mutating func checkHit(position: CGPoint) -> Bool {
        if isInBounds(limitsX: CGPoint(x: getZeroZero(node: self.node).x, y: getZeroZero(node: self.node).x + self.node.size.width),
                      limitsY: CGPoint(x: getZeroZero(node: self.node).y, y: getZeroZero(node: self.node).y + self.node.size.height),
                      pos: position) && !self.isDead() {
            self.life -= 1

            // self.node.removeAllActions()

            if(life != 0) // REVISAR
            {
                self.explosionNode.position = position
                self.explosionNode.position.y += 10
                addExplosion()
            }

            return true
        } else {
            return false
        }
    }

    func getPoints() -> [Int] {
        if life == 0 {
            return points
        }

        return [0, 0, 0, 0, 0, 0]
    }

    func getZeroZero(node: SKSpriteNode) -> CGPoint {
        var point = CGPoint()

        point.x = node.position.x - node.size.width/2
        point.y = node.position.y - node.size.height/2

        return point
    }

    func isIn(limitsX: CGPoint, limitsY: CGPoint) -> Bool {
        if self.node.position.x < limitsX.y && self.node.position.x > limitsX.x &&
           self.node.position.y < limitsY.y && self.node.position.y > limitsY.x {
            return true
        } else {
            return false
        }
    }

    mutating func setScale(scale: CGPoint) {
        self.node.xScale = self.originalScale.width * scale.x
        self.node.yScale = self.originalScale.height * scale.y
    }
}

private let initialPositions = [CGPoint(x: 300, y: 530),
                                CGPoint(x: 300, y: 530)]

// Animations
private let runAnim = [SKTexture(imageNamed: "Boss_0"),
                            SKTexture(imageNamed: "Boss_1"),
                            SKTexture(imageNamed: "Boss_2"),
                            SKTexture(imageNamed: "Boss_3")]

private let runActionK = "BossRun"

private let smellAnim = [SKTexture(imageNamed: "Boss_3"),
                              SKTexture(imageNamed: "Boss_4"),
                              SKTexture(imageNamed: "Boss_3"),
                              SKTexture(imageNamed: "Boss_4"),
                              SKTexture(imageNamed: "Boss_5")]

private let smellActionK = "BossSmell"

private let jumpAnim = [SKTexture(imageNamed: "Boss_6")]

private let jumpActionK = "BossJump"

private let fallAnim = [SKTexture(imageNamed: "Boss_7")]

private let fallActionK = "BossFall"

private let explosionAnim = [SKTexture(imageNamed: "BossHits_0"),
                             SKTexture(imageNamed: "BossHits_1"),
                             SKTexture(imageNamed: "BossHits_2"),
                             SKTexture(imageNamed: "BossHits_3"),
                             SKTexture(imageNamed: "BossHits_4"),
                             SKTexture(imageNamed: "BossHits_5"),
                             SKTexture(imageNamed: "BossHits_6"),
                             SKTexture(imageNamed: "BossHits_7"),
                             SKTexture(imageNamed: "BossHits_8"),
                             SKTexture(imageNamed: "BossHits_9"),
                             SKTexture(imageNamed: "BossHits_10"),
                             SKTexture(imageNamed: "BossHits_11"),
                             SKTexture(imageNamed: "BossHits_12"),
                             SKTexture(imageNamed: "BossHits_13"),
                             SKTexture(imageNamed: "BossHits_14"),
                             SKTexture(imageNamed: "BossHits_15"),
                             SKTexture(imageNamed: "BossHits_16")]

private let explosionActionK = "Explosion"
