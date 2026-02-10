import Foundation

struct TaskModeBK: Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var steps: [StepModeBK]
    var difficulty: Int
    var image: String
    var isCompleted: Bool = false
    var isFavorite: Bool = false
    var totalTime: TimeInterval {
        steps.reduce(0) { $0 + $1.duration }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, steps, difficulty, image, isCompleted, isFavorite
    }
}
