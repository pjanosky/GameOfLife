//
//  Data.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/13/19.
//

import Foundation

class Data: ObservableObject, Codable {
    @Published var colonies: [Colony] = [Colony(name: "Colony 1", size: 60), Colony(name: "Colony 2", size: 60)]
    @Published var templates: [Colony] = [Colony(name: "Template 1", size: 60), Colony(name: "Template 2", size: 60)]
    @Published var currentColony = 0
    
    static var nextID = 0
    static var nextColonyID: Int {
        nextID += 1
        return nextID
    }
    
    init() {
        colonies[0].setCellAlive(Cell(10, 2))
        colonies[1].setCellAlive(Cell(10, 10))
        
        templates[0].setCellAlive(Cell(40, 40))
        templates[1].setCellAlive(Cell(30, 40))
    }
    
    
    enum CodingKeys: String, CodingKey {
        case colonies
        case templates
        case currentColony = "current_colony"
        case nextID = "next_colony_id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        colonies = try container.decode([Colony].self, forKey: .colonies)
        templates = try container.decode([Colony].self, forKey: .templates)
        currentColony = try container.decode(Int.self, forKey: .currentColony)
        Data.nextID = try container.decode(Int.self, forKey: .nextID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colonies, forKey: .colonies)
        try container.encode(templates, forKey: .templates)
        try container.encode(currentColony, forKey: .currentColony)
        try container.encode(Data.nextID, forKey: .nextID)
    }
    
    func save(as fileName: String) {
        let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName).appendingPathExtension("json")
        do {
            let data = try JSONEncoder().encode(self)
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
    
    static func load(fromFile fileName: String) -> Data? {
        let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName).appendingPathExtension("json")
        do {
            let data = try Foundation.Data(contentsOf: url)
            return try JSONDecoder().decode(Data.self, from: data)
        } catch {
            return nil
        }
    }
}
