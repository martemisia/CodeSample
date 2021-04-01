//
//  Model.swift
//  Pryaniki
//
//  Created by Wermod on 11.03.2021.
//

import Foundation
import ObjectMapper

// MARK: - Pryaniky
struct Pryaniky: Codable, Mappable {
       
    var data: [Datum]?
    var view: [String]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case view = "view"
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        data     <- map["data"]
        view     <- map["view"]
    }
}

// MARK: - Datum
struct Datum: Codable, Mappable {
    var name: String?
    var data: DataClass?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case data = "data"
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name     <- map["name"]
        data     <- map["data"]
    }
}

// MARK: - DataClass
struct DataClass: Codable, Mappable {
    var text: String?
    var url: String?
    var selectedId: Int?
    var variants: [Variant]?
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case url = "url"
        case selectedId = "selectedId"
        case variants = "variants"
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        text         <- map["text"]
        url          <- map["url"]
        selectedId   <- map["selectedId"]
        variants     <- map["variants"]
    }
}

// MARK: - Variant
struct Variant: Codable, Mappable {
    
    var id: Int?
    var text: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "text"
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id     <- map["id"]
        text   <- map["text"]
    }
}
