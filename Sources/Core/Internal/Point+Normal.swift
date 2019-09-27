
internal extension Point {
    func normal() -> Point {
        return Point(x: self.y, y: -1 * self.x)
    }
}
