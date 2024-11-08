//
//  ButtonView.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 11/4/24.
//
import SwiftUI

struct ButtonView: View {
    
    var text: String;
    var buttonTapped:reactiveBlock?
    
    var body: some View {
        Button(action: {
            print("Scan art")
        }) {
            Text(text)
                .font(.custom(style: .gilroyBold, size: .medium))
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal, 20)
        }
        .background(Color.custom(.red))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ButtonView(text: "Scan me!")
}
