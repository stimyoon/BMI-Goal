//
//  Content2.swift
//  BMI Goal
//
//  Created by Tim Yoon on 4/10/20.
//  Copyright © 2020 Tim Yoon. All rights reserved.
//

import SwiftUI
import Combine


struct BmiView: View {
    @State private var Lbs = ""
    @State private var Feet = ""
    @State private var Inches = ""
    @State private var index = 2
    @State private var currentLbs = 0.0
    private var wtToLoose = 0.0
    private var desiredLbs = 0.0
    private var wt = 0.0 //Double(Lbs) ?? 0
    private var feet = 0.0 //Double (Feet) ?? 0
    private var inches  = 0.0 //Double (Inches) ?? 0
    private var bmi = 0.0

    
    let weightLossPerWkValues = [1.0, 1.5, 2.0, 2.5, 3.0]
    let bmiTargets = [25, 30, 35, 40, 45]
    
    var currentBMI: Double{
        let wt = Double(Lbs) ?? 0
        let feet = Double (Feet) ?? 0
        let inches  = Double (Inches) ?? 0
        
        if ((inches == 0) && (feet == 0)) {
            return 0
        }
        let totalInches: Double = (feet * 12) + inches
        let bmiValue = (703.0 * wt) / (totalInches * totalInches)
        
        return bmiValue
    }
    
    func CacluateBMI (wt: Double, ft: Double, inches: Double) -> Double  {
        if ((inches == 0) && (ft == 0)) {
            return 0
        }
        
        let totalInches: Double = (ft * 12) + inches
        let bmiValue = (703.0 * wt) / (totalInches * totalInches)
     
        return bmiValue
    }
    
    func numWeeksOfWtLoss(targetBMI: Double, weeklyWtLoss: Double) -> Double{
        let wt = Double(Lbs) ?? 0
        let feet = Double (Feet) ?? 0
        let inches  = Double (Inches) ?? 0
        
        if ((inches == 0) && (feet == 0)) {
            return 0
        }
        
        let totalInches: Double = (feet * 12) + inches
        let bmiValue = (703.0 * wt) / (totalInches * totalInches)
        if targetBMI > bmiValue{
            return 0
        }
        
        let targetWt = (targetBMI * totalInches * totalInches) / 703
        let numWeeks = (wt - targetWt) / weeklyWtLoss
        
        return numWeeks
    }
    
    func weightToLoose(targetBMI: Double) -> Double{
        let wt = Double(Lbs) ?? 0
        let feet = Double (Feet) ?? 0
        let inches  = Double (Inches) ?? 0
        
        if ((inches == 0) && (feet == 0)) {
            return 0
        }
        
        let totalInches: Double = (feet * 12) + inches
        let bmiValue = (703.0 * wt) / (totalInches * totalInches)
        if targetBMI > bmiValue{
            return 0
        }
        
        let targetWt = (targetBMI * totalInches * totalInches) / 703
        return wt - targetWt
        
    }

    func FutureDate(numWks: Double) -> String{
        let numDays = Int( round(numWks * 7) )
        let today = Date()
        let calendar = Calendar.current
        let day = calendar.date(byAdding: .day, value: numDays, to: today) ?? Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let dateString = formatter.string(from: day)

        return dateString
    }
    
