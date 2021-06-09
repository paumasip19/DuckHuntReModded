//
//  DuckEnemy.swift
//  DuckHunt
//
//  Created by Alumne on 29/4/21.
//

import GameplayKit
import SpriteKit

//Revisar sistema de cambio de movimiento en caso de pillarse con pared
enum MovementType:Int { case RIGHT = 0; case UP = 1; case DIAGONAL_RIGHT_UP = 2; case DIAGONAL_LEFT_UP = 3;
    case LEFT = 4; case DOWN = 5; case DIAGONAL_RIGHT_DOWN = 6; case DIAGONAL_LEFT_DOWN = 7; case NONE = 8 }

struct Duck {
    let duckIndex: Int
    var duckType: Int
    
    let flyRightAnimation: [SKTexture]?
    var flyRightAction: SKAction?
    let flyRightActionKey: String?
    
    let flyUpAnimation: [SKTexture]?
    var flyUpAction: SKAction?
    let flyUpActionKey: String?
    
    let flyDiagonalAnimation: [SKTexture]?
    var flyDiagonalAction: SKAction?
    let flyDiagonalActionKey: String?
    
    let hurtAnimation: [SKTexture]?
    var hurtAction: SKAction?
    let hurtActionKey: String?
    
    let deathAnimation: [SKTexture]?
    var deathAction: SKAction?
    let deathActionKey: String?
    
    var firstAnimation: [SKTexture]?
    var firstAction: SKAction?
    var firstActionKey: String?
    
    var coinAnimation: [SKTexture]?
    var coinAction: SKAction?
    var coinActionKey: String?
    
    let gameLimitsX: CGPoint
    let gameLimitsY: CGPoint
    
    var direction: CGPoint
    var originalScale: CGSize
    
    var movementType = MovementType.NONE
    var canMove: Bool
    
    var life: Int
    var speed: CGFloat
    var generalSpeed: CGFloat
    var finalSpeed: CGPoint
    
    var points: [Int]
    
    var timer = 0
    
    var initialPos: CGPoint
    var eneterPoint: CGPoint
    
    var lastPos: CGPoint
    
    var timeOut: Int
    var endRound: Bool
    
    var attackProbability: Int
    var addAttack = false
    
    var attacks = [Attack]()

    var node: SKSpriteNode!
    
