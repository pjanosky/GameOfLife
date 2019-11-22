//
//  ControlsView.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/16/19.
//

import SwiftUI
import Combine

struct ControlsView: View {
    @Binding var colony: Colony
    @State var speed = 1.0
    @State var numGenerations = 1
    @State var wrapping = false
    @EnvironmentObject var evolveTimer: EvolveTimer
    var formatter: NumberFormatter
    let backgroundColor = Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1))
    
    var newTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { t in
            self.evolve()
        }
    }
    
    init(colony: Binding<Colony>) {
        _colony = colony
        
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
    }
    
    var body: some View {
        HStack {
            Group {
                Toggle(isOn: self.$wrapping) {
                    Text("Wrapping")
                }
                .frame(width: 135)
                
                HStack {
                    Button(action: {self.evolve(generations: self.numGenerations)}) {
                        Image(systemName: "arrowshape.turn.up.right.circle")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    
                    Stepper("\(self.numGenerations) \((self.numGenerations == 1) ? "Generation" : "Generations")", value: self.$numGenerations, in: 1...100)
                        .frame(width: 210)
                        .multilineTextAlignment(.center)
                }
                
                HStack {
                    Button(action: {
                        self.toggleTimer()}
                    ) {
                        Image(systemName: self.evolveTimer.timer.isValid ? "pause.circle" : "play.circle")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    
                    VStack {
                        Text("Speed")
                        Text("\(formatter.string(from: NSNumber(value: self.speed))!)s")
                    }
                
                    Slider(value: self.$speed, in: 0.1...5, step: 0.1, onEditingChanged: {_ in
                        self.evolveTimer.timer = Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { t in
                            self.evolve()
                        }
                    })
                }
            }
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                .frame(height: 60)
                .foregroundColor(backgroundColor)
            )
        }.onDisappear {
            self.evolveTimer.timer.invalidate()
        }
    }
    
    func toggleTimer() {
        if evolveTimer.timer.isValid {
            evolveTimer.timer.invalidate()
        } else {
            evolve()
            evolveTimer.timer = newTimer
        }
    }
    
    func evolve() {
        if wrapping {
            colony.evolveWrap()
        } else {
            colony.evolve()
        }
    }
    
    func evolve(generations: Int) {
        for _ in 0..<generations {
            evolve()
        }
    }
}



struct ControlsView_Previews: PreviewProvider {
    @State static var colony = Data().colonies[0]
    static var previews: some View {
        ControlsView(colony: self.$colony)
    }
}

class EvolveTimer: ObservableObject {
    @Published var timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false) {_ in }
}
