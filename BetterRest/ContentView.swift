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
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    //computed property
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Enter a time ", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(20)
                } header: {
                    Text("At what time do you want to wake up?")
                        .font(.headline)
                }

                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .padding(20)
                } header: {
                    Text("What's your desired amount of sleep?")
                        .font(.headline)
                }

                Section {
//                    Stepper(coffeeAmount == 1 ? " 1 cup" : "\(coffeeAmount.formatted()) cups", value: $coffeeAmount, in: 0...30, step: 1)
//                        .padding(20)
                    Picker(coffeeAmount == 1 ? " 1 cup" : "\(coffeeAmount.formatted()) cups", selection: $coffeeAmount) {
                        ForEach(0..<31) {
                            Text($0 == 1 ? "1 cup" : "\($0) cups")
                        }
                    }
                } header: {
                    Text("What's your daily coffee intake?")
                        .font(.headline)
                }

//                Button(action: calculatedBedTime()) {
//                    Text("Calculate")
//                        .font(.title)
//                }
//                .tint(.green)
//                .buttonStyle(.borderedProminent)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .controlSize(.large)

                Section {
                    Text(calculatedBedTime())
                        .font(.title2)
                        .foregroundColor(Color(UIColor.systemRed))
                } header: {
                    Text("Recommended bedtime is: ")
                        .font(.headline)
                }
            }
            .navigationTitle("Better Rest")
//            .toolbar {
//                Button("Calculate", action: calculatedBedTime)
//                    .font(.title2)
//            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("OK") {}
//            } message: {
//                Text(alertMessage)
//            }
        }
    }

    func calculatedBedTime() -> String {
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
            return sleepTime.formatted(date: .omitted, time: .shortened)

        } catch {
            alertTitle = "ERROR!"
            return "Sorry, problem encountered when calculating your bedtime"
        }

        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
