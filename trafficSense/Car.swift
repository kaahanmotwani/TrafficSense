//
//  Car.swift
//  trafficSense
//
//  Created by Rajat Mittal on 6/20/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


class Car {
    
    private var shapeNode = SKShapeNode(circleOfRadius: 20)
    private let topSpeed:Double = 5.0
    private var xPos:Int
    private var yPos:Int
    private var currentStreet:Street
    private var closestCar: Car?
    
    //private let finalDestination
    
    init (x: Int, y: Int, street: Street) {
        xPos = x
        yPos = y
        shapeNode.fillColor = SKColor.orange
        //shapeNode.fillTexture = SKTexture.init(image: UIImage(named: "Green Pickup")!)
        currentStreet = street
        closestCar = nil
        currentStreet.addCar(car: self)
        updateShapeNodePos()
    }
    
    func updateShapeNodePos() {
        shapeNode.position = getCGPoint()
    }
    
    func setNode(node: SKShapeNode) {
        shapeNode = node
    }
    
    func move(xVel:Int, yVel:Int) {
        xPos += xVel
        yPos += yVel
        updateShapeNodePos()
    }
    
    func getDirection() -> Int {
        return currentStreet.getDirection()
    }
    
    func getClosestCar() -> Car? {
        return closestCar
    }
    
    func setClosestCar(car: Car) {
        closestCar = car
    }
    
    func clearClosestCar() {
        closestCar = nil
    }
    
    func setPos(newX: Int, newY: Int) {
        xPos = newX
        yPos = newY
        updateShapeNodePos()
    }
    
    func getMovingDirectionPosition() -> Int {
        if (getDirection() == 0 || getDirection() == 1) {
            return getXPos()
        } else {
            return getYPos()
        }
    }
    
    func getNode() -> SKShapeNode
    {
        return shapeNode
    }
    
    func getTopSpeed() -> Double {
        return topSpeed
    }
    
    func getXPos() -> Int {
        return xPos
    }
    
    func getYPos() -> Int {
        return yPos
    }
    
    func getCGPoint() -> CGPoint {
        return CGPoint(x: xPos, y:yPos)
    }
    
    func getPositionArray() -> [Int] {
        return [xPos,yPos]
    }
    
    func getStreet() -> Street {
        return currentStreet
    }
    
    func findLight() -> TrafficLight {
        return currentStreet.lightFinder(car: self)
    }
    
    func directionToVector() -> [Int] {
        switch currentStreet.getDirection() {
        case 0:
            return [-1,0]
        case 1:
            return [1,0]
        case 2:
            return [0,-1]
        case 3:
            return [0,1]
        default:
            return [0,0]
        }
    }
    
    func isAtIntersection (intersection: Intersection) -> Bool {
        return intersection.isCarAtIntersection(self)
    }
    
    func turn(streetToTurnOn: Street) {
        let number = Int.random(in: 0 ... 2)
        if (number == 0) {
            currentStreet.removeCar(car: self)
            currentStreet = streetToTurnOn
            streetToTurnOn.addCar(car: self)
        }
    }
}
