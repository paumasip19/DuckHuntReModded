//
//  Attack.swift
//  DuckHunt
//
//  Created by Alumne on 6/6/21.
//

import GameplayKit
import SpriteKit

struct Attack
{
    var node: SKSpriteNode
    var increaseSpeed: CGFloat = 10

    var maxHits = 3
    var actualHits = 0
    var maxSize: CGFloat
    
    var timer = 0
    
    init(pos: CGPoint){
                
        node = SKSpriteNode(imageNamed: "Rock_" + String(actualHits))
        node.name = "Attack"
        node.size = CGSize(width: node.size.width * 0.5, height: node.size.height * 0.5)
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.position = CGPoint(x: pos.x, y: pos.y)
        node.zPosition = 14
        
        self.maxSize = node.size.width * 3
    }
    
    func rockMovement()
    {
        //Spin Sprite
        //Make the rock bigger
        node.size = CGSize(width: node.size.width + increaseSpeed * 0.1,
                           height: node.size.height + increaseSpeed * 0.1)
    }
    
    mutating func hitAttack(position: CGPoint) -> Bool
    {
        if(isInBounds(limitsX: CGPoint(x: getZeroZero(node: self.node).x, y: getZeroZero(node: self.node).x + self.node.size.width * 2),
                      limitsY: CGPoint(x: getZeroZero(node: self.node).y, y: getZeroZero(node: self.node).y + self.node.size.height * 2),
                      pos: position))
        {
            actualHits += 1 //No llega aunque le des, revisar el inBounds
            
            node.texture = SKTexture(imageNamed: "Rock_" + String(actualHits))
            //Falta animaciones
            
            if(actualHits == maxHits)
            {
                node.removeFromParent()
            }
            
            return true
        }
        else
        {
            print("Touch Position")
            print(position)
            print("Zero Position")
            print(getZeroZero(node: self.node))
            print("Max Position X")
            print(getZeroZero(node: self.node).x + self.node.size.width)
            print("Max Position Y")
            print(getZeroZero(node: self.node).y + self.node.size.height)
        }
        
        return false
    }
    
    func checkPlayerHit() -> Bool
    {
        if(node.size.width >= maxSize) { return true }
        else { return false }
    }
    
    func mustDeleteAttack() -> Bool
    {
        if(node.parent == nil) { return true}
        else { return false }
    }
    
}
