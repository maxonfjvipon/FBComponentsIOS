//
//  FreeSeatView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 10/24/20.
//

import SwiftUI

struct SeatView: View {
    var seatInRowCount: Int
    var isSeatFree: Bool
    
    @ViewBuilder
    var body: some View {
        if (isSeatFree) {
            Circle()
                .foregroundColor(.green)
                .frame(width: 300 / CGFloat(seatInRowCount), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        } else if (!isSeatFree) {
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .frame(width: 300 / CGFloat(seatInRowCount), height: 300 / CGFloat(seatInRowCount), alignment: .center)
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 400 / CGFloat(seatInRowCount) / 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct SeatView_Previews: PreviewProvider {
    static var previews: some View {
        SeatView(seatInRowCount: 10, isSeatFree: true)
    }
}
