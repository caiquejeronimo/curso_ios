import Foundation

struct EquipmentDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String

    let itemSlotType: String?
    let itemTier: Int?
    let cost: Int?
    let shopable: Bool?
    let disabled: Bool?

    let image: String?
    let shopImage: String?
    let description: EquipmentDescriptionDTO?

    var isAvailableForBuild: Bool {
        type == "upgrade"
            && shopable == true
            && disabled != true
    }

    var imageURL: URL? {
        if let shopURL = Self.makeURL(from: shopImage) {
            return shopURL
        }

        return Self.makeURL(from: image)
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
        case type
        case itemSlotType = "item_slot_type"
        case itemTier = "item_tier"
        case cost
        case shopable
        case disabled
        case image
        case shopImage = "shop_image"
        case description
    }
}

struct EquipmentDescriptionDTO: Codable {
    let desc: String?
    let desc2: String?
    let active: String?
    let passive: String?
}
