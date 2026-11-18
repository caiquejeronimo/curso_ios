import Foundation

struct HeroDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let description: HeroDescriptionDTO
    let images: HeroImagesDTO
    let playerSelectable: Bool
    let disabled: Bool
    let inDevelopment: Bool

    var isAvailable: Bool {
        playerSelectable && !disabled && !inDevelopment
    }

    var imageURL: URL? {
        if let cardURL = Self.makeURL(from: images.iconHeroCard) {
            return cardURL
        }

        return Self.makeURL(from: images.iconImageSmall)
    }

    private static func makeURL(from value: String?) -> URL? {
        guard let value, !value.isEmpty else {
            return nil
        }

        return URL(string: value)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case images
        case playerSelectable = "player_selectable"
        case disabled
        case inDevelopment = "in_development"
    }
}

struct HeroDescriptionDTO: Codable {
    let lore: String?
    let role: String?
    let playstyle: String?
}

struct HeroImagesDTO: Codable {
    let iconHeroCard: String?
    let iconImageSmall: String?

    enum CodingKeys: String, CodingKey {
        case iconHeroCard = "icon_hero_card"
        case iconImageSmall = "icon_image_small"
    }
}
