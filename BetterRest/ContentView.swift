//
//  ContentView.swift
//  BetterRest
//
//  Created by Anton Serdyuchenko on 16.12.2024.
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
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute).labelsHidden()
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }

                Section(header: Text("Daily coffee intake")) {
                    Picker("Please choose a coffee amount", selection: $coffeeAmount) {
                        ForEach(0..<11) {
                            Text("\($0)")
                        }
                    }
                    Text("You selected: ^[\(coffeeAmount) cup](inflect: true)")
                }
                
                Section(header: Text("Your ideal bedtime is…")) {
                    Text("\(calculateBedtime())")
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedtime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is…"
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
}

#Preview {
    ContentView()
}