    init(duckType: Int, duckNumber: Int, dir: CGPoint, gLimX: CGPoint, gLimY: CGPoint, extraSpeed: CGFloat,
         extraLife: CGFloat){
        
        self.duckType = duckType
        
        let golden = Int.random(in: 0...30)
        
        if(golden == 1 && duckType != 5)
        {
            self.duckType = 4
        }
        
        //Basics
        if(self.duckType != 5)
        {
            self.node = SKSpriteNode(imageNamed: "Duck" + String(self.duckType) + "_" + String(duckNumber))
        }
        else
        {
            self.node = SKSpriteNode(imageNamed: "Coin_0")
        }
        
        self.duckIndex = duckNumber
        self.timeOut = 10
        self.endRound = false
        
        let initPositionIndex = Int.random(in: 0...2)
        initialPos = initialDuckPositions[initPositionIndex]
        
        self.gameLimitsX = gLimX
        self.gameLimitsY = gLimY
        
        self.canMove = false
        
        self.node?.size = CGSize(width: 120, height: 120)
        self.node.position = initialPos
        self.node.zPosition = 10
        
        self.lastPos = self.node.position
        
        self.direction = dir
        
        self.eneterPoint = duckEnterPoint()
        
        self.generalSpeed = 10
        
        //Animation Set
        switch self.duckType {
        case 1:
            self.flyRightAnimation = flyRight1Animation
            self.flyRightActionKey = flyRight1ActionKey
            
            self.flyUpAnimation = flyUp1Animation
            self.flyUpActionKey = flyUp1ActionKey

            self.flyDiagonalAnimation = flyDiagonal1Animation
            self.flyDiagonalActionKey = flyDiagonal1ActionKey
        
            self.hurtAnimation = hurt1Animation
            self.hurtActionKey = hurt1ActionKey
            
            self.deathAnimation = death1Animation
            self.deathActionKey = death1ActionKey
            
            self.life = 2 + Int(extraLife)
            self.speed = 1 * self.generalSpeed * extraSpeed
            
            self.attackProbability = 1
            
            points = [0, 0, 1, 0, 0, 0]

        case 2:
            self.flyRightAnimation = flyRight2Animation
            self.flyRightActionKey = flyRight2ActionKey
            
            self.flyUpAnimation = flyUp2Animation
            self.flyUpActionKey = flyUp2ActionKey
            
            self.flyDiagonalAnimation = flyDiagonal2Animation
            self.flyDiagonalActionKey = flyDiagonal2ActionKey

            self.hurtAnimation = hurt2Animation
            self.hurtActionKey = hurt2ActionKey
            
            self.deathAnimation = death2Animation
            self.deathActionKey = death2ActionKey
            
            self.life = 1 + Int(extraLife)
            self.speed = 2 * self.generalSpeed * extraSpeed
            
            self.attackProbability = 2
            
            points = [0, 0, 0, 5, 0, 0]

        case 3:
            self.flyRightAnimation = flyRight3Animation
            self.flyRightActionKey = flyRight3ActionKey
            
            self.flyUpAnimation = flyUp3Animation
            self.flyUpActionKey = flyUp3ActionKey
            
            self.flyDiagonalAnimation = flyDiagonal3Animation
            self.flyDiagonalActionKey = flyDiagonal3ActionKey

            self.hurtAnimation = hurt3Animation
            self.hurtActionKey = hurt3ActionKey
            
            self.deathAnimation = death3Animation
            self.deathActionKey = death3ActionKey

            self.life = 2 + Int(extraLife)
            self.speed = 2 * self.generalSpeed * extraSpeed
            
            points = [0, 0, 1, 5, 0, 0]
            
            self.attackProbability = 2
            
        case 4:
            self.flyRightAnimation = flyRight4Animation
            self.flyRightActionKey = flyRight4ActionKey
            
            self.flyUpAnimation = flyUp4Animation
            self.flyUpActionKey = flyUp4ActionKey
            
            self.flyDiagonalAnimation = flyDiagonal4Animation
            self.flyDiagonalActionKey = flyDiagonal4ActionKey

            self.hurtAnimation = hurt4Animation
            self.hurtActionKey = hurt4ActionKey
            
            self.deathAnimation = death4Animation
            self.deathActionKey = death4ActionKey

            self.life = 3 + Int(extraLife)
            self.speed = 3 * self.generalSpeed * extraSpeed
            
            points = [0, 0, 3, 0, 0, 0]
            
            self.attackProbability = 3
            
        case 5:
            
            self.node?.size = CGSize(width: 50, height: 50)
            self.flyRightAnimation = flyRight4Animation
            self.flyRightActionKey = flyRight4ActionKey
            
            self.flyUpAnimation = flyUp4Animation
            self.flyUpActionKey = flyUp4ActionKey
            
            self.flyDiagonalAnimation = flyDiagonal4Animation
            self.flyDiagonalActionKey = flyDiagonal4ActionKey

            self.hurtAnimation = hurt4Animation
            self.hurtActionKey = hurt4ActionKey
            
            self.deathAnimation = death4Animation
            self.deathActionKey = death4ActionKey

            self.life = 1
            self.speed = 2 * self.generalSpeed * extraSpeed
            
            points = [0, 0, 2, 0, 0, 0]
            
            self.attackProbability = 0

        default:
            fatalError()
        }
        
        self.coinAnimation = coinAnim
        self.coinActionKey = coinActionK
        
        self.finalSpeed = CGPoint(x: direction.x * speed * 10, y: direction.y * speed * 10)
        
        let movement = SKAction.moveBy(x: self.finalSpeed.x, y: self.finalSpeed.y, duration: 1)
        
        let animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.10)
        self.flyRightAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
        
        let animation1 = SKAction.animate(with: self.flyUpAnimation!, timePerFrame: 0.10)
        self.flyUpAction = SKAction.group([SKAction.repeatForever(animation1), SKAction.repeatForever(movement)])
        
        let animation2 = SKAction.animate(with: self.flyDiagonalAnimation!, timePerFrame: 0.10)
        self.flyDiagonalAction = SKAction.group([SKAction.repeatForever(animation2), SKAction.repeatForever(movement)])
        
