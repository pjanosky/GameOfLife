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
    @State var timer: Timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: {_ in})
    @State var running = false
    var width: CGFloat
    var formatter: NumberFormatter
    
    var newTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { t in
            self.evolve()
        }
    }
    
    init(colony: Binding<Colony>, width: CGFloat) {
        _colony = colony
        self.width = width
        
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
    }
    
    var controls: some View {
        Group {
            Toggle(isOn: self.$wrapping) {
                Text("Wrapping")
                }
            .frame(minWidth: 135)
            .layoutPriority(-1)
            
            HStack {
                Button(action: {self.evolve(generations: self.numGenerations)}) {
                    Image(systemName: "arrowshape.turn.up.right.circle")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
                
                Stepper("\(self.numGenerations) \((self.numGenerations == 1) ? "Generation" : "Generations")", value: self.$numGenerations, in: 1...100)
                    .frame(minWidth: 210)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Button(action: {
                    self.toggleTimer()}
                ) {
                    Image(systemName: self.running ? "pause.circle" : "play.circle")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
                
                VStack {
                    Text("Speed")
                    Text("\(self.formatter.string(from: NSNumber(value: self.speed))!)s")
                }
            
                Slider(value: self.$speed, in: 0.09...3.01, step: 0.1, onEditingChanged: {_ in
                    if self.running {
                        self.createNewTimer()
                    }
                })
            }
        }
        .frame(height: 60)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color("ControlsBackgroundColor"))
        ).onDisappear {
            self.timer.invalidate()
        }
    }
    
    var body: some View {
        Group {
            if self.width > 670 {
                HStack {
                    self.controls
                }.frame(height: 60)
            } else {
                VStack {
                    self.controls
                }.frame(height: 200)
            }
        }.layoutPriority(-1)
    }
    
    func toggleTimer() {
        if running {
            timer.invalidate()
        } else {
            evolve()
            createNewTimer()
        }
        running.toggle()
    }
    
    func createNewTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { t in
            self.evolve()
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
        GeometryReader { geometry in
            ControlsView(colony: self.$colony, width: geometry.size.width)
        }
    }
}