    var body: some View {
        ZStack{
            NavigationView{
                Form{
                    Section{
                        VStack {
                            HStack {
                                Text("Wt")
                                TextField(" lbs", text: $Lbs)
                                    .keyboardType(.numberPad)
                                    .border(Color.black)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onReceive(Just(Lbs)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            self.Lbs = filtered
                                        }
                                    }
                               
                                Spacer()
                                Text("Ht")
                                TextField(" feet", text: $Feet)
                                    .keyboardType(.numberPad)
                                    .border(Color.black)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onReceive(Just(Feet)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            self.Feet = filtered
                                        }
                                    }
                                Spacer()
                                TextField(" inches", text: $Inches)
                                    .keyboardType(.numberPad)
                                    .border(Color.black)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onReceive(Just(Inches)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            self.Inches = filtered
                                        }
                                    }
                            }.padding()
                            
                            // Output the calculated BMI Value
                            HStack {
                                Text("BMI").font(.largeTitle)
                                Text("\(currentBMI, specifier: "%.1f")")
                                .font(.largeTitle) // 1 decimal point accuracy
                            }.padding()
                        }
                    }
                    
                    Section(header: Text("How much weight loss per week?")){
                        Picker("lbs per week", selection: $index){
                            ForEach(0 ..< weightLossPerWkValues.count){
                                Text("\(self.weightLossPerWkValues[$0], specifier: "%.1f") lbs")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        HStack{
                            Text("BMI")
                            Spacer()
                            Text("Wt Loss")
                            Spacer()
                            Text("Wks")
                            Spacer()
                            Text("Goal")
                        }

                        HStack {
                            Text("25 BMI")
                            Spacer()
                            Text("\(weightToLoose(targetBMI: 25), specifier : "%2.0f") lbs")
                                .multilineTextAlignment(.trailing)
                            Spacer()
                            Text("\(numWeeksOfWtLoss(targetBMI: 25, weeklyWtLoss: weightLossPerWkValues[index]), specifier: "%2.0f") wks")
                                .multilineTextAlignment(.trailing)
                                
                            Spacer()
                            Text("\(FutureDate(numWks: numWeeksOfWtLoss(targetBMI: 25, weeklyWtLoss: weightLossPerWkValues[index])))")
                        }
                        HStack {
                            Text("30 BMI")
                            Spacer()
                            Text("\(weightToLoose(targetBMI: 30), specifier : "%.0f") lbs")
                                
                            Spacer()
                            Text("\(numWeeksOfWtLoss(targetBMI: 30, weeklyWtLoss: weightLossPerWkValues[index]), specifier: "%.0f") wks")
                                
                            Spacer()
                            Text("\(FutureDate(numWks: numWeeksOfWtLoss(targetBMI: 30, weeklyWtLoss: weightLossPerWkValues[index])))")
                        }
                        HStack {
                            Text("35 BMI")
                            Spacer()
                            Text("\(weightToLoose(targetBMI: 35), specifier : "%.0f") lbs")
                                
                            Spacer()
                            Text("\(numWeeksOfWtLoss(targetBMI: 35, weeklyWtLoss: weightLossPerWkValues[index]), specifier: "%.0f") wks")
                                
                            Spacer()
                            Text("\(FutureDate(numWks: numWeeksOfWtLoss(targetBMI: 35, weeklyWtLoss: weightLossPerWkValues[index])))")
                        }
                        HStack {
                            Text("40 BMI")
                            Spacer()
                            Text("\(weightToLoose(targetBMI: 40), specifier : "%.0f") lbs")
                                
                            Spacer()
                            Text("\(numWeeksOfWtLoss(targetBMI: 40, weeklyWtLoss: weightLossPerWkValues[index]), specifier: "%.0f") wks")
                                
                            Spacer()
                            Text("\(FutureDate(numWks: numWeeksOfWtLoss(targetBMI: 40, weeklyWtLoss: weightLossPerWkValues[index])))")
                        }
                        HStack {
                            Text("45 BMI")
                            Spacer()
                            Text("\(weightToLoose(targetBMI: 45), specifier : "%.0f") lbs")
                                
                            Spacer()
                            Text("\(numWeeksOfWtLoss(targetBMI: 45, weeklyWtLoss: weightLossPerWkValues[index]), specifier: "%.0f") wks")
                                
                            Spacer()
                            Text("\(FutureDate(numWks: numWeeksOfWtLoss(targetBMI: 45, weeklyWtLoss: weightLossPerWkValues[index])))")

                        }
                    }
                    }.navigationBarTitle("BMI Goal")
                .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})

            }
            VStack {
                HStack{
                    Spacer()
                    Image("caduceus1").resizable().padding().frame(width: 80.0, height: 80.0)
                }

                Spacer()
                Text("By Dr. S. Tim Yoon, MD/PhD").font(.system(size: 8, weight: .light, design: .serif))
                .italic()
            }
            //        .padding()
        }

       
    }
}

struct ContentView: View {
    @State var name: String = "0"
    
    var body: some View {
            BmiView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
