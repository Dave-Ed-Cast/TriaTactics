//
//  CustomRectangle.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 15/07/24.
//

import SwiftUI

struct CustomRectangle: View {

    let invert: Bool

    var body: some View {
        if #available(iOS 16.0, *) {
            UnevenRoundedRectangle(topLeadingRadius: invert ? 50 : 0, bottomLeadingRadius: invert ? 50 : 0, bottomTrailingRadius: invert ? 0 : 50, topTrailingRadius: invert ? 0 : 50, style: .continuous)
        } else {
            CustomRoundedRectangle(topLeft: invert ? 50 : 0, bottomLeft: invert ? 50 : 0, topRight: invert ? 0 : 50, bottomRight: invert ? 0 : 50)
        }
    }

}

struct CustomRoundedRectangle: Shape {
    var topLeft: CGFloat = 0.0
    var bottomLeft: CGFloat = 0.0
    var topRight: CGFloat = 0.0
    var bottomRight: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.size.width
        let height = rect.size.height

        let topLeftRadius = min(min(topLeft, height / 2), width / 2)
        let topRightRadius = min(min(topRight, height / 2), width / 2)
        let bottomLeftRadius = min(min(bottomLeft, height / 2), width / 2)
        let bottomRightRadius = min(min(bottomRight, height / 2), width / 2)

        path.move(to: CGPoint(x: width / 2.0, y: 0))

        path.addLine(to: CGPoint(x: width - topRightRadius, y: 0))
        path.addArc(center: CGPoint(x: width - topRightRadius, y: topRightRadius),
                    radius: topRightRadius,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(0),
                    clockwise: false)

        path.addLine(to: CGPoint(x: width, y: height - bottomRightRadius))
        path.addArc(center: CGPoint(x: width - bottomRightRadius, y: height - bottomRightRadius),
                    radius: bottomRightRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)

        path.addLine(to: CGPoint(x: bottomLeftRadius, y: height))
        path.addArc(center: CGPoint(x: bottomLeftRadius, y: height - bottomLeftRadius),
                    radius: bottomLeftRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: topLeftRadius))
        path.addArc(center: CGPoint(x: topLeftRadius, y: topLeftRadius),
                    radius: topLeftRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)

        path.closeSubpath()

        return path
    }
}

#Preview {
    VStack {
        CustomRectangle(invert: false)
        CustomRectangle(invert: true)
    }
        .frame(width: 200, height: 100)
}
