//
//  Points.swift
//  DuckHunt
//
//  Created by Alumne on 11/5/21.
//

import GameplayKit
import SpriteKit

struct Points
{
    var initPos = CGPoint(x: 588, y: 374)
    let size = CGSize(width: 24, height: 25)
    
    var internalScore = [0, 0, 0, 0, 0, 0]
    
    var nodes: [SKSpriteNode]! = []
    
    init(){
        var index = 0
        
        for _ in 1...6 {
            do {
                self.nodes.append(SKSpriteNode(imageNamed: "Points_" + String(internalScore[index])))
                
                self.nodes[index].name = "PointSprite_" + String(index)
                self.nodes[index].size = size
                self.nodes[index].position = CGPoint(x: initPos.x, y: initPos.y)
                self.nodes[index].zPosition = 10
            
                initPos.x += size.width
                
                index += 1
            }
        }
        
    }
    
    mutating func updateScore(pointsAdded: [Int])
    {
        var extraToAdd = 0
        var index = 5
        
        for _ in 1...6 {
            var newValue = self.internalScore[index] + pointsAdded[index]
            newValue += extraToAdd
            
            if(newValue >= 10)
            {
                extraToAdd = newValue / 10
                newValue = 0
            }
            else
            {
                extraToAdd = 0
            }
            
            self.internalScore[index] = newValue
            
            self.nodes[index].texture = pointsSprites[self.internalScore[index]]
            
            index -= 1
        }
    }
}

private let pointsSprites = [SKTexture(imageNamed: "Points_0"),
                             SKTexture(imageNamed: "Points_1"),
                             SKTexture(imageNamed: "Points_2"),
                             SKTexture(imageNamed: "Points_3"),
                             SKTexture(imageNamed: "Points_4"),
                             SKTexture(imageNamed: "Points_5"),
                             SKTexture(imageNamed: "Points_6"),
                             SKTexture(imageNamed: "Points_7"),
                             SKTexture(imageNamed: "Points_8"),
                             SKTexture(imageNamed: "Points_9"),]
