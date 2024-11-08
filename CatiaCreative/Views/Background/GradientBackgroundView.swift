//
//  GradientBackgroundView.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/11/24.
//

import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "100C21"), Color(hex: "605880")]),
            startPoint: .bottom,
            endPoint: .top
        )
        .edgesIgnoringSafeArea(.all) // Makes sure the gradient covers the entire screen
    }
}
