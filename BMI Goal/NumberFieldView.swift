//
//  NumberFieldView.swift
//  BMI Goal
//
//  Created by Tim Coder on 2/28/24.
//  Copyright © 2024 Tim Yoon. All rights reserved.
//

import SwiftUI
import Combine

struct NumberFieldView: View {
    let prompt: String
    @Binding var numberString: String
    init(_ prompt: String, text numberString: Binding<String>) {
        self.prompt = prompt
        self._numberString = numberString
    }
    var body: some View {
        TextField(prompt, text: $numberString)
            .keyboardType(.numberPad)
            .border(Color.black)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onReceive(Just(numberString)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.numberString = filtered
                }
            }
    }
}
struct WrappedNumberField: View {
    @State private var numberString = "205"
    var body: some View {
        NumberFieldView("lbs", text: $numberString)
    }
}
#Preview {
    WrappedNumberField()
}
