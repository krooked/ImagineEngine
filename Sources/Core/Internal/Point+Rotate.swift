import Foundation
import CoreGraphics

internal extension Point {
    func rotate(radians: CGFloat) -> Point {
        let x = self.x * cos(radians) - self.y * sin(radians)
        let y = self.x * sin(radians) + self.y * cos(radians)
        return Point(x: x, y: y)
    }
}
