import UIKit

internal class CollisionDetector {
    typealias Projections = (minProjection: Metric, maxProjection: Metric)
    static var ActorAInset: UIEdgeInsets?
    
    static func intersection(between actorA: Actor, and actorB: Actor) -> Bool {
        CollisionDetector.ActorAInset = ActorAInset
        
        return intersection(between: actorA, and: actorB, actorAInset: nil)
    }
    
    static func intersection(between actorA: Actor, and actorB: Actor, actorAInset: (dx: Metric, dy: Metric)?) -> Bool {
        guard actorA.collisionDetectionTechnique == .seperatedAxisTheorem && actorB.collisionDetectionTechnique == .seperatedAxisTheorem else {
            return actorA.rectForCollisionDetection.intersects(actorB.rectForCollisionDetection)
        }
        
        let actorALayerBounds = actorA.layer.bounds
        if let actorAInset = actorAInset {
            actorALayerBounds.insetBy(dx: actorAInset.dx, dy: actorAInset.dy)
        }
        
        let verticesActorA = actorA.vertices
        let verticesActorB = actorB.vertices
        let normalsActorA = normals(forVertices: verticesActorA)
        let normalsActorB = normals(forVertices: verticesActorB)
        
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
        
        return !isSeparated
    }
    
    static func getMinMaxProjections(vertices:[Point], axis:Point) -> Projections {
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
        return Projections(minProjection: minProjection, maxProjection: maxProjection)
    }
    
    static func normals(forVertices vertices: [Point]) -> [Point] {
        return [Point(x: vertices[1].x - vertices[0].x, y: vertices[1].y - vertices[0].y).normal(),
                Point(x: vertices[2].x - vertices[1].x, y: vertices[2].y - vertices[1].y).normal(),
                Point(x: vertices[3].x - vertices[2].x, y: vertices[3].y - vertices[2].y).normal(),
                Point(x: vertices[0].x - vertices[3].x, y: vertices[0].y - vertices[3].y).normal()]
    }
    
}




