//
//  ModelTools.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 28/12/2021.
//

import Foundation
import SceneKit

class ModelTools {
    
    static let deg2Rad = Float.pi / 180
    
    static func createSphere(withRadius radius: Float, lightingModel: SCNMaterial.LightingModel, texture: String, additionalTextures: AdditionalTexturesDescription? = nil) -> SCNNode {
        let material = SCNMaterial()
        material.diffuse.contents = texture
        material.lightingModel = lightingModel
        if additionalTextures?.normal != nil {
            material.normal.contents = additionalTextures!.normal!
        }
        if additionalTextures?.specular != nil {
            material.specular.contents = additionalTextures!.specular!
        }
        
        let sphere = SCNSphere(radius: CGFloat(radius))
        sphere.segmentCount = 48
        sphere.firstMaterial = material
        
        let node = SCNNode(geometry: sphere)
        return node
    }
    
    static func createRings(withInnerRadius innerRadius: Float, outerRadius: Float, texture: String) -> SCNNode {
        var vertices = [SCNVector3]()
        var normals = [SCNVector3]()
        var uvs = [CGPoint]()
        var indices = [Int32]()
        
        let segmentCount = 96
        
        let angleIncrement: Float = 360.0 / Float(segmentCount)
        let uvIncrement = 1.0 / Double(segmentCount)
        var index: Int32 = 0
        for i in 0...segmentCount {
            let angle = -angleIncrement * Float(i)
            let radAngle = angle * deg2Rad
            
            let cosinus = cos(radAngle)
            let sinus = sin(radAngle)
            
            let uvY = uvIncrement * Double(i)
            
            vertices.append(SCNVector3(cosinus * innerRadius, 0, sinus * innerRadius))
            normals.append(SCNVector3(0, -1, 0))
            uvs.append(CGPoint(x: 0.0, y: uvY))
            
            vertices.append(SCNVector3(cosinus * outerRadius, 0, sinus * outerRadius))
            normals.append(SCNVector3(0, -1, 0))
            uvs.append(CGPoint(x: 1.0, y: uvY))
            
            indices.append(index)
            indices.append(index + 1)
            index += 2
        }
        
        let verticesSource = SCNGeometrySource(vertices: vertices)
        let normalsSource = SCNGeometrySource(normals: normals)
        let uvsSource = SCNGeometrySource(textureCoordinates: uvs)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangleStrip)
        
        let topMaterial = SCNMaterial()
        topMaterial.lightingModel = .blinn
        topMaterial.diffuse.contents = texture
        
        let bottomMaterial = SCNMaterial()
        bottomMaterial.lightingModel = .blinn
        bottomMaterial.diffuse.contents = texture
        bottomMaterial.cullMode = .front
        
        let geometry = SCNGeometry(sources: [verticesSource, normalsSource, uvsSource], elements: [element, element])
        geometry.materials = [topMaterial, bottomMaterial]
        
        let node = SCNNode(geometry: geometry)
        return node
    }
    
    static func createEllipsis(withAphelion aphelion: Float, perihelion: Float, eccentricity: Float) -> SCNNode {
        let semiMajorAxis = (aphelion + perihelion) / 2
        let semiMinorAxis = computeSemiMinorAxis(withAphelion: aphelion, perihelion: perihelion, eccentricity: eccentricity)
        
        var vertices = [SCNVector3]()
        var indices = [Int32]()
        
        let segmentCount = 96
        
        let angleIncrement: Float = 360.0 / Float(segmentCount)
        for i in 0..<segmentCount {
            let angle = angleIncrement * Float(i)
            let radAngle = angle * deg2Rad
            
            let cosinus = cos(radAngle)
            let sinus = sin(radAngle)
            
            vertices.append(SCNVector3(cosinus * semiMajorAxis, 0,  sinus * semiMinorAxis))
            indices.append(Int32(i))
            indices.append(Int32((i + 1) % segmentCount))
        }
        
        let verticesSource = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        let material = SCNMaterial()
        material.lightingModel = .constant
        #if os(macOS)
        material.diffuse.contents = NSColor.white
        #else
        material.diffuse.contents = UIColor.white
        #endif
        
        let geometry = SCNGeometry(sources: [verticesSource], elements: [element])
        geometry.firstMaterial = material
        
        let node = SCNNode(geometry: geometry)
        return node
    }
    
    static func computeSemiMinorAxis(withAphelion aphelion: Float, perihelion: Float, eccentricity: Float) -> Float {
        let semiMajorAxis = (aphelion + perihelion) / 2
        if eccentricity > 0 && eccentricity < 1 {
            let perihelionToDirectrix = perihelion / eccentricity
            let centerToDirectrix = perihelionToDirectrix + semiMajorAxis
            let focalPointToTop = centerToDirectrix * eccentricity
            let focalPointToCenter = semiMajorAxis - perihelion
            let focalPointToTopAngle = acos(focalPointToCenter / focalPointToTop)
            let semiMinorAxis = sin(focalPointToTopAngle) * focalPointToTop
            return semiMinorAxis
        }
        else {
            return semiMajorAxis
        }
    }
    
}
