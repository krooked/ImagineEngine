internal typealias Projections = (minProjection: Metric, maxProjection: Metric)

internal func intersection(between actorA: Actor, and actorB: Actor) -> Bool {
    // TODO make this check in Grid.swift ?
    guard actorA.collisionDetectionTechnique == .seperatedAxisTheorem &&
        actorB.collisionDetectionTechnique == .seperatedAxisTheorem else {
            return actorA.rectForCollisionDetection.intersects(actorB.rectForCollisionDetection)
    }

    let verticesActorA = actorA.vertices
    let verticesActorB = actorB.vertices
    let normalsActorA = normals(forVertices: verticesActorA)
    let normalsActorB = normals(forVertices: verticesActorB)

    let pMinMaxProjection1 = getMinMaxProjections(vertices: verticesActorA, axis: normalsActorA[1])
    let pMinMaxProjection2 = getMinMaxProjections(vertices: verticesActorB, axis: normalsActorA[1])
    let qMinMaxProjection1 = getMinMaxProjections(vertices: verticesActorA, axis: normalsActorA[0])
    let qMinMaxProjection2 = getMinMaxProjections(vertices: verticesActorB, axis: normalsActorA[0])
    let rMinMaxProjection1 = getMinMaxProjections(vertices: verticesActorA, axis: normalsActorB[1])
    let rMinMaxProjection2 = getMinMaxProjections(vertices: verticesActorB, axis: normalsActorB[1])
    let sMinMaxProjection1 = getMinMaxProjections(vertices: verticesActorA, axis: normalsActorB[0])
    let sMinMaxProjection2 = getMinMaxProjections(vertices: verticesActorB, axis: normalsActorB[0])

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

internal func getMinMaxProjections(vertices:[Point], axis:Point) -> Projections {
    var minProjection: Metric = vertices[0].dotProduct(pointB: axis)
    var maxProjection: Metric = vertices[0].dotProduct(pointB: axis)

    // Only check vertices B and C for rectangles
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

internal func normals(forVertices vertices: [Point]) -> [Point] {
    return [Point(x: vertices[1].x - vertices[0].x, y: vertices[1].y - vertices[0].y).normal(),
            Point(x: vertices[2].x - vertices[1].x, y: vertices[2].y - vertices[1].y).normal(),
            Point(x: vertices[3].x - vertices[2].x, y: vertices[3].y - vertices[2].y).normal(),
            Point(x: vertices[0].x - vertices[3].x, y: vertices[0].y - vertices[3].y).normal()]
}
