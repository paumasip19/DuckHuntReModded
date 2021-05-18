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
    
    var ducks: [Duck]
    
    /*init() {
        var index = 0
        for _ in 1...6 {
            do {
                
                
               /* ducks.append(Duck(duckType: 1, duckNumber: duckIndex, duckPosition: CGPoint(x: initPos.x + 150, y: initPos.y)))
    
                index += 1
            
                initPos.x += 150*/
            }
        }
    }*/
}
