// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let comicJSON = try? JSONDecoder().decode(ComicJSON.self, from: jsonData)

import Foundation

// MARK: - ComicJSON
struct ComicJSON: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: ComicData?
}
// MARK: - ComicJSON


// MARK: - DataClass
struct ComicData: Codable {
    let offset, limit, total, count: Int?
    let results: [ComicResult]?
}

// MARK: - Result
struct ComicResult: Codable {
    let id, digitalID: Int?
    let title: String?
    let issueNumber: Int?
    let variantDescription, description: String?
    let modified: String?
    let isbn, upc, diamondCode, ean: String?
    let issn, format: String?
    let pageCount: Int?
    let textObjects: [TextObject]?
    let resourceURI: String?
    let series: Series?
    let variants: [Series]?
    let dates: [DateElement]?
    let prices: [Price]?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?
    let creators: Creators?
    let characters: Characters?
    let stories: Stories?
    let events: Characters?

    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title, issueNumber, variantDescription, description, modified, isbn, upc, diamondCode, ean, issn, format, pageCount, textObjects, resourceURI, series, variants,dates, prices, thumbnail, images, creators, characters, stories, events
    }
}

// MARK: - Characters
struct Characters: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [Series]?
    let returned: Int?
}

// MARK: - Series
struct Series: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Creators
struct Creators: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [CreatorsItem]?
    let returned: Int?
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
    let resourceURI: String?
    let name, role: String?
}

// MARK: - DateElement
struct DateElement: Codable {
    let type: String?
    let date: String?
}


// MARK: - Price
struct Price: Codable {
    let type: String?
    let price: Double?
}


// MARK: - TextObject
struct TextObject: Codable {
    let type, language, text: String?
}



// parçalama kısmında hata veriyor belki sebebi budur diye araştır
//struct ComicJSON2: Codable {
//    let id, digitalID: Int?
//    let title: String?
//    let issueNumber: Int?
//    let variantDescription, description: String?
//    let modified: String?
//    let isbn, upc, diamondCode, ean: String?
//    let issn, format: String?
//    let pageCount: Int?
//    let textObjects: [TextObject]?
//    let resourceURI: String?
//    let urls: [URLElement]?
//    let series: Series?
//    let variants, collections: [String]?
//    let collectedIssues: [Series]?
//    let dates: [DateElement]?
//    let prices: [Price]?
//    let thumbnail: Thumbnail?
//    let images: [Thumbnail]?
//    let creators: Creators?
//    let characters: Characters?
//    let stories: Stories?
//    let events: Characters?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case digitalID = "digitalId"
//        case title, issueNumber, variantDescription, description, modified, isbn, upc, diamondCode, ean, issn, format, pageCount, textObjects, resourceURI, urls, series, variants, collections, collectedIssues, dates, prices, thumbnail, images, creators, characters, stories, events
//    }
//}
