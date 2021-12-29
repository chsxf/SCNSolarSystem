//
//  SolarSystemDescription.swift
//  SCNSolarSystem
//
//  Created by Christophe on 26/12/2021.
//

import Foundation

let SUN_RADIUS_FACTOR: Float = 250

let STELLAR_OBJECT_SMALL_RADIUS_FACTOR: Float = 10
let STELLAR_OBJECT_BIG_RADIUS_FACTOR: Float = 50
let STELLAR_OBJECT_DISTANCE_FACTOR: Float = 10000

let ROTATION_PERIOD_FACTOR: Float = 10

struct SunDescription: Codable {
    let texture: String
    
    fileprivate let radius: Float
    var engineRadius: Float { radius / SUN_RADIUS_FACTOR }
    
    fileprivate let rotationPeriod: Float
    var engineRotationPeriod: Float { rotationPeriod * 10 }
}

struct AdditionalTexturesDescription: Codable {
    let normal: String?
    let specular: String?
}

struct RingsDescription: Codable {
    fileprivate let innerRadius: Float
    var engineInnerRadius: Float { innerRadius / STELLAR_OBJECT_BIG_RADIUS_FACTOR }
    
    fileprivate let outerRadius: Float
    var engineOuterRadius: Float { outerRadius / STELLAR_OBJECT_BIG_RADIUS_FACTOR }
    
    let texture: String
}

struct StellarObjectDescription: Codable {
    let name: String
    let texture: String
    let additionalTextures: AdditionalTexturesDescription?
    
    let rings: RingsDescription?

    fileprivate let radius: Float
    var engineRadius: Float {
        get {
            if radius < 10000 {
                return radius / STELLAR_OBJECT_SMALL_RADIUS_FACTOR
            }
            return radius / STELLAR_OBJECT_BIG_RADIUS_FACTOR
        }
    }
    
    fileprivate let perihelion: Float
    var enginePerihelion: Float { perihelion / STELLAR_OBJECT_DISTANCE_FACTOR }
    
    fileprivate let aphelion: Float
    var engineAphelion: Float { aphelion / STELLAR_OBJECT_DISTANCE_FACTOR }

    let eccentricity: Float
    
    fileprivate let rotationPeriod: Float
    var engineRotationPeriod: Float { rotationPeriod * 10 }
    
    let axialTilt: Float
    let orbitalInclination: Float
    let orbitalNode: Float
}

struct SolarSystemDescription: Codable {
    let backgroundTexture: String
    let sun: SunDescription
    let stellarObjects: [StellarObjectDescription]
}
