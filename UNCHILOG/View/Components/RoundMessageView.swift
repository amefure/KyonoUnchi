//
//  RoundMessageView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/04/01.
//

import SwiftUI

// 角丸の吹き出しUI
struct RoundChatView: Shape {
    // 角の丸み
    let radius: CGFloat = 10

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // 左上の角を丸める
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        // 右上の角を丸める
        path.addLine(to: CGPoint(x: rect.maxX - radius - 20, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radius - 20, y: rect.minY + radius), radius: radius, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        
        // 三角形部分
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.minY + 15))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.maxY - 15))
        

        // 右下の角を丸める
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.maxY - radius))
        path.addArc(center: CGPoint(x: rect.maxX - radius - 20, y: rect.maxY - radius), radius: radius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)

        // 左下の角を丸める
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)

        path.closeSubpath()

        return path
    }
}
