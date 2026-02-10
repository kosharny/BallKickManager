import Foundation

struct StatModeBK: Codable {
    var totalTrainingTime: TimeInterval = 0
    var completedTasksCount: Int = 0
    var streakDays: Int = 0
    var lastTrainingDate: Date?
    var purchasedThemes: [String] = [] 
}
