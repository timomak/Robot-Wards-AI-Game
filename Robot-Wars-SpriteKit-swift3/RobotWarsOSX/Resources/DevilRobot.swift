//  DevilRobot.swift
//  RobotWarsOSX
//
//  Created by timofey makhlay on 6/28/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation


import Foundation

class DevilRobot: Robot {
    
    enum RobotState {                    // enum for keeping track of RobotState
        case firstPosition, searching, found, firing, closeCombat
    }
    
    var health: Int = 50
    var currentRobotState: RobotState = .firstPosition

    var lastKnownPosition = CGPoint(x: 0, y: 0)
    var lastKnownPositionTimestamp = CGFloat(0.0)
    let firingTimeout = CGFloat(1.0)
    var timeToMove = CGFloat(0.0)
    
    var a = 1
    
    let gunToleranceAngle = CGFloat(2.0)
    
    var side = ""
    
    override func run() {
        while true {
            switch currentRobotState {
            case .firstPosition:
                // TODO: Add repositioning function every 19 sec.
                performfirstPosition()
            case .searching:
                // TODO: Searching by shooting 5 bullets to scan for enemies
                findThatMotherfucker()
            case .found:
                performNextFiringAction()
            case .firing:
                // TODO shoot at the last position
                performNextFiringAction()
            case .closeCombat: break
                // TODO: Escape with counterattack
            }
        }
    }
    
    func performfirstPosition(){
        
        let arenaSize = arenaDimensions()
        let bodyLenght = robotBodySize().width
        let currentPosition = position()
        
        let middleWidth = (arenaSize.width / 2) - currentPosition.x
        
        let topHeight = arenaSize.height - currentPosition.y
        
        if a == 1 {
            print(a)
            // Find the closest intersection point
            if currentPosition.y < arenaSize.height / 2 {
                if currentPosition.x < arenaSize.width / 2{
                    // Bottom Left
                    turnLeft(90)
                    moveAhead(Int(topHeight - bodyLenght))
                    turnRight(90)
                    moveAhead(Int(middleWidth))
                    print("Bottom Left ", middleWidth)
                    side = "Left"
                }
                else{
                    // Bottom Right
                    turnRight(90)
                    moveAhead(Int(topHeight - bodyLenght))
                    turnLeft(90)
                    moveAhead(Int(middleWidth * -1))
                    print("Bottom Right ", middleWidth)
                    side = "Right"
                }
            }
                
            else{
                if currentPosition.x < arenaSize.width / 2 {
                    // Top left
                    turnLeft(90)
                    moveAhead(Int(topHeight - bodyLenght))
                    turnRight(90)
                    moveAhead(Int(middleWidth))
                    print("Top Left ", middleWidth)
                    side = "Left"
                } else {
                    // Top Right
                    turnRight(90)
                    moveAhead(Int(topHeight - bodyLenght))
                    turnLeft(90)
                    moveAhead(Int(middleWidth * -1))
                    print("Top Right ", middleWidth)
                    side = "Right"
                }
            }
            a += 1
        }
        if a == 2 {
            findThatMotherfucker()
        } else if a == 3 {
            if side == "Left" {
                moveAhead(412)
                turnRight(90)
                moveAhead(210)
            }
            else {
                moveAhead(412)
                turnLeft(90)
                moveAhead(210)
            }
            
            print(a, "last print")
            findThatMotherfucker()
        } else if a == 4 {
            if side == "Left" {
                moveAhead(412)
                turnRight(90)
                moveAhead(412)
                print("im on the left side")
            }
            else {
                moveAhead(412)
                turnLeft(90)
                moveAhead(412)
                print("im on the right side")
            }
            // a == 5
            print(a, "last print")
            findThatMotherfucker()
            
        } else if a == 5 {
            if side == "Left" {
                let angle = Int(angleBetweenGunHeadingDirectionAndWorldPosition(CGPoint(x: 0, y: arenaSize.height/2)))
                if angle < 0 {
                    turnLeft(abs(angle))
                } else {
                    turnRight(abs(angle))
                }
                moveAhead(500)
                turnRight(45)
            } else {
                let angle = Int(angleBetweenGunHeadingDirectionAndWorldPosition(CGPoint(x: arenaSize.width, y: arenaSize.height/2)))
                if angle < 0 {
                    turnLeft(abs(angle))
                } else {
                    turnRight(abs(angle))
                }
                moveAhead(500)
                turnLeft(45)
            }
            findThatMotherfucker()
        }
        
        
    }
    
    func findThatMotherfucker() {
        
        if side == "Left" {
            shoot()
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
            
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()

        } else {
            shoot()
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()
            turnLeft(30)
            shoot()
            
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
            turnRight(30)
            shoot()
        }
        
        print(a)
        if a < 4 {
        a += 1
        } else {
            a = 1
        }

        
    }
    
    override func bulletHitEnemy(at position: CGPoint) {
        print("bullet hit")
        lastKnownPosition = position
        lastKnownPositionTimestamp = currentTimestamp()
        performNextFiringAction()
        
    }
    
    override func scannedRobot(_ robot: Robot!, atPosition position: CGPoint) {

        lastKnownPosition = position
        lastKnownPositionTimestamp = currentTimestamp()
        performNextFiringAction()
    }
    
    func performNextFiringAction() {
        
            let angle = Int(angleBetweenGunHeadingDirectionAndWorldPosition(lastKnownPosition))
            if angle >= 0 {
                turnGunRight(abs(angle))
            } else {
                turnGunLeft(abs(angle))
            }
            shoot()
        }

}
