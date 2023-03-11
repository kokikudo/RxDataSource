import UIKit

enum PageTypeEnum: Int, CaseIterable {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    
    var color: UIColor {
        switch self {
        case .zero: return .red
        case .one: return .brown
        case .two: return .blue
        case .three: return .green
        case .four: return .orange
        case .five: return .cyan
        case .six: return .purple
        case .seven: return .separator
        }
    }
    
    var icon: UIImage {
        switch self {
        case .zero: return UIImage(systemName: "plus")!
        case .one: return .actions
        case .two: return .checkmark
        case .three: return .remove
        case .four: return .strokedCheckmark
        case .five: return .checkmark
        case .six: return .strokedCheckmark
        case .seven: return .actions
        }
    }
}
