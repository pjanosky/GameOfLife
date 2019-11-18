//
//  ColonyList.swift
//  Game of Life App
//
//  Created by Kiran Mak on 11/17/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

struct ColonyList: View {
    @ObservedObject var data = Data()
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List {
                    ForEach(0 ..< self.data.colonies.count, id: \.self) { index in
                        NavigationLink(destination: ColonyDetail(colony: self.$data.colonies[index])) {
                            ColonyPreview(colony: self.$data.colonies[index])
                        }
                    }.frame(height: geometry.size.width)
                }
            }
            .navigationBarTitle("Menu")
        }
    }
}

struct ColonyList_Previews: PreviewProvider {
    static var previews: some View {
        ColonyList()
    }
}
