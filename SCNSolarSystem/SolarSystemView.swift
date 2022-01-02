//
//  SolarSystemView.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 13/12/2021.
//

import SceneKit
import GameplayKit

class SolarSystemView: SCNView, SCNSceneRendererDelegate {
    
    private var lastTime: TimeInterval?
    
    private var entities = [GKEntity]()
    
    private var rocket: Rocket!
    
    override init(frame frameRect: NSRect, options: [String : Any]? = nil) {
        super.init(frame: frameRect, options: options)
        
        delegate = self
        
        showsStatistics = true
        rendersContinuously = true
        preferredFramesPerSecond = 30
        
        let description: SolarSystemDescription = Functions.load("data.json")
        
        let scene = SCNScene()
        self.scene = scene

        scene.background.contents = description.backgroundTexture
        
        let sun = ModelTools.createSphere(withRadius: description.sun.engineRadius, lightingModel: .constant, texture: description.sun.texture)
        sun.name = "Sun"
        scene.rootNode.addChildNode(sun)
        
        let sunEntity = GKEntity()
        let sunComponent = RotationComponent(node: sun, rotationPeriod: description.sun.engineRotationPeriod)
        sunEntity.addComponent(sunComponent)
        entities.append(sunEntity)
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.name = "Sun Light"
        lightNode.light = light
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 20
        let ambientLightNode = SCNNode()
        ambientLightNode.name = "Ambient Space Light"
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)
        
        var maxAphelion: Float = 0
        for stellarObject in description.stellarObjects {
            maxAphelion = max(stellarObject.engineAphelion, maxAphelion)
            
            let stellarObjectRoot = SCNNode()
            stellarObjectRoot.name = "\(stellarObject.name) root"
            stellarObjectRoot.eulerAngles = SCNVector3(0, stellarObject.orbitalNode * ModelTools.deg2Rad, 0)
            scene.rootNode.addChildNode(stellarObjectRoot)
            
            let inclinationRoot = SCNNode()
            inclinationRoot.name = "\(stellarObject.name) inclination root"
            inclinationRoot.eulerAngles = SCNVector3(0, 0, stellarObject.orbitalInclination * ModelTools.deg2Rad)
            stellarObjectRoot.addChildNode(inclinationRoot)
            
            let revolutionRoot = SCNNode()
            revolutionRoot.name = "\(stellarObject.name) revolution root"
            revolutionRoot.position = SCNVector3(stellarObject.enginePerihelion, 0, 0)
            revolutionRoot.eulerAngles = SCNVector3(0, 0, -stellarObject.axialTilt * ModelTools.deg2Rad)
            inclinationRoot.addChildNode(revolutionRoot)
            
            let planetNode = ModelTools.createSphere(withRadius: stellarObject.engineRadius, lightingModel: .blinn, texture: stellarObject.texture, additionalTextures: stellarObject.additionalTextures)
            planetNode.name = stellarObject.name
            revolutionRoot.addChildNode(planetNode)
            
            if stellarObject.rings != nil {
                let ringsNode = ModelTools.createRings(withInnerRadius: stellarObject.rings!.engineInnerRadius, outerRadius: stellarObject.rings!.engineOuterRadius, texture: stellarObject.rings!.texture)
                ringsNode.name = "\(stellarObject.name) rings"
                planetNode.addChildNode(ringsNode)
            }
            
            let semiMajorAxis = (stellarObject.engineAphelion + stellarObject.enginePerihelion) / 2
            let offset = semiMajorAxis - stellarObject.enginePerihelion
            let ell = ModelTools.createEllipsis(withAphelion: stellarObject.engineAphelion, perihelion: stellarObject.enginePerihelion, eccentricity: stellarObject.eccentricity)
            ell.name = "\(stellarObject.name) trajectory"
            ell.position = SCNVector3(-offset, 0, 0)
            inclinationRoot.addChildNode(ell)
            
            let planetEntity = GKEntity()
            let planetComponent = RotationComponent(node: planetNode, rotationPeriod: stellarObject.engineRotationPeriod)
            planetEntity.addComponent(planetComponent)
            let semiMinorAxis = ModelTools.computeSemiMinorAxis(withAphelion: stellarObject.engineAphelion, perihelion: stellarObject.enginePerihelion, eccentricity: stellarObject.eccentricity)
            let orbitComponent = OrbitComponent(node: revolutionRoot, orbitalPeriod: stellarObject.engineOrbitalPeriod, perihelion: stellarObject.enginePerihelion, semiMajorAxis: semiMajorAxis, semiMinorAxis: semiMinorAxis)
            planetEntity.addComponent(orbitComponent)
            entities.append(planetEntity)
        }
        
        rocket = Rocket(inScene: scene, withMaxAphelion: maxAphelion)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let lastTime = lastTime else {
            lastTime = time
            return
        }

        let diff = time - lastTime
        self.lastTime = time

        for entity in entities {
            entity.update(deltaTime: diff)
        }
        
        rocket.update(deltaTime: diff)
    }
    
}
