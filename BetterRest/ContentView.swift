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
                Spacer()
                Text("At what time do you want to wake up?")
                    .font(.headline)
                DatePicker("Enter a time ", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding(20)
                //Spacer()
                
                Text("What's your desired amount of sleep?")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    .padding(20)
                //Spacer()
                
                Text("What's your daily coffee intake?")
                    .font(.headline)
                Stepper(coffeeAmount == 1 ? " 1 cup" : "\(coffeeAmount.formatted()) cups", value: $coffeeAmount, in: 0...30, step: 1)
                    .padding(20)
                Spacer()
                
            }
            .navigationTitle("Better Rest")
            .toolbar {
                Button("Calculate", action: calculatedBedTime)
                    .font(.title2)
            }
        }
    }
    
    func calculatedBedTime() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
