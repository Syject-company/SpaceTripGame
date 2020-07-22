//
//  LifePointsProtocol.swift
//  SpaceTrip
//
//  Created by Kostya Bershov on 17.02.2020.
//  Copyright © 2020 Syject. All rights reserved.
//

typealias DidRunOutOfLifePointsEventHandler = (_ object: AnyObject) -> ()

protocol LifePointsProtocol {
    var lifePoints: Int { get set }
    var didRunOutOfLifePointsEventHandler: DidRunOutOfLifePointsEventHandler? { get set }
}
