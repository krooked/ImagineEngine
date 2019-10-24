//
//  Vertices.swift
//
//
//  Created by André Niet on 23.10.19.
//

import Foundation

struct Vertices: ExpressibleByArrayLiteral {
    typealias Projections = (minProjection: Metric, maxProjection: Metric)

    let vertexList: [Point]

    init(arrayLiteral elements: Point...) {
        self.vertexList = elements
    }

    func intersects(otherVertices: Vertices) -> Bool {
        let normalsActorA = normals()
        let normalsActorB = otherVertices.normals()

        let pMinMaxProjection1 = getMinMaxProjections(vertices: vertexList, axis: normalsActorA[1])
        let pMinMaxProjection2 = getMinMaxProjections(vertices: otherVertices.vertexList, axis: normalsActorA[1])
        let qMinMaxProjection1 = getMinMaxProjections(vertices: vertexList, axis: normalsActorA[0])
        let qMinMaxProjection2 = getMinMaxProjections(vertices: otherVertices.vertexList, axis: normalsActorA[0])
        let rMinMaxProjection1 = getMinMaxProjections(vertices: vertexList, axis: normalsActorB[1])
        let rMinMaxProjection2 = getMinMaxProjections(vertices: otherVertices.vertexList, axis: normalsActorB[1])
        let sMinMaxProjection1 = getMinMaxProjections(vertices: vertexList, axis: normalsActorB[0])
        let sMinMaxProjection2 = getMinMaxProjections(vertices: otherVertices.vertexList, axis: normalsActorB[0])

        let separateP = pMinMaxProjection1.maxProjection < pMinMaxProjection2.minProjection ||
            pMinMaxProjection2.maxProjection < pMinMaxProjection1.minProjection
        let separateQ = qMinMaxProjection1.maxProjection < qMinMaxProjection2.minProjection ||
            qMinMaxProjection2.maxProjection < qMinMaxProjection1.minProjection
        let separateR = rMinMaxProjection1.maxProjection < rMinMaxProjection2.minProjection ||
            rMinMaxProjection2.maxProjection < rMinMaxProjection1.minProjection
        let separateS = sMinMaxProjection1.maxProjection < sMinMaxProjection2.minProjection ||
            sMinMaxProjection2.maxProjection < sMinMaxProjection1.minProjection

        let isSeparated = separateP || separateQ || separateR || separateS

        return !isSeparated
    }

    // Only check vertices B and C for rectangles
    func getMinMaxProjections(vertices:[Point], axis:Point) -> Projections {
        var minProjection: Metric = vertices[0].dotProduct(pointB: axis)
        var maxProjection: Metric = vertices[0].dotProduct(pointB: axis)

        for vertextIndex in 1..<vertices.count {
            let projection: Metric = vertices[vertextIndex].dotProduct(pointB: axis)
            if minProjection > projection {
                minProjection = projection
            }
            if projection > maxProjection {
                maxProjection = projection
            }
        }
        return Projections(minProjection: minProjection, maxProjection: maxProjection)
    }

    func normals() -> [Point] {
        return [Point(x: vertexList[1].x - vertexList[0].x, y: vertexList[1].y - vertexList[0].y).normal(),
                Point(x: vertexList[2].x - vertexList[1].x, y: vertexList[2].y - vertexList[1].y).normal(),
                Point(x: vertexList[3].x - vertexList[2].x, y: vertexList[3].y - vertexList[2].y).normal(),
                Point(x: vertexList[0].x - vertexList[3].x, y: vertexList[0].y - vertexList[3].y).normal()]
    }

}