        let hurtAnimation = SKAction.animate(with: self.hurtAnimation!, timePerFrame: 0.10)
        self.hurtAction = SKAction.group([SKAction.repeat(hurtAnimation, count: 3), SKAction.repeatForever(movement)])
        
        let deathAnimation = SKAction.animate(with: self.deathAnimation!, timePerFrame: 0.10)
        let deathMovement = SKAction.moveBy(x: 0, y: -3000, duration: 6)
        self.deathAction = SKAction.group([SKAction.repeatForever(deathAnimation), deathMovement])
        
        self.node.run(self.flyRightAction!, withKey: self.flyRightActionKey!)
        
        self.originalScale = CGSize(width: self.node.xScale, height: self.node.yScale)
        
        node.removeAllActions()
        
        self.setInOutAnimation(duckType: self.duckType, initPositionIndex: initPositionIndex, enter: true)
    }
    
    mutating func setInOutAnimation(duckType: Int, initPositionIndex: Int, enter: Bool)
    {
        var movement = SKAction.move(to: self.eneterPoint, duration: 1)
        var animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.05)
        
        if(enter)
        {
            if(duckType != 5) { self.firstActionKey = "First" }
            else
            {
                self.deathAction = SKAction.moveBy(x: 0, y: -3000, duration: 6)
                
                self.firstActionKey = self.coinActionKey
                let positions = calculateCoinPositions()
                self.node.position = positions[0]
                movement = SKAction.move(to: positions[1], duration: 2)
                animation0 = SKAction.animate(with: self.coinAnimation!, timePerFrame: 0.05)
            }
        }
        else
        {
            movement = SKAction.move(to: self.initialPos, duration: 1)
        }
        
        if(duckType == 1)
        {
            if(initPositionIndex == 0 || initPositionIndex == 2)
            {
                self.firstAnimation = flyRight1Animation
                self.firstActionKey! += flyRightActionKey!
                
                animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.05)
            }
            else if(initPositionIndex == 1)
            {
                self.firstAnimation = flyUp1Animation
                self.firstActionKey! += flyUpActionKey!
                
                animation0 = SKAction.animate(with: self.flyUpAnimation!, timePerFrame: 0.05)
            }
        }
        else if(duckType == 2)
        {
            if(initPositionIndex == 0 || initPositionIndex == 2)
            {
                self.firstAnimation = flyRight2Animation
                self.firstActionKey! += flyRightActionKey!
                
                animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.05)
            }
            else if(initPositionIndex == 1)
            {
                self.firstAnimation = flyUp2Animation
                self.firstActionKey! += flyUpActionKey!
                
                animation0 = SKAction.animate(with: self.flyUpAnimation!, timePerFrame: 0.05)
            }
        }
        else if(duckType == 3)
        {
            if(initPositionIndex == 0 || initPositionIndex == 2)
            {
                self.firstAnimation = flyRight3Animation
                self.firstActionKey! += flyRightActionKey!
                
                animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.05)
            }
            else if(initPositionIndex == 1)
            {
                self.firstAnimation = flyUp3Animation
                self.firstActionKey! += flyUpActionKey!
                
                animation0 = SKAction.animate(with: self.flyUpAnimation!, timePerFrame: 0.05)
            }
        }
        else if(duckType == 4)
        {
            if(initPositionIndex == 0 || initPositionIndex == 2)
            {
                self.firstAnimation = flyRight4Animation
                self.firstActionKey! += flyRightActionKey!
                
                animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.05)
            }
            else if(initPositionIndex == 1)
            {
                self.firstAnimation = flyUp4Animation
                self.firstActionKey! += flyUpActionKey!
                
                animation0 = SKAction.animate(with: self.flyUpAnimation!, timePerFrame: 0.05)
            }
        }
        
        self.firstAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
        self.node.run(self.firstAction!, withKey: self.firstActionKey!)
        
        
        if(enter)
        {
            if(initPositionIndex == 0) { self.setScale(scale: CGPoint(x: 1, y: 1)) }
            else if(initPositionIndex == 2) { self.setScale(scale: CGPoint(x: -1, y: 1)) }
            else if(initPositionIndex == 1) { self.setScale(scale: CGPoint(x: 1, y: -1)) }
        }
        else
        {
            if(initPositionIndex == 0) { self.setScale(scale: CGPoint(x: -1, y: 1)) }
            else if(initPositionIndex == 2) { self.setScale(scale: CGPoint(x: 1, y: 1)) }
            else if(initPositionIndex == 1) { self.setScale(scale: CGPoint(x: 1, y: 1)) }
        }
        
    }
    
    func calculateCoinPositions() -> [CGPoint]
    {
        var pos = [CGPoint]()
        var nums = [Int]()
        nums.append(Int.random(in: 0...1))
        nums.append(nums[0])
        while(nums[1] == nums[0]) { nums[1] = Int.random(in: 0...1) }
        
        var index = 0
        for _ in 0...1
        {
            if(nums[index] == 0)
            {
                pos.append(CGPoint(x: initialDuckPositions[0].x, y: CGFloat.random(in: self.gameLimitsY.x...self.gameLimitsY.y)))
            }
            else
            {
                pos.append(CGPoint(x: initialDuckPositions[2].x, y: CGFloat.random(in: self.gameLimitsY.x...self.gameLimitsY.y)))
            }
            
            index += 1
        }
    
        return pos
    }
    
    mutating func checkHit(position: CGPoint) -> Bool
    {
        if(isInBounds(limitsX: CGPoint(x: getZeroZero(node: self.node).x, y: getZeroZero(node: self.node).x + self.node.size.width),
                      limitsY: CGPoint(x: getZeroZero(node: self.node).y, y: getZeroZero(node: self.node).y + self.node.size.height),
                      pos: position) && !self.isDead())
        {
            self.life -= 1
            
            self.node.removeAllActions()
            
            if(life == 0)
            {
                self.node.run(self.deathAction!, withKey: self.deathActionKey!)
                self.setScale(scale: CGPoint(x: 1, y: 1))
            }
            else
            {
                self.node.run(self.hurtAction!, withKey: self.hurtActionKey!)
                self.setScale(scale: CGPoint(x: 1, y: 1))
            }
            return true
        }
        else
        {
            return false
        }
    }
    
    func getPoints() -> [Int]
    {
        if(life == 0)
        {
            return points
        }
        
        return [0, 0, 0, 0, 0, 0]
    }
    
    func isDead() -> Bool
    {
        if(life == 0)
        {
            return true
        }
        
        return false
    }
    
    func shouldKillDuck()
    {
        if(isDead())
        {
            if(node.position.y <= 510)
            {
                node.removeFromParent()
            }
        }
    }
    
    mutating func randomDirection()
    {
        self.direction = CGPoint(x: Int.random(in: -1...1), y: Int.random(in: -1...1))
        while(self.direction.x == 0 && self.direction.y == 0)
        {
            self.direction = CGPoint(x: Int.random(in: -1...1), y: Int.random(in: -1...1))
        }
        
        
    }
    
    mutating func getMovementType()
    {
        if(direction.x == 1 && direction.y == 0) { self.movementType = MovementType.RIGHT }
        else if(direction.x == -1 && direction.y == 0) { self.movementType = MovementType.LEFT }
        else if(direction.x == 0 && direction.y == 1) { self.movementType = MovementType.UP }
        else if(direction.x == 0 && direction.y == -1) { self.movementType = MovementType.DOWN }
        else if(direction.x == 1 && direction.y == 1) { self.movementType = MovementType.DIAGONAL_RIGHT_UP }
        else if(direction.x == -1 && direction.y == 1) { self.movementType = MovementType.DIAGONAL_LEFT_UP }
        else if(direction.x == 1 && direction.y == -1) { self.movementType = MovementType.DIAGONAL_RIGHT_DOWN }
        else if(direction.x == -1 && direction.y == -1) { self.movementType = MovementType.DIAGONAL_LEFT_DOWN }
    }
    
    mutating func getDirection()
    {
        if(self.movementType == MovementType.RIGHT) { self.direction = CGPoint(x: 1, y: 0) }
        else if(self.movementType == MovementType.LEFT) { self.direction = CGPoint(x: -1, y: 0) }
        else if(self.movementType == MovementType.UP) { self.direction = CGPoint(x: 0, y: 1) }
        else if(self.movementType == MovementType.DOWN) { self.direction = CGPoint(x: 0, y: -1) }
        else if(self.movementType == MovementType.DIAGONAL_RIGHT_UP) { self.direction = CGPoint(x: 1, y: 1) }
        else if(self.movementType == MovementType.DIAGONAL_LEFT_UP) { self.direction = CGPoint(x: -1, y: 1) }
        else if(self.movementType == MovementType.DIAGONAL_RIGHT_DOWN) { self.direction = CGPoint(x: 1, y: -1) }
        else if(self.movementType == MovementType.DIAGONAL_LEFT_DOWN) { self.direction = CGPoint(x: -1, y: -1) }
    }
    
    mutating func setScale(scale: CGPoint)
    {
        self.node.xScale = self.originalScale.width * scale.x
        self.node.yScale = self.originalScale.height * scale.y
    }
    
    mutating func makeAndRunAction()
    {
        if(!isDead())
        {
            let movement = SKAction.moveBy(x: self.finalSpeed.x, y: self.finalSpeed.y, duration: 1)
            
            if(self.movementType == .RIGHT || self.movementType == .LEFT)
            {
                let animation0 = SKAction.animate(with: flyRightAnimation!, timePerFrame: 0.10)
                self.flyRightAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
                
                self.node.run(self.flyRightAction!, withKey: self.flyRightActionKey!)
                
                if(self.movementType == .LEFT) { self.setScale(scale: CGPoint(x: -1, y: 1)) }
                else { self.setScale(scale: CGPoint(x: 1, y: 1)) }
            }
            else if(self.movementType == .UP || self.movementType == .DOWN)
            {
                let animation0 = SKAction.animate(with: flyUpAnimation!, timePerFrame: 0.10)
                self.flyUpAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
                
                self.node.run(self.flyUpAction!, withKey: self.flyUpActionKey!)
                
                if(self.movementType == .DOWN) { self.setScale(scale: CGPoint(x: 1, y: -1)) }
                else { self.setScale(scale: CGPoint(x: 1, y: 1)) }
            }
            else if(self.movementType == .DIAGONAL_RIGHT_UP || self.movementType == .DIAGONAL_LEFT_UP ||
                    self.movementType == .DIAGONAL_RIGHT_DOWN || self.movementType == .DIAGONAL_LEFT_DOWN)
            {
                let animation0 = SKAction.animate(with: flyDiagonalAnimation!, timePerFrame: 0.10)
                self.flyDiagonalAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
                
                self.node.run(self.flyDiagonalAction!, withKey: self.flyDiagonalActionKey!)
                
                if(self.movementType == .DIAGONAL_LEFT_UP || self.movementType == .DIAGONAL_LEFT_DOWN) { self.setScale(scale: CGPoint(x: -1, y: 1)) }
                else if(self.movementType == .DIAGONAL_RIGHT_UP || self.movementType == .DIAGONAL_RIGHT_DOWN){ self.setScale(scale: CGPoint(x: 1, y: 1)) }
            }
        }
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
    
    mutating func movementLogic()
    {
        timer += 10
        
        if(self.duckType != 5)
        {
            if(timer % 400 == 0 && !self.endRound)
            {
                if(!self.canMove) { self.canMove = true; }
                changeMovement()
            }
            else if(!self.isIn(limitsX: gameLimitsX, limitsY: gameLimitsY) && self.canMove && !self.endRound)
            {
                self.node.position = self.lastPos
                contraryMovement()
            }
            else
            {
                self.lastPos = self.node.position
            }
            
            if(timer % 700 * 3 == 0 && !isDead())
            {
                let at = Int.random(in: 0...25)
                if(at < self.attackProbability)
                {
                    attacks.append(Attack(pos: node.position, gX: gameLimitsX, gY: gameLimitsY))
                    addAttack = true
                }
            }
            
            if(timer % (700 * self.timeOut) == 0 && !self.isDead() && !self.endRound)
            {
                self.setInOutAnimation(duckType: self.duckType, initPositionIndex: self.getInitPosIndex(), enter: false)
                self.endRound = true
            }
        }
        else
        {
            //if()
        }
    }
    
    
    
    func getInitPosIndex() -> Int
    {
        var index = 0
        for _ in 1...3 {
            do {
                if(self.initialPos == initialDuckPositions[index])
                {
                    return index
                }
                index += 1
            }
        }
        
        return index
    }
    
    mutating func removeAllAttacks()
    {
        if(attacks.count != 0)
        {
            for (index, _) in attacks.enumerated()
            {
                attacks[index].node.removeFromParent()
            }
            
            attacks.removeAll()
        }
    }
        
    mutating func changeMovement()
    {
        if(!isDead())
        {
            randomDirection()
            self.finalSpeed = CGPoint(x: self.direction.x * self.speed * 10,
                                      y: self.direction.y * self.speed * 10)
  
            node.removeAllActions()
            
            self.getMovementType()
            self.makeAndRunAction()
        }
    }
    
    mutating func contraryMovement()
    {
        if(!isDead())
        {
            var index = 0
            
            for _ in 1...8 {
                do {
                    if(MovementType.RawValue(index) == self.movementType.rawValue)
                    {
                        break
                    }
                    index += 1
                }
            }
            print("Previous Type")
            print(self.movementType)
            /*if(self.movementType.rawValue < 4)
            {
                self.movementType = MovementType(rawValue: self.movementType.rawValue + 4)!
            }
            else { self.movementType = MovementType(rawValue: self.movementType.rawValue - 4)! }*/
            
            self.direction = CGPoint(x: -self.direction.x, y: -self.direction.y)
            getMovementType()
            
            print("Actual Type")
            print(self.movementType)
            
            self.getDirection()
            
            self.finalSpeed = CGPoint(x: self.direction.x * self.speed * 10,
                                      y: self.direction.y * self.speed * 10)
            
            //self.node.position.x = self.node.position.x + self.direction.x * 20
            //self.node.position.y = self.node.position.y + self.direction.y * 20
            
            node.removeAllActions()
            self.makeAndRunAction()
        }
    }
}

