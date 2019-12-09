//
//  Data.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/13/19.
//

import Foundation


class Data: ObservableObject, Codable {
    @Published var colonies: [Colony] = [Colony(name: "Untitled", size: 60)]
    @Published var templates: [Colony] = [
        Colony(name: "Blank", size: 60),
        Colony(name: "Basic", size: 60, cells: Set<Cell>(arrayLiteral: Cell(20, 20), Cell(20, 21), Cell(20, 22), Cell(21, 21))),
        Colony(name: "Glider", size: 60, cells: Set<Cell>(arrayLiteral: Cell(10, 8), Cell(10, 9), Cell(10, 10), Cell(11, 10), Cell(12, 9))),
        Colony(name: "Glider Gun", size: 60, cells: Set<Cell>(arrayLiteral: Cell(5, 1), Cell(5, 2), Cell(6, 1), Cell(6, 2), Cell(5, 11), Cell(6, 11), Cell(7, 11), Cell(8, 12), Cell(9, 13), Cell(9, 14), Cell(4, 12), Cell(3, 13), Cell(3, 14), Cell(6, 15), Cell(4, 16), Cell(8, 16), Cell(5, 17), Cell(6, 17), Cell(7, 17), Cell(6, 18), Cell(5, 21), Cell(4, 21), Cell(3, 21), Cell(5, 22), Cell(4, 22), Cell(3, 22), Cell(2, 23), Cell(6, 23), Cell(6, 25), Cell(7, 25), Cell(1, 25), Cell(2, 25), Cell(3, 35), Cell(3, 36), Cell(4, 35), Cell(4, 36)))
    ]
    @Published var currentColony = 0
    
    static var nextID = 0
    static var nextColonyID: Int {
        nextID += 1
        return nextID
    }
    
    init() {}
    
    
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
