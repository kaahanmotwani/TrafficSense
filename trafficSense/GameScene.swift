//
//  GameScene.swift
//  trafficSense
//
//  Created by Yousef Ahmed on 6/13/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var car : SKShapeNode?
    private var spinnyNode : SKShapeNode?
    private var light : TrafficLight?
    private var line = SKShapeNode(rect: CGRect(x: 0, y: 300, width: 10, height: 200))
    private var carArray:[Car] = []
    private var firstStreet = Street(heightWidth: 0, direction: 0)
    private var carCar : Car?
    private var lightArray:[TrafficLight] = []
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        carCar = Car(x:0, y:70, street: firstStreet)
        light = TrafficLight(x:-200, y:120, location: firstStreet)
        
        // Get label node from scene and store it for use later
        self.car = self.childNode(withName: "//car") as? SKShapeNode
        if let car = self.car {
            car.fillColor = SKColor.blue
            carCar!.setNode(node: car)
            carCar!.setPos(newX: 0, newY: 0)
            carArray.append(carCar!)
        }
        
        
        line.position.x = -self.frame.width/2 + 70
        // How to cure cancer:
//        let shape = SKShapeNode()
//        shape.path = UIBezierPath(arcCenter: CGPoint(x: 100, y:0), radius: 100, startAngle: 0, endAngle: 2*3.1415, clockwise: true).cgPath
// //       shape.position = CGPoint(x: frame.midX, y: frame.midY)
//        shape.fillColor = UIColor.red
//        addChild(shape)
        
        
        light!.getNode().name = "1"
        light!.getNode().isUserInteractionEnabled = false
        self.addChild(light!.getNode())
        lightArray.append(light!)
        createLight(0, 120, street: firstStreet)
        print(lightArray.count)
        firstStreet.addLight(trafficLight: light!)
        
        line.fillColor = SKColor.white
        self.addChild(line)

        
        let secondStreet = Street(heightWidth: -300, direction: 1)
        createLight(50, -300, street: secondStreet)
        createCar(400,-300,street: secondStreet)
        
        let thirdStreetVertical = Street(heightWidth: 0,direction: 3)
        createLight(0, 300, street: thirdStreetVertical)
        createCar(0, -200, street: thirdStreetVertical)
    }
    
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let car = self.car {
//            car.position = pos
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
    //    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            let nameOfTappedNode = nodeITapped.name
            
            if let x = nameOfTappedNode {
            
                if let index = Int(x) {
                    //make it do whatever you want
                    switchLight(trafficLight: lightArray[index - 1])
                }
                
            }
            
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func switchLight(trafficLight:TrafficLight) {
        trafficLight.changeState()
    }
    
    func move() {
//        if let car = self.car {
//            if (!(car.position.x > light.position.x && car.position.x < light.position.x + 10 && checkLight())) {
//                car.position.x -= 5
//                previouslyMoving = true
//            }
//            else if (previouslyMoving) {
//                createCar()
//                previouslyMoving = false
//            }
//        }
//        if (car!.position.x <= -self.scene!.size.width/2 ) {
//            print(car!.position.x)
//            car!.position.x = self.scene!.size.width/2
//            print(car!.position.x)
//        }
//
//        for vehicle in carArray {
//            if (light.isRed()) {
//                var offset: Double = 20
//                offset = calcNewOffset(spacing: offset)
//            }
//            if (!(vehicle.getXPos() > light.getXPos() && vehicle.getXPos() < light.getXPos() + 10 && light.isRed())) {
//                vehicle.move(xVel: Int(-Double(vehicle.getTopSpeed()) * speedModifierLeft(car: vehicle)), yVel: 0)
//            }
//            if (vehicle.getXPos() <= Int(-self.scene!.size.width/2) ) {
//                vehicle.setPos(newX: Int(self.scene!.size.width/2) + 100, newY: vehicle.getYPos())
//                if (vehicle.getNode().fillColor == SKColor.blue && carArray.count < 7) {
//                    createCar()
//                }
//            }
//        }
        
        for vehicle in carArray {
            var moveVehicle = true
            let tempLight = vehicle.findLight()
            if (isVehicleCloseToLight(vehicle: vehicle, light: tempLight) && tempLight.isRed()) {
                moveVehicle = false
            } else {
                if (vehicle.getDirection() == 1 && tempLight.isRed()) {
                    print(vehicle.findLight().getXPos() - vehicle.getXPos())
                }
            }
            
            if (moveVehicle) {
                let vec = vehicle.directionToVector()
                vehicle.move(xVel: vec[0] * vehicle.getTopSpeed() * speedModifierChooser(car: vehicle), yVel: vec[1] * vehicle.getTopSpeed() * speedModifierChooser(car: vehicle))
            }
            if (vehicle.getXPos() <= Int(-self.scene!.size.width/2) && vehicle.getDirection() == 0) {
                vehicle.setPos(newX: Int(self.scene!.size.width/2) + 100, newY: vehicle.getYPos())
                if (vehicle.getNode().fillColor == SKColor.blue && carArray.count < 50) {
                    createCar(600, 0, street: firstStreet)
                }
            }
            else if (vehicle.getYPos() <= Int(-self.scene!.size.height/2) && vehicle.getDirection() == 2) {
                vehicle.setPos(newX: vehicle.getXPos(), newY: Int(self.scene!.size.height/2))
                if (vehicle.getNode().fillColor == SKColor.orange && carArray.count < 50) {
                    createCar(vehicle.getXPos(), 0, street: vehicle.getStreet())
                }
            }
            else if (vehicle.getYPos() >= Int(self.scene!.size.height/2) && vehicle.getDirection() == 3) {
                vehicle.setPos(newX: vehicle.getXPos(), newY: Int(-self.scene!.size.height/2))
                if (vehicle.getNode().fillColor == SKColor.orange && carArray.count < 50) {
                    createCar(vehicle.getXPos(), vehicle.getYPos() + 100, street: vehicle.getStreet())
                }
            }
            else if (vehicle.getXPos() >= Int(self.scene!.size.width/2) && vehicle.getDirection() == 1) {
                vehicle.setPos(newX: Int(-self.scene!.size.width/2), newY: vehicle.getYPos())
            }
        }
    }
    
    func speedModifierChooser(car: Car) -> Int {
        switch car.getDirection() {
        case 0:
            return speedModifierLeft(car: car)
        case 1:
            return speedModifierRight(car: car)
        case 2:
            return speedModifierDown(car: car)
        case 3:
            return speedModifierUp(car: car)
        default:
            return speedModifierLeft(car: car)
        }
    }
    
    func isVehicleCloseToLight(vehicle: Car, light: TrafficLight) -> Bool {
        if vehicle.getDirection() == 0 {
            return vehicle.getXPos() > light.getXPos() && vehicle.getXPos() < light.getXPos() + 10
        } else if vehicle.getDirection() == 2 {
            return vehicle.getYPos() > light.getYPos() && vehicle.getYPos() < light.getYPos() + 10
        } else if vehicle.getDirection() == 1 {
            return vehicle.getXPos() < light.getXPos() && vehicle.getXPos() > light.getXPos() - 10
        } else {
            return vehicle.getYPos() < light.getYPos() && vehicle.getYPos() > light.getYPos() - 10
        }
    }
    
    func calcNewOffset(spacing base: Double) -> Double {
        var newOffset = base
        for vehicle in carArray {
            let boundingBox = vehicle.getNode().path!.boundingBox
            let vehicleWidth = boundingBox.size.width
            newOffset = newOffset + Double(vehicleWidth) + base
        }
        print(newOffset)
        return newOffset
    }
    
    func calcDistance(car1: Car, car2: Car) -> Int {
        let boundingBox1 = car1.getNode().path!.boundingBox
        let vehicleWidth1 = boundingBox1.size.width/2
        let boundingBox2 = car2.getNode().path!.boundingBox
        let vehicleWidth2 = boundingBox2.size.width/2
        return car1.getXPos() - car2.getXPos() - Int(vehicleWidth1) - Int(vehicleWidth2)
    }
    
    func speedModifierLeft(car:Car) -> Int {
        let x = car.getXPos()
        var changed = false
        var closest = Car(x: -1000, y:0, street: car.getStreet())
        let streetCarArray = car.getStreet().getCars()
        for vehicle in streetCarArray {
            if (vehicle.getXPos() < x && vehicle.getXPos() > closest.getXPos()) {
                closest = vehicle
                changed = true
            }
        }
        
        if (!changed) {
            return 1
        } else {
            return speedModifier(distance: calcDistance(car1: car, car2: closest))
        }
    }
    
    func speedModifierRight(car:Car) -> Int {
        let x = car.getXPos()
        var changed = false
        var closest = Car(x: 1000, y:0, street: car.getStreet())
        let streetCarArray = car.getStreet().getCars()
        for vehicle in streetCarArray {
            if (vehicle.getXPos() > x && vehicle.getXPos() < closest.getXPos()) {
                closest = vehicle
                changed = true
            }
        }
        
        if (!changed) {
            return 1
        } else {
            return speedModifier(distance: calcDistance(car1: closest, car2: car))
        }
    }

    func speedModifierDown(car:Car) -> Int {
        let y = car.getYPos()
        var changed = false
        var closest = Car(x: 0, y: -1000, street: car.getStreet())
        let streetCarArray = car.getStreet().getCars()
        for vehicle in streetCarArray {
            if (vehicle.getYPos() < y && vehicle.getYPos() > closest.getYPos()) {
                closest = vehicle
                changed = true
            }
        }
        
        if (!changed) {
            return 1
        } else {
            return speedModifier(distance: calcDistance(car1: car, car2: closest))
        }
    }

    func speedModifierUp(car:Car) -> Int {
        let y = car.getYPos()
        var changed = false
        var closest = Car(x: 0, y: 1000, street: car.getStreet())
        let streetCarArray = car.getStreet().getCars()
        for vehicle in streetCarArray {
            if (vehicle.getYPos() > y && vehicle.getYPos() < closest.getYPos()) {
                closest = vehicle
                changed = true
            }
        }
        
        if (!changed) {
            return 1
        } else {
            return speedModifier(distance: calcDistance(car1: closest, car2: car))
        }
    }
    
    
    func abs(a:Int, b:Int) -> Int {
        if (a>b) {
            return a-b
        } else {
            return b-a
        }
    }
    
    func speedModifier(distance:Int) -> Int {
//        let minDistance = 0
//        let highSpeedDistance = 230
//        if distance <= minDistance {
//            return 0
//        } else if (distance <= highSpeedDistance) {
//            return Double((distance - minDistance))/Double(highSpeedDistance-minDistance)
//        }
//        else {
//            return 1
//        }
        if distance < 50 {
            return 0
        } else {
            return 1
        }
    }
    
    func createCar(_ xPos:Int, _ yPos:Int, street: Street) {
        // let number = Int.random(in: -700 ... 300)
        let car = Car(x: xPos, y: yPos, street: street)
        self.addChild(car.getNode())
        carArray.append(car)
    }
    
    func createLight(_ xPos:Int, _ yPos:Int, street: Street) {
        let light = TrafficLight(x: xPos, y: yPos, location: street)
        self.addChild(light.getNode())
        lightArray.append(light)
        light.getNode().name = String(lightArray.count)
    }
    
    override func update(_ currentTime: TimeInterval) {
        move()
        
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
