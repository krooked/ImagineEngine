internal extension Point {
    func dotProduct(pointB: Point) -> Metric {
        return x * pointB.x + y * pointB.y
    }
}
