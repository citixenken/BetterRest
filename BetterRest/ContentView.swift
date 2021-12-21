//
//  ContentView.swift
//  BetterRest
//
//  Created by Ken Muyesu on 19/12/2021.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("At what time do you want to wake up?")
                    .font(.headline)
                DatePicker("Enter a time ", selection: $wakeUp, displayedComponents: .hourAndMinute)
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
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculatedBedTime() {
        //create instance of SleepCalculator
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Perfect time for your sleep is..."
            alertMessage = sleepTime.formatted(date: .complete, time: .shortened)
            
        } catch {
            alertTitle = "ERROR!"
            alertMessage = "Sorry, problem encountered when calculating your bedtime"
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
