//
//  PoopDetailView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct PoopDetailView: View {
    public var theDay: SCDate
    public var poop: Poop
    var body: some View {
        VStack {
            HStack {
                Text(poop.getDate())
                Text(poop.wrappedId.uuidString)
            }
            Text(poop.wrappedMemo)
            
            NavigationLink {
                PoopInputView(theDay: theDay.date, poop: poop)
            } label: {
                Text("EDIT")
            }
        }
    }
}

//#Preview {
//    PoopDetailView()
//}
