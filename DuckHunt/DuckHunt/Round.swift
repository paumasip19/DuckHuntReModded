//
//  Round.swift
//  DuckHunt
//
//  Created by Alumne on 18/5/21.
//

import GameplayKit
import SpriteKit

enum RoundType { case NORMAL; case COINS; case BOSS }

struct Round {
    
    var roundType = RoundType.NORMAL
    var roundIndex = 0
    
    var ducksAlive = 2
    
    var initPos = [CGPoint]()
    
    var ducks = [Duck]()
    
    let gameLimitsX: CGPoint
    let gameLimitsY: CGPoint
    
    init(gLimX: CGPoint, gLimY: CGPoint) {
        self.gameLimitsX = gLimX
        self.gameLimitsY = gLimY
        
        spawnDucks()
    }
    
    mutating func spawnDucks()
    {
        var index = 0
        for _ in 1...2 {
            do {
                let random = Int.random(in: 1...3)
                ducks.append(Duck(duckType: random, duckNumber: index, dir: CGPoint(x: 1, y: 0), gLimX: gameLimitsX, gLimY: gameLimitsY))
                index = index + 1
            }
        }
    }
    
    mutating func nextRound() -> Bool
    {
        if(ducks.count != 0)
        {
            ducksAlive = 0
            var index = 0
            for _ in 1...2 {
                do {
                    if(ducks[index].endRound && ducks [index].node.position == ducks[index].initialPos)
                    {
                        removeDucks()
                        ducks.removeAll()
                        spawnDucks()
                        ducksAlive = 2
                        return true
                    }
                    else if(ducks[index].node.parent != nil)
                    {
                        ducksAlive += 1
                    }
                    index += 1
                }
            }
        }
        
        if(ducksAlive == 0)
        {
            ducks.removeAll()
            spawnDucks()
            ducksAlive = 0
            return true
        }
        
        return false
    }
    
    mutating func removeDucks()
    {
        var index = 0
        for _ in 1...2 {
            do {
                ducks[index].node.removeFromParent()
                index += 1
            }
        }
    }
    
}
