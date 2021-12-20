//
//  ContentView.swift
//  BetterRest
//
//  Created by Ken Muyesu on 19/12/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Text(Date.now, format: .dateTime.day().month().year())
                
                DatePicker("Enter a date: ", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
                    .labelsHidden() //allows screen readers to use it for voiceovers
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.5)
                    .padding(20)
                
                Stepper("\(coffeeAmount.formatted()) cups", value: $coffeeAmount, in: 0...12, step: 1)
                    .padding(20)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
