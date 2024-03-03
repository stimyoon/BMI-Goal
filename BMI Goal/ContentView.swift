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
    let bmiTargets = [25.0, 30, 35, 40, 45]

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
        let formatedDateString = Pad(str: dateString, length:   8)
            //String(String(dateString.reversed()).padding(toLength: 8, withPad: " ", startingAt: 0).reversed())

        if( today == day){
            return Pad(str: "", length: 4)
        }else{
            return formatedDateString
        }
    }
    
    func Pad(str: String, length: Int) -> String{
        if (str == "0"){
            return String( "".padding(toLength: length, withPad: " ", startingAt: 0))
        }
        return String(String(str.reversed()).padding(toLength: length, withPad: " ", startingAt: 0).reversed())
    }
    
    func StatsValid()->Bool{
        let wt = Double(Lbs) ?? 0
        let feet = Double (Feet) ?? 0
        let inches  = Double (Inches) ?? 0
        
        if ((inches == 0) && (feet == 0) || wt == 0) {
            return false
        }else{
            return true
        }
        
    }
    
    func TargetBMI(i: Int) -> String{
        let padLen = 4
        //if (currentBMI < bmiTarget[i]){
        let wt = Double(Lbs) ?? 0
        let strBMITarget = String(format:"%.0f", bmiTargets[i])
        
        if (wt <= 0 || currentBMI < bmiTargets[i] ){
            return (Pad(str: "", length: padLen))
        }else{
            return (Pad(str: strBMITarget, length: padLen))
        }
        
//        return (Pad(str: "", length: padLen))
    }
    
    func GoalWeight(wtToLoose: Double) -> String{
        let wt = Double(Lbs) ?? 0
        let goalWeight = wt - wtToLoose
        let padLen = 5
        let strGoalWeight = String(format:"%.0f", goalWeight)
        if (wt <= goalWeight){
            return Pad(str: "", length: padLen)
        }

        if (StatsValid() && wt > goalWeight) {
            return Pad(str: strGoalWeight, length: padLen)
        }else{
            return Pad(str: "", length: padLen)
        }
        
    
    }
    
    func WtToLoose(targetBMI: Double) -> String{
        let padLen = 5
        
        let wtToLoose = round( weightToLoose(targetBMI: targetBMI))
        let strWtToLoose = String(format: "%.0f", wtToLoose)
        
        if (round(wtToLoose) <= 0){
            return Pad(str: "", length: padLen)
        }
        
        if( wtToLoose > 999){
            return Pad(str: "Limit", length: padLen)
        }
        if (StatsValid()) {
            return Pad(str: strWtToLoose, length: padLen)
        }else{
            return Pad(str: "", length: padLen)
        }
    }
    
    func WksToGo(targetBMI: Double, weeklyWtLoss: Double) -> String{
        let padLen = 5
        let numWks = numWeeksOfWtLoss(targetBMI: targetBMI, weeklyWtLoss: weeklyWtLoss)
        let strWksToGo = String(format:"%.0f", round(numWks))

        if (numWks <= 0){
            return Pad(str: "", length: padLen)
        }
        if (numWks < 1 && numWks > 0){
            return Pad(str: "\(Int( round(7 * numWks) ))d", length: padLen)
        }
        if (numWks > 999){
            return Pad(str: "Limit", length: padLen)
        }
        
        if(StatsValid()){
            return Pad(str: strWksToGo, length: padLen)
        }else {
            return Pad(str: "", length: padLen)
        }
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ZStack{
            NavigationView{
                Form{
                    Section(header: Text("Current Statistics")){//Current statistics
                        VStack {
                            HStack {
                                Text("Wt")
                                NumberFieldView(" lbs", text: $Lbs)

                                Text("Ht")
                                NumberFieldView(" feet", text: $Feet)
                                NumberFieldView(" inches", text: $Inches)
                            }
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Spacer()
                                        Button("Done") {
                                            dismissKeyboard()
                                        }
                                    }
                                }
                            }
                            // Output the calculated BMI Value
                            HStack {
                                Text("BMI").font(.largeTitle)
                                Text("\(currentBMI, specifier: "%.1f")")
                                .font(.largeTitle) // 1 decimal point accuracy
                            }.padding()
                        }//VStack End
                    }//Section End

                    

                    Section(header: Text("BMI Goal Projections: Choose weight loss per week.")){
                        Picker("lbs per week", selection: $index){
                            ForEach(0 ..< weightLossPerWkValues.count, id: \.self){
                                Text("\(self.weightLossPerWkValues[$0], specifier: "%.1f") lbs")
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        HStack{
                            HStack{
                                Text("BMI").lineLimit(1).minimumScaleFactor(0.2)
                                Spacer()
                            }.frame(maxWidth: 40)
                            Text("Wt").frame(maxWidth: .infinity)
                            Text("Chg").frame(maxWidth: .infinity)
                            Text("Wks").frame(maxWidth: .infinity)
                            Text("Date").frame(maxWidth: .infinity)
                        }
                        ForEach(bmiTargets.indices, id: \.self){ a in
                            HStack {
                                Text(" \(self.bmiTargets[a], specifier : "%.0f")")
                                Spacer()
                                Text(self.GoalWeight(wtToLoose: self.weightToLoose(targetBMI: self.bmiTargets[a]))).font(Font.system(.body, design: .monospaced))
                                Spacer()
                                Text(self.WtToLoose(targetBMI: self.bmiTargets[a])).font(Font.system(.body, design: .monospaced))
                                Spacer()
                                Text(self.WksToGo(targetBMI: self.bmiTargets[a], weeklyWtLoss: self.weightLossPerWkValues[self.index])).font(Font.system(.body, design: .monospaced))
                                Spacer()
                                Text("\(self.FutureDate(numWks: self.numWeeksOfWtLoss(targetBMI: self.bmiTargets[a], weeklyWtLoss: self.weightLossPerWkValues[self.index])))").font(Font.system(.body, design: .monospaced))
                            }
                            
                        }
                    }//Section End
                   
                }//Form End
                    .navigationBarTitle("Goal BMI")
                    .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
                
            }//NavigationView End

            VStack {
                HStack{
                    Spacer()
                    Image("Camilla-Caduceus4").resizable().frame(width: 90, height: 90)
                }.padding()
                Spacer()
                Text("By S. Tim Yoon, MD/PhD").font(.system(size: 8, weight: .light, design: .serif)).italic()
            }//End VStack
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