func getZeroZero(node: SKSpriteNode) -> CGPoint
{
    var point = CGPoint()
    
    point.x = node.position.x - node.size.width/2
    point.y = node.position.y - node.size.height/2
    
    return point
}

func duckEnterPoint() -> CGPoint
{
    let point = CGPoint(x: Int.random(in: 187...526), y: Int.random(in: 426...853))
    return point
}

private let initialDuckPositions = [CGPoint(x: -100, y: 640),
                                    CGPoint(x: 375, y: 1100),
                                    CGPoint(x: 850, y: 640)]

//Fly Right Animations
private let flyRight1Animation = [SKTexture(imageNamed: "Duck1_0"),
                                  SKTexture(imageNamed: "Duck1_1"),
                                  SKTexture(imageNamed: "Duck1_2"),
                                  SKTexture(imageNamed: "Duck1_1")]

private let flyRight2Animation = [SKTexture(imageNamed: "Duck2_0"),
                                  SKTexture(imageNamed: "Duck2_1"),
                                  SKTexture(imageNamed: "Duck2_2"),
                                  SKTexture(imageNamed: "Duck2_1")]

private let flyRight3Animation = [SKTexture(imageNamed: "Duck3_0"),
                                  SKTexture(imageNamed: "Duck3_1"),
                                  SKTexture(imageNamed: "Duck3_2"),
                                  SKTexture(imageNamed: "Duck3_1")]

