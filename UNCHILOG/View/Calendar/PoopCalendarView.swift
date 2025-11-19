//
//  PoopCalendarView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI
import SCCalendar
import Combine

struct PoopCalendarView: View {
    @Environment(\.rootEnvironment) private var rootEnvironment
    
    @State private var viewModel = CalendarViewModel.shared
    
    private let weekColumns = Array(repeating: GridItem(spacing: 0), count: 7)
    
    var body: some View {
        VStack(spacing: 0) {
            
            yearAndMonthSelectionView()

            dayOfWeekListView()
            
            CarouselCalendarView(
                yearAndMonths: viewModel.state.yearAndMonths,
                displayCalendarIndex: viewModel.state.displayCalendarIndex,
                backMonthPage: viewModel.backMonthPage,
                forwardMonthPage: viewModel.forwardMonthPage
            )

            Spacer()
            
        }.onAppear {
            viewModel.onAppear()
        }.onDisappear {
            viewModel.onDisappear()
        }
    }
    
    
    /// 年月選択ヘッダービュー
    private func yearAndMonthSelectionView() -> some View {
        HStack {
            Spacer()
                .frame(width: 30)
                .padding(.horizontal, 10)
            
            Spacer()

            Button {
                viewModel.backMonthPage()
            } label: {
                Image(systemName: "chevron.backward")
            }.frame(width: 10)

            NavigationLink {
                TheMonthDetailView(currentMonth: viewModel.getCurrentYearAndMonth())
            } label: {
                Text(viewModel.getCurrentYearAndMonth().yearAndMonth)
                    .fontM(bold: true)
                    .frame(width: 100)
            }.frame(width: 100)
                .padding()
            
            Button {
                viewModel.forwardMonthPage()
            } label: {
                Image(systemName: "chevron.forward")
            }.frame(width: 10)

            Spacer()
            
            Button {
                viewModel.moveTodayCalendar()
            } label: {
              Image("back_today")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 30)
            }.padding(.horizontal, 10)
              .frame(width: 30)

        }.foregroundStyle(.exThema)
            .padding(.horizontal, 15)
    }

    /// 曜日リスト
    private func dayOfWeekListView() -> some View {
        LazyVGrid(columns: weekColumns, spacing: 0) {
            ForEach(viewModel.state.dayOfWeekList, id: \.self) { week in
                Text(week.shortSymbols)
                    .if(week.isSunday) { view in
                        view
                            .foregroundStyle(.exNegative)
                    }.if(week.isSaturday) { view in
                        view
                            .foregroundStyle(.exSub)
                    }.if(!week.isSaturday && !week.isSunday) { view in
                        view
                            .foregroundStyle(.exThema)
                    }.fontS(bold: true)
            }
        }.padding(.vertical, !DeviceSizeUtility.isSESize ? 8 : 4)
            .frame(height: !DeviceSizeUtility.isSESize ? 40 : 25)
    }
}


#Preview {
    PoopCalendarView()
}
