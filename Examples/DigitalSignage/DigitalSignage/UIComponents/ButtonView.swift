//
//  ButtonView.swift
//  DigitalSignage
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