private let flyRight4Animation = [SKTexture(imageNamed: "Duck4_0"),
                                  SKTexture(imageNamed: "Duck4_1"),
                                  SKTexture(imageNamed: "Duck4_2"),
                                  SKTexture(imageNamed: "Duck4_1")]

private let flyRight1ActionKey = "FlyRight1"
private let flyRight2ActionKey = "FlyRight2"
private let flyRight3ActionKey = "FlyRight3"
private let flyRight4ActionKey = "FlyRight4"

//Fly Diagonal Animations
private let flyDiagonal1Animation = [SKTexture(imageNamed: "Duck1_3"),
                                     SKTexture(imageNamed: "Duck1_4"),
                                     SKTexture(imageNamed: "Duck1_5"),
                                     SKTexture(imageNamed: "Duck1_4")]

private let flyDiagonal2Animation  = [SKTexture(imageNamed: "Duck2_3"),
                                      SKTexture(imageNamed: "Duck2_4"),
                                      SKTexture(imageNamed: "Duck2_5"),
                                      SKTexture(imageNamed: "Duck2_4")]

private let flyDiagonal3Animation  = [SKTexture(imageNamed: "Duck3_3"),
                                      SKTexture(imageNamed: "Duck3_4"),
                                      SKTexture(imageNamed: "Duck3_5"),
                                      SKTexture(imageNamed: "Duck3_4")]

