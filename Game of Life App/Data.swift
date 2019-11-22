//
//  Data.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/13/19.
//

import Foundation

class Data: ObservableObject {
    @Published var colonies: [Colony] = [Colony(name: "Colony 1", size: 60), Colony(name: "Colony 2", size: 60)]
    @Published var templates: [Colony] = [Colony(name: "Template 1", size: 60), Colony(name: "Template 2", size: 60)]
    @Published var currentColony = 0
    
    init() {
        colonies[0].setCellAlive(Cell(10, 2))
        colonies[1].setCellAlive(Cell(10, 10))
        
        templates[0].setCellAlive(Cell(40, 40))
        templates[1].setCellAlive(Cell(30, 40))
    }
    
    static var nextID = 0
    static var nextColonyID: Int {
        nextID += 1
        return nextID
    }
}


class DataSaver: Codable {
    var colonies: [Colony]
    var templates: [Colony]
    var currentColony: Int
    var nextID: Int
    
    init(colonies: [Colony], templates: [Colony], currentColony: Int, nextID: Int) {
        self.colonies = colonies
        self.templates = templates
        self.currentColony = currentColony
        self.nextID = nextID
    }
    
    enum CodingKeys: String, CodingKey {
        case colonies
        case templates
        case currentColony
        case nextID
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        colonies = try container.decode([Colony].self, forKey: .colonies)
        templates = try container.decode([Colony].self, forKey: .templates)
        currentColony = try container.decode(Int.self, forKey: .currentColony)
        nextID = try container.decode(Int.self, forKey: .nextID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colonies, forKey: .colonies)
        try container.encode(templates, forKey: .templates)
        try container.encode(currentColony, forKey: .currentColony)
        try container.encode(Data.nextID, forKey: .nextID)
    }
    
    static func save(data: Data, as pathComponent: String) {
        let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent(pathComponent)
        let dataSaver = DataSaver(colonies: data.colonies, templates: data.templates, currentColony: data.currentColony, nextID: Data.nextID)
        do {
            let data = try JSONEncoder().encode(dataSaver)
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
    
    static func load(from pathComponent: String) -> Data? {
        let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent(pathComponent)
        do {
            let loadedData = try JSONDecoder().decode(DataSaver.self, from: Foundation.Data(contentsOf: url))
            let data = Data()
            data.colonies = loadedData.colonies
            data.templates = loadedData.templates
            data.currentColony = loadedData.currentColony
            Data.nextID = loadedData.nextID
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
}
