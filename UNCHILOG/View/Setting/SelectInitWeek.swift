//
//  SelectInitWeek.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI

struct SelectInitWeek: View {
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    var body: some View {
        
        VStack {
            Text("週始まり")
                .fontWeight(.bold)
                .foregroundStyle(.exText)
                .padding(.top, 70)
            
            Text("カレンダーの週の始まりの曜日を変更することができます。")
                .foregroundStyle(.exText)
                .padding(.top, 10)
                .font(.caption)
            
            List {
                ForEach(SCWeek.allCases, id: \.self) { week in
                    Button {
                        rootEnvironment.saveInitWeek(week: week)
                        rootEnvironment.setFirstWeek(week: week)
                    } label: {
                        HStack {
                            Text(week.fullSymbols)
                            
                            Spacer()
                            
                            if rootEnvironment.initWeek == week {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.exText)
                            }
                        }
                        
                    }
                }.foregroundStyle(.exText)
            }
        }
    }
}

#Preview {
    SelectInitWeek()
}
