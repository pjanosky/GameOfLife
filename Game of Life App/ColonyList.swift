//
//  ColonyList.swift
//  Game of Life App
//
//  Created by Kiran Mak on 11/17/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

struct ColonyList: View {
    @EnvironmentObject var data: Data
    @State private var showTemplatesModal = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    List {
                        ForEach(0..<self.data.colonies.count, id: \.self) { index in
                            NavigationLink(destination: ColonyDetail(colony: self.$data.colonies[index])
                                .onAppear {
                                    self.data.currentColony = index
                                }
                            ) {ColonyPreview(colony: self.data.colonies[index])}
                        }.onDelete(perform: self.deleteColony)
                    }
                }
            }
            .navigationBarTitle("Colonies")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: self.addColony) {
                    Text("+").font(.title)
                }
             )
            ColonyDetail(colony: self.$data.colonies[self.data.currentColony])
        }
    }
    
    func addColony() {
        self.data.colonies.append(Colony(name: "Untitled", size: 60))
        self.data.currentColony = self.data.colonies.count - 1
        self.showTemplatesModal = true
    }
    
    func deleteColony(at offsets: IndexSet) {
        self.data.colonies.remove(atOffsets: offsets)
    }
}


struct ColonyList_Previews: PreviewProvider {
    static var data = Data()
    init() {
        if let loadedData = Data.load(fromFile: "data") {
            ColonyList_Previews.data = loadedData
        }
    }
    
    static var previews: some View {
        ColonyList()
    }
}

