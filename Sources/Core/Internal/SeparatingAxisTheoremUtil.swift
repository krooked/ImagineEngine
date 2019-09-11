
internal func intersection(between actorA: Actor, and actorB: Actor) -> Bool {
    guard let normalsActorA = actorA.normals,
          let normalsActorB = actorB.normals,
          let verticesActorA = actorA.vertices,
          let verticesActorB = actorB.vertices else {
        return false
    }

    let p1 = getMinMaxProjections(vertices: verticesActorA, axis: normalsActorA[1])
    let p2 = getMinMaxProjections(vertices: verticesActorB, axis: normalsActorA[1])
    let q1 = getMinMaxProjections(vertices: verticesActorA, axis: normalsActorA[0])
    let q2 = getMinMaxProjections(vertices: verticesActorB, axis: normalsActorA[0])

    let r1 = getMinMaxProjections(vertices: verticesActorA, axis: normalsActorB[1])
    let r2 = getMinMaxProjections(vertices: verticesActorB, axis: normalsActorB[1])
    let s1 = getMinMaxProjections(vertices: verticesActorA, axis: normalsActorB[0])
    let s2 = getMinMaxProjections(vertices: verticesActorB, axis: normalsActorB[0])

    let separateP = p1.maxProjection < p2.minProjection || p2.maxProjection < p1.minProjection
    let separateQ = q1.maxProjection < q2.minProjection || q2.maxProjection < q1.minProjection
    let separateR = r1.maxProjection < r2.minProjection || r2.maxProjection < r1.minProjection
    let separateS = s1.maxProjection < s2.minProjection || s2.maxProjection < s1.minProjection

    let isSeparated = separateP || separateQ || separateR || separateS
    if isSeparated {
        print("Separated actors")
    }else {
        print("Collided actors")
    }

    return isSeparated
}

internal func getMinMaxProjections(vertices:[Point], axis:Point) -> (minProjection: Metric, maxProjection: Metric) {
    var minProjection: Metric = vertices[0].dotProduct(B: axis);
    var maxProjection: Metric = vertices[0].dotProduct(B: axis);

    // Only check vertices B and C for rectangles
    for j in 1..<vertices.count {

        let projection: Metric = vertices[j].dotProduct(B: axis)
        if minProjection > projection {
            minProjection = projection
        }
        if (projection > maxProjection) {
            maxProjection = projection
        }
    }
    return (minProjection, maxProjection)
}