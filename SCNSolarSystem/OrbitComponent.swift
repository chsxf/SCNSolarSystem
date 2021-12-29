//
//  RevolutionComponent.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 29/12/2021.
//

import GameplayKit
import SceneKit

class OrbitComponent: GKSCNNodeComponent {
    
    let orbitalPeriod: Float
    let radiansPerSecond: Double
    
    let perihelion: Float
    let semiMajorAxis: Float
    let semiMinorAxis: Float
    
    var currentAngle: Double = 0
    
    init(node: SCNNode, orbitalPeriod: Float, perihelion: Float, semiMajorAxis: Float, semiMinorAxis: Float) {
        self.orbitalPeriod = orbitalPeriod
        radiansPerSecond = (Double.pi * 2) / Double(orbitalPeriod)
        
        self.perihelion = perihelion
        self.semiMajorAxis = semiMajorAxis
        self.semiMinorAxis = semiMinorAxis
        
        super.init(node: node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        currentAngle += radiansPerSecond * seconds
        let limit = Double.pi * 2
        if currentAngle > limit {
            currentAngle = currentAngle.remainder(dividingBy: limit)
        }
        
        let offset = semiMajorAxis - perihelion
        node.position = SCNVector3(
            semiMajorAxis * Float(cos(currentAngle)) - offset,
            0,
            semiMinorAxis * Float(sin(currentAngle))
        )
    }
    
}
