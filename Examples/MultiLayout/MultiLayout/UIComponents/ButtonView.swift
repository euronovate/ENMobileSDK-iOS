//
//  ButtonView.swift
//  MultiLayout
//
//  Created by Giovanni Trezzi on 07/11/24.
//
import SwiftUI

struct ButtonView: View {

    let action: () -> Void
    let label: String

    var body: some View {

        Button(action: {

            action()

        }, label: {

            Text(label)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.enOrange))
                )
        })
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.enOrange))
        )
    }
}
