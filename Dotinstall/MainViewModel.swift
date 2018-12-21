// To parse the JSON, add this file to your project and do:
//
//   let sfc = try? newJSONDecoder().decode(Sfc.self, from: jsonData)

import Foundation


struct SFC {
    
    static func fetchBus(completion: @escaping ([Bus]) -> Swift.Void) {
        
        let url = "https://api.myjson.com/bins/1gk2bc"
        
        guard var urlComponents = URLComponents(string: url) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "50"),
        ]
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let articles = try JSONDecoder().decode([Bus].self, from: jsonData)
                completion(articles)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}


struct Bus: Codable {
    let shosfc: [ShosfcElement]
    let shosfcT: [ShosfcT]
    let tsujisfc: [ShosfcElement]
    let tsujisfcT: [TsujisfcT]
    
    enum CodingKeys: String, CodingKey {
        case shosfc
        case shosfcT = "shosfc_t"
        case tsujisfc
        case tsujisfcT = "tsujisfc_t"
    }
}

struct ShosfcElement: Codable {
    let weekday, sat, sun: [Sat]
}

struct Sat: Codable {
    let hour, min: Int
    let type: JSONNull?
}

struct ShosfcT: Codable {
    let weekday, sat: [Sat]
}

struct TsujisfcT: Codable {
    let weekday: [Sat]
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

