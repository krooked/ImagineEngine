
internal extension Point {
    func dotProduct(B: Point) -> Metric {
        return x * B.x + y * B.y
    }
}