//
//  PoopDetailView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct PoopDetailView: View {
    public var poop: Poop
    var body: some View {
        HStack {
            Text(poop.getDate())
            Text(poop.wrappedId.uuidString)
            Text(poop.wrappedMemo)
        }
    }
}

//#Preview {
//    PoopDetailView()
//}