private let flyDiagonal4Animation  = [SKTexture(imageNamed: "Duck4_3"),
                                      SKTexture(imageNamed: "Duck4_4"),
                                      SKTexture(imageNamed: "Duck4_5"),
                                      SKTexture(imageNamed: "Duck4_4")]

private let flyDiagonal1ActionKey = "FlyDiagonal1"
private let flyDiagonal2ActionKey = "FlyDiagonal2"
private let flyDiagonal3ActionKey = "FlyDiagonal3"
private let flyDiagonal4ActionKey = "FlyDiagonal4"

//Fly Up Animations
private let flyUp1Animation = [SKTexture(imageNamed: "Duck1_6"),
                               SKTexture(imageNamed: "Duck1_7"),
                               SKTexture(imageNamed: "Duck1_8"),
                               SKTexture(imageNamed: "Duck1_7")]

private let flyUp2Animation  = [SKTexture(imageNamed: "Duck2_6"),
                                SKTexture(imageNamed: "Duck2_7"),
                                SKTexture(imageNamed: "Duck2_8"),
                                SKTexture(imageNamed: "Duck2_7")]

private let flyUp3Animation  = [SKTexture(imageNamed: "Duck3_6"),
                                SKTexture(imageNamed: "Duck3_7"),
                                SKTexture(imageNamed: "Duck3_8"),
                                SKTexture(imageNamed: "Duck3_7")]

