//
//  DuckEnemy.swift
//  DuckHunt
//
//  Created by Alumne on 29/4/21.
//

import GameplayKit
import SpriteKit

struct Duck {
    let flyRightAnimation: [SKTexture]?
    var flyRightAction: SKAction?
    let flyRightActionKey: String?
    
    let flyDiagonalAnimation: [SKTexture]?
    var flyDiagonalAction: SKAction?
    let flyDiagonalActionKey: String?
    
    
    
    var node: SKSpriteNode!
    
    init(duckType: Int, duckNumber: Int, duckPosition: CGPoint){
        //Basics
        self.node = SKSpriteNode(imageNamed: "Duck" + String(duckType) + "_" + String(duckNumber))
        
        self.node?.size = CGSize(width: 120, height: 120)
        self.node.position = duckPosition
        
        self.node.zPosition = 10
        
        //Animation Set
        switch duckType {
        case 1:
            self.flyRightAnimation = flyRight1Animation
            self.flyRightActionKey = flyRight1ActionKey

            let animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.10)
            self.flyRightAction = SKAction.repeatForever(animation0)
            
            self.flyDiagonalAnimation = flyDiagonal1Animation
            self.flyDiagonalActionKey = flyDiagonal1ActionKey

            let animation1 = SKAction.animate(with: self.flyDiagonalAnimation!, timePerFrame: 0.10)
            self.flyDiagonalAction = SKAction.repeatForever(animation1)

        case 2:
            self.flyRightAnimation = flyRight2Animation
            self.flyRightActionKey = flyRight2ActionKey

            let animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.10)
            self.flyRightAction = SKAction.repeatForever(animation0)
            
            self.flyDiagonalAnimation = flyDiagonal2Animation
            self.flyDiagonalActionKey = flyDiagonal2ActionKey

            let animation1 = SKAction.animate(with: self.flyDiagonalAnimation!, timePerFrame: 0.10)
            self.flyDiagonalAction = SKAction.repeatForever(animation1)
            
        case 3:
            self.flyRightAnimation = flyRight3Animation
            self.flyRightActionKey = flyRight3ActionKey

            let animation0 = SKAction.animate(with: self.flyRightAnimation!, timePerFrame: 0.10)
            self.flyRightAction = SKAction.repeatForever(animation0)
            
            self.flyDiagonalAnimation = flyDiagonal3Animation
            self.flyDiagonalActionKey = flyDiagonal3ActionKey

            let animation1 = SKAction.animate(with: self.flyDiagonalAnimation!, timePerFrame: 0.10)
            self.flyDiagonalAction = SKAction.repeatForever(animation1)
        default:
            fatalError()
        }
                
        self.node.run(self.flyRightAction!, withKey: self.flyRightActionKey!)
        
    }
    
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
