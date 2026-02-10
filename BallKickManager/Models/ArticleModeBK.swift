import Foundation

struct ArticleModeBK: Codable, Identifiable {
    var id: String
    var title: String
    var subtitle: String
    var body: [String]
    var category: String
    var image: String
    var isFavorite: Bool = false
    var isViewed: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, body, category, image, isFavorite, isViewed
    }
}
