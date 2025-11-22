//
//  CountIconView.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/22.
//

import SwiftUI

struct CountIconView: View {
    
    let countIcon: CountIconItem
    
    private var iconSize: CGFloat = 40
    
    var body: some View {
        switch countIcon {
        case .simple:
            Color.exPoopYellow
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: 60))
        case .simpleDark:
            Color.exThema
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: 60))
        case .simpleBlack:
            Color.exText
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: 60))
        case .poop:
            Image("noface_poop")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .offset(y: -5)
        }
    }
}
