import Foundation

struct StepModeBK: Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var duration: TimeInterval
    var isTimer: Bool
}
