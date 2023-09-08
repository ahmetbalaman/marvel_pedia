// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let characters = try? JSONDecoder().decode(Characters.self, from: jsonData)


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let characterJSON = try? JSONDecoder().decode(CharacterJSON.self, from: jsonData)

import Foundation

// MARK: - CharacterJSON
struct CharacterJSON: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [CharactersResult]?
}

// MARK: - Result
struct CharactersResult: Codable {
    let id: Int?
    let name, description: String?
    let modified: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics, series: Comics?
    let stories: Stories?
    let events: Comics?
    let urls: [URLElement]?
}

// MARK: - Comics
struct Comics: Codable {
    var available: Int?
    let collectionURI: String?
    let items: [ComicsItem]?
    let returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Stories
struct Stories: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [StoriesItem]?
    let returned: Int?
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let resourceURI: String?
    let name: String?
 
}


// MARK: - Thumbnail
struct Thumbnail: Codable {
    
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path="path"
        case thumbnailExtension = "extension"
    }
    func getURLGIF() -> String {
        return "\(String(describing: path)).gif"
    }
    func getURLJPG() -> String {
        return "\(String(describing: path)).jpg"
    }
}


// MARK: - URLElement
struct URLElement: Codable {
    let type: URLType?
    let url: String?
}

enum URLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}
