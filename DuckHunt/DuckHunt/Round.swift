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
    
    var startRound = false
    
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
        //ducks.append(Duck(duckType: 1, duckNumber: 0, dir: CGPoint(x: 1, y: 0)))
        var index = 0
        for _ in 1...10 {
            do {
                let random = Int.random(in: 1...3)
                ducks.append(Duck(duckType: random, duckNumber: index, dir: CGPoint(x: 1, y: 0), gLimX: gameLimitsX, gLimY: gameLimitsY))
                index = index + 1
            }
        }
    }
    
    mutating func removeAllDucks()
    {
        ducks.removeAll()
    }
    
}
