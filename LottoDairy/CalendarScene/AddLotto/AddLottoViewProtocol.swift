//
//  AddLottoViewProtocol.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//
import Foundation
import UIKit

protocol AddLottoViewProtocol: Presentable {
    var selectedDate: Date? { get set }
    var onCalendar: ((Lotto) -> Void)? { get set }
}

