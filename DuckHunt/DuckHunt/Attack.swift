//
//  Attack.swift
//  DuckHunt
//
//  Created by Alumne on 6/6/21.
//

import GameplayKit
import SpriteKit

struct Attack {
    var node: SKSpriteNode
    var increaseSpeed: CGFloat = 10

    var maxHits = 3
    var actualHits = 0
    var maxSize: CGFloat

    let gameLimitsX: CGPoint
    let gameLimitsY: CGPoint

    init(pos: CGPoint, gX: CGPoint, gY: CGPoint) {

        gameLimitsX = gX
        gameLimitsY = gY

        node = SKSpriteNode(imageNamed: "Rock_" + String(actualHits))
        node.name = "Attack"
        node.size = CGSize(width: node.size.width * 0.5, height: node.size.height * 0.5)
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.zPosition = 14

        self.maxSize = node.size.width * 3

        var finalPos = pos

        if finalPos.x + maxSize >= gX.y {
            finalPos.x = gX.y - maxSize
        } else if finalPos.x - node.size.width <= gX.x {
            finalPos.x = gX.x
        }

        if finalPos.y + maxSize >= gY.y {
            finalPos.y = gY.y - maxSize
        } else if finalPos.y - node.size.height <= gY.x {
            finalPos.y = gY.x
        }

        node.position = CGPoint(x: finalPos.x, y: finalPos.y)

    }

    func rockMovement(round: Bool, delta: Double, orientation: Int) {
        if round {
            if orientation == 0 {
                node.position.x = CGFloat(sin(Float(delta)) * (Float(node.size.width)/2) + 375)
                node.position.y = CGFloat(cos(Float(delta)) * (Float(node.size.width)/2) + 640)
            } else {
                node.position.x = CGFloat(sin(Float(delta) * 3) * (Float(node.size.width)/2) + 375)
                node.position.y = CGFloat(cos(Float(delta) * 3) * (Float(node.size.width)/2) + 640)
            }

        }

        // Make the rock bigger
        node.size = CGSize(width: node.size.width + increaseSpeed * 0.1,
                           height: node.size.height + increaseSpeed * 0.1)
    }

    mutating func hitAttack(position: CGPoint) -> Bool {
        if isInBounds(limitsX: CGPoint(x: getZeroZero(node: self.node).x, y: getZeroZero(node: self.node).x + self.node.size.width * 2),
                      limitsY: CGPoint(x: getZeroZero(node: self.node).y, y: getZeroZero(node: self.node).y + self.node.size.height * 2),
                      pos: position) {
            actualHits += 1 // No llega aunque le des, revisar el inBounds

            node.texture = SKTexture(imageNamed: "Rock_" + String(actualHits))
            // Falta animaciones

            if actualHits == maxHits {
                node.removeFromParent()
            }

            return true
        } else {
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

    func checkPlayerHit() -> Bool {
        if node.size.width >= maxSize { return true } else { return false }
    }

    func mustDeleteAttack() -> Bool {
        if node.parent == nil { return true} else { return false }
    }

}