private let flyUp4Animation  = [SKTexture(imageNamed: "Duck4_6"),
                                SKTexture(imageNamed: "Duck4_7"),
                                SKTexture(imageNamed: "Duck4_8"),
                                SKTexture(imageNamed: "Duck4_7")]

private let flyUp1ActionKey = "FlyUp1"
private let flyUp2ActionKey = "FlyUp2"
private let flyUp3ActionKey = "FlyUp3"
private let flyUp4ActionKey = "FlyUp4"

//Hurt Animations
private let hurt1Animation = [SKTexture(imageNamed: "Duck1_9")]
private let hurt2Animation  = [SKTexture(imageNamed: "Duck2_9")]
private let hurt3Animation  = [SKTexture(imageNamed: "Duck3_9")]
private let hurt4Animation  = [SKTexture(imageNamed: "Duck4_9")]

private let hurt1ActionKey = "Hurt1"
private let hurt2ActionKey = "Hurt2"
private let hurt3ActionKey = "Hurt3"
private let hurt4ActionKey = "Hurt4"

//Death Animations
private let death1Animation = [SKTexture(imageNamed: "Duck1_10"),
                               SKTexture(imageNamed: "Duck1_11")]
private let death2Animation  = [SKTexture(imageNamed: "Duck2_10"),
                                SKTexture(imageNamed: "Duck2_11")]
private let death3Animation  = [SKTexture(imageNamed: "Duck3_10"),
                                SKTexture(imageNamed: "Duck3_11")]
private let death4Animation  = [SKTexture(imageNamed: "Duck4_10"),
                                SKTexture(imageNamed: "Duck4_11")]

private let death1ActionKey = "Death1"
private let death2ActionKey = "Death2"
private let death3ActionKey = "Death3"
private let death4ActionKey = "Death4"

//Coin Animation
private let coinAnim = [SKTexture(imageNamed: "Coin_0"),
                             SKTexture(imageNamed: "Coin_1"),
                             SKTexture(imageNamed: "Coin_2"),
                             SKTexture(imageNamed: "Coin_3"),
                             SKTexture(imageNamed: "Coin_4"),
                             SKTexture(imageNamed: "Coin_5")]

private let coinActionK = "Coins"
