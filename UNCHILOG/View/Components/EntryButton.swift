//
//  EntryButton.swift
//  UNCHILOG
//
//  Created by t&a on 2024/04/03.
//

import SwiftUI

struct EntryButton: View {
    public var date = Date()
    var body: some View {
        NavigationLink {
            PoopInputView(theDay:date)
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 25))
                .frame(width: 50, height: 50)
                .foregroundStyle(.indigo)
                .background(.exThema)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
        }
    }
}

#Preview {
    EntryButton()
}
