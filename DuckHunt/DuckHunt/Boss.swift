//
//  Boss.swift
//  DuckHunt
//
//  Created by Alumne on 9/6/21.
//

import GameplayKit
import SpriteKit

struct Boss
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
    
    var life: Int
    
    let gameLimitsX: CGPoint
    let gameLimitsY: CGPoint
    
    var direction: CGPoint
    var originalScale: CGSize
    
    var speed: CGFloat
    var generalSpeed: CGFloat = 100
    var finalSpeed: CGPoint
    
    var points: [Int]
    
    /*var attackProbability: Int
    var addAttack = false*/
    
    var attacks = [Attack]()
    
    var timer = 0
    
    var node: SKSpriteNode
    
    init(gLimX: CGPoint, gLimY: CGPoint)
    {
        life = 1
        
        speed = generalSpeed //* extraSpeed
        
        
        let rand = Int.random(in: 0...1)
        initialPos = initialPositions[rand]
        
        if(rand == 0)
        {
            direction = CGPoint(x: 1, y: 0)
        }
        else
        {
            direction = CGPoint(x: -1, y: 0)
        }
        
        node = SKSpriteNode(imageNamed: "Boss_0")
        node.name = "Boss"
        node.size = CGSize(width: 200, height: 200)
        node.position = initialPos
        node.zPosition = 10
        
        self.lastPos = self.node.position
        
        self.gameLimitsX = CGPoint(x: gLimX.x + node.size.width/2, y: gLimX.y - node.size.width/2)
        self.gameLimitsY = gLimY
        
        points = [0, 0, 8, 0, 0, 0]
        
        self.runAnimation = runAnim
        self.runActionKey = runActionK
        
        self.smellAnimation = smellAnim
        self.smellActionKey = smellActionK
        
        self.jumpAnimation = jumpAnim
        self.jumpActionKey = jumpActionK
        
        self.fallAnimation = fallAnim
        self.fallActionKey = fallActionK
        
        self.finalSpeed = CGPoint(x: direction.x * speed * 10, y: direction.y * speed * 10)
        
        let movement = SKAction.moveBy(x: self.finalSpeed.x, y: self.finalSpeed.y, duration: 2)
        
        let animation0 = SKAction.animate(with: self.runAnimation!, timePerFrame: Double(generalSpeed)/1000)
        self.runAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
        
        self.node.run(self.runAction!, withKey: self.runActionKey!)
        
        self.originalScale = CGSize(width: self.node.xScale, height: self.node.yScale)
        
        setScale(scale: CGPoint(x: direction.x, y: 1))
    }
    
    mutating func bossMovement()
    {
        changeDirection()
        
        actions()
    }

    mutating func changeDirection()
    {
        if(node.position.x <= gameLimitsX.x || node.position.x >= gameLimitsX.y)
        {
            direction.x = -direction.x
            finalSpeed = CGPoint(x: direction.x * speed * 10, y: direction.y * speed * 10)
            
            node.removeAllActions()
            
            let movement = SKAction.moveBy(x: self.finalSpeed.x, y: self.finalSpeed.y, duration: 2)
            let animation0 = SKAction.animate(with: self.runAnimation!, timePerFrame: Double(generalSpeed)/1000)
            self.runAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
            self.node.run(self.runAction!, withKey: self.runActionKey!)
            
            setScale(scale: CGPoint(x: direction.x, y: 1))
        }
    }
    
    mutating func actions()
    {
        timer += 10
        
        if(!self.isIn(limitsX: gameLimitsX, limitsY: gameLimitsY))
        {
            self.node.position = self.lastPos
        }
        else
        {
            self.lastPos = self.node.position
        }
        
        if(timer % 10 == 0) //Resetar temporizador
        {
            timer = 0
        }
    }
    
    func getZeroZero(node: SKSpriteNode) -> CGPoint
    {
        var point = CGPoint()
        
        point.x = node.position.x - node.size.width/2
        point.y = node.position.y - node.size.height/2
        
        return point
    }
    
    func isIn(limitsX: CGPoint, limitsY: CGPoint) -> Bool
    {
        if(self.node.position.x < limitsX.y && self.node.position.x > limitsX.x &&
           self.node.position.y < limitsY.y && self.node.position.y > limitsY.x)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    mutating func setScale(scale: CGPoint)
    {
        self.node.xScale = self.originalScale.width * scale.x
        self.node.yScale = self.originalScale.height * scale.y
    }
}




private let initialPositions = [CGPoint(x: 300, y: 530),
                                CGPoint(x: 300, y: 530)]

//Animations
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
