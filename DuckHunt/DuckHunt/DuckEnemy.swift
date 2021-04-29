//
//  DuckEnemy.swift
//  DuckHunt
//
//  Created by Alumne on 29/4/21.
//

import GameplayKit
import SpriteKit

struct CompleteAnimation{
    let animation: [SKTexture]?
    var action: SKAction?
    let actionKey: String?
    
    init(_animation: [SKTexture], _action: SKAction, _actionKey: String) {
        animation = _animation
        action = _action
        actionKey = _actionKey
    }
}

struct Duck {
    var flyRight: CompleteAnimation!
    var flyDiagonal: CompleteAnimation!
    var flyUp: CompleteAnimation!
    
    var node: SKSpriteNode!
    
    init(duckType: Int, duckNumber: Int){
        //Basics
        self.node = SKSpriteNode(imageNamed: "Duck" + String(duckType) + "_" + String(duckNumber))
        
        self.node?.size = CGSize(width: 120, height: 120)
        self.node.position = CGPoint(x: 100, y: 100)
        
        self.node.zPosition = 10
        
        //Animation Set
        switch duckType {
        case 1:
            self.flyRight = CompleteAnimation(_animation: flyRight1Animation, _action: flyRight1Action, _actionKey: flyRight1ActionKey)

            let animation = SKAction.animate(with: flyRight1Animation, timePerFrame: 0.10)
            self.flyRight.action = SKAction.repeatForever(animation)
            
            
        case 2:
            self.flyRight = CompleteAnimation(_animation: flyRight2Animation, _action: flyRight2Action, _actionKey: flyRight2ActionKey)
            self.flyRight.action = SKAction.repeatForever(SKAction.animate(with: flyRight2Animation, timePerFrame: 0.10))
        case 3:
            self.flyRight = CompleteAnimation(_animation: flyRight3Animation, _action: flyRight3Action, _actionKey: flyRight3ActionKey)
            self.flyRight.action = SKAction.repeatForever(SKAction.animate(with: flyRight3Animation, timePerFrame: 0.10))
        default:
            fatalError()
        }
                
        self.node.run(self.flyRight.action!, withKey: self.flyRight.actionKey!)
        
    }
    
}

//Fly Right Animations
private let flyRight1Animation = [SKTexture(imageNamed: "Duck1_0"),
                              SKTexture(imageNamed: "Duck1_1"),
                              SKTexture(imageNamed: "Duck1_2")]

private let flyRight2Animation = [SKTexture(imageNamed: "Duck2_0"),
                              SKTexture(imageNamed: "Duck2_1"),
                              SKTexture(imageNamed: "Duck2_2")]

private let flyRight3Animation = [SKTexture(imageNamed: "Duck3_0"),
                              SKTexture(imageNamed: "Duck3_1"),
                              SKTexture(imageNamed: "Duck3_2")]

private var flyRight1Action: SKAction!
private var flyRight2Action: SKAction!
private var flyRight3Action: SKAction!

private let flyRight1ActionKey = "FlyRight1"
private let flyRight2ActionKey = "FlyRight2"
private let flyRight3ActionKey = "FlyRight3"
