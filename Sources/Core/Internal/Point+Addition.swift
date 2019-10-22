import Foundation
import CoreGraphics

internal extension Point {
    func add(point: Point) -> Point {
        let x = self.x + point.x
        let y = self.y + point.y

        return Point(x: x, y: y)
    }
}
