//
//  DuckEnemy.swift
//  DuckHunt
//
//  Created by Alumne on 29/4/21.
//

import GameplayKit
import SpriteKit

enum MovementType { case RIGHT; case UP; case DIAGONAL_RIGH; case NONE }

struct Duck {
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
    
    var direction: CGPoint
    
    var movementDirection = MovementType.NONE
    
    var life: Int
    var speed: CGFloat
    var finalSpeed: CGPoint
    
    var points: [Int]
    
    var timer = 0
    
    var node: SKSpriteNode!
    
    init(duckType: Int, duckNumber: Int, duckPosition: CGPoint, dir: CGPoint){
        //Basics
        self.node = SKSpriteNode(imageNamed: "Duck" + String(duckType) + "_" + String(duckNumber))
        
        self.node?.size = CGSize(width: 120, height: 120)
        self.node.position = duckPosition
        self.node.zPosition = 10
        
        self.direction = dir
        
        //Animation Set
        switch duckType {
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
            
            self.life = 2
            self.speed = 1
            
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
            
            self.life = 1
            self.speed = 2
            
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

            self.life = 2
            self.speed = 2
            
            points = [0, 0, 1, 5, 0, 0]

        default:
            fatalError()
        }
        
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
        let deathMovement = SKAction.moveBy(x: 0, y: -1000, duration: 2)
        self.deathAction = SKAction.group([SKAction.repeatForever(deathAnimation), deathMovement])
        
        self.node.run(self.flyRightAction!, withKey: self.flyRightActionKey!)
        
    }
    
    mutating func checkHit(position: CGPoint) -> Bool
    {
        if(isInBounds(limitsX: CGPoint(x: getZeroZero(node: self.node).x, y: getZeroZero(node: self.node).x + self.node.size.width),
                      limitsY: CGPoint(x: getZeroZero(node: self.node).y, y: getZeroZero(node: self.node).y + self.node.size.height),
                      pos: position))
        {
            self.life -= 1
            
            if(life == 0)
            {
                self.node.removeAllActions()
                self.node.run(self.deathAction!, withKey: self.deathActionKey!)
            }
            else
            {
                self.node.run(self.hurtAction!, withKey: self.hurtActionKey!)
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
            if(node.position.y <= 500)
            {
                node.removeFromParent()
            }
        }
    }
    
    func mirrorSpriteArray(array: [SKTexture]) -> [SKTexture] //Revisar la funcion para todos los casos de rotacion
    {
        var ar = array
        for (index, _) in array.enumerated()
        {
            let text = SKSpriteNode(texture: array[index])
            text.scale(to: CGSize(width: -1, height: text.size.height))
            ar[index] = text.texture!
        }
        
        return ar
    }
    
    mutating func randomDirection()
    {
        self.direction = CGPoint(x: Int.random(in: -1...1), y: Int.random(in: -1...1))
        while(self.direction.x == 0 && self.direction.y == 0)
        {
            self.direction = CGPoint(x: Int.random(in: -1...1), y: Int.random(in: -1...1))
        }
        
        print(direction)
    }
    
    mutating func timerCount()
    {
        timer += 10
        //print(timer)
        
        if(timer % 600 == 0)
        {
            changeMovement()
        }
    }
    
    mutating func changeMovement()
    {
        randomDirection()
        self.finalSpeed = CGPoint(x: direction.x * speed * 10, y: direction.y * speed * 10)
        let movement = SKAction.moveBy(x: self.finalSpeed.x, y: self.finalSpeed.y, duration: 1)
                
        node.removeAllActions()
        
        if(direction.x == 1 && direction.y == 0) //Derecha
        {
            let animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.10)
            self.flyRightAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
            
            self.node.run(self.flyRightAction!, withKey: self.flyRightActionKey!)
        }
        else if(direction.x == -1 && direction.y == 0) //Izquierda
        {
            let left = mirrorSpriteArray(array: self.flyRightAnimation!)
            let animation0 = SKAction.animate(with: left, timePerFrame: 0.10)
            self.flyRightAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
            
            self.node.run(self.flyRightAction!, withKey: self.flyRightActionKey!)
        }
        else if(direction.x == 0 && direction.y == 1) //Arriba
        {
            let animation0 = SKAction.animate(with: flyUpAnimation!, timePerFrame: 0.10)
            self.flyUpAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
            
            self.node.run(self.flyUpAction!, withKey: self.flyUpActionKey!)
        }
        else if(direction.x == 0 && direction.y == -1) //Abajo
        {
            let down = mirrorSpriteArray(array: self.flyUpAnimation!)
            let animation0 = SKAction.animate(with: down, timePerFrame: 0.10)
            self.flyUpAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
            
            self.node.run(self.flyUpAction!, withKey: self.flyUpActionKey!)
        }
        
        var diferent = self.flyDiagonalAnimation!
        
        if(direction.x == 1 && direction.y == 1) //Arriba - Derecha
        {
            let animation0 = SKAction.animate(with: flyDiagonalAnimation!, timePerFrame: 0.10)
            self.flyDiagonalAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
            
            self.node.run(self.flyDiagonalAction!, withKey: self.flyDiagonalActionKey!)
        }
        else if(direction.x == -1 && direction.y == 1) //Arriba - Izquierda
        {
            diferent = mirrorSpriteArray(array: self.flyDiagonalAnimation!)
        }
        else if(direction.x == 1 && direction.y == -1) //Abajo - Derecha
        {
            diferent = mirrorSpriteArray(array: self.flyDiagonalAnimation!)
        }
        else if(direction.x == -1 && direction.y == -1) //Abajo - Izquierda
        {
            diferent = mirrorSpriteArray(array: self.flyDiagonalAnimation!)
        }
        
        if(direction.x != 0 && direction.y != 0)
        {
            let animation0 = SKAction.animate(with: diferent, timePerFrame: 0.10)
            self.flyDiagonalAction = SKAction.group([SKAction.repeatForever(animation0), SKAction.repeatForever(movement)])
            
            self.node.run(self.flyDiagonalAction!, withKey: self.flyDiagonalActionKey!)
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

private let flyRight1ActionKey = "FlyRight1"
private let flyRight2ActionKey = "FlyRight2"
private let flyRight3ActionKey = "FlyRight3"

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

private let flyDiagonal1ActionKey = "FlyDiagonal1"
private let flyDiagonal2ActionKey = "FlyDiagonal2"
private let flyDiagonal3ActionKey = "FlyDiagonal3"

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

private let flyUp1ActionKey = "FlyUp1"
private let flyUp2ActionKey = "FlyUp2"
private let flyUp3ActionKey = "FlyUp3"

//Hurt Animations
private let hurt1Animation = [SKTexture(imageNamed: "Duck1_9")]
private let hurt2Animation  = [SKTexture(imageNamed: "Duck2_9")]
private let hurt3Animation  = [SKTexture(imageNamed: "Duck3_9")]

private let hurt1ActionKey = "Hurt1"
private let hurt2ActionKey = "Hurt2"
private let hurt3ActionKey = "Hurt3"

//Death Animations
private let death1Animation = [SKTexture(imageNamed: "Duck1_10")]
private let death2Animation  = [SKTexture(imageNamed: "Duck2_10")]
private let death3Animation  = [SKTexture(imageNamed: "Duck3_10")]

private let death1ActionKey = "Death1"
private let death2ActionKey = "Death2"
private let death3ActionKey = "Death3"
