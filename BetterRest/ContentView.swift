//
//  ContentView.swift
//  BetterRest
//
//  Created by Anton Serdyuchenko on 16.12.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute).labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)

                Text("Daily coffee intake")
                    .font(.headline)

                Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)

                // more to come
            }
            .padding()
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
        }

    }
    
    func calculateBedtime() {}
    
    
}

#Preview {
    ContentView()
}
