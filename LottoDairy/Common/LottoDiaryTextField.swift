//
//  LottoDiaryTextField.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/18.
//

import UIKit
import Combine

final class LottoDiaryTextField: UITextField {
    
    enum TextFieldType {
        case letter
        case number
    }
    
    var textPublisher: AnyPublisher<String, Never> {
        self.publisher(for: .editingChanged)
            .compactMap { self.text }
            .eraseToAnyPublisher()
    }
    
    var pickerPublisher = PassthroughSubject<String, Never>()

    var yearMonthPickerPublisher = PassthroughSubject<[Int], Never>()
    
    convenience init(placeholder: String, type: TextFieldType, align: NSTextAlignment) {
        self.init(frame: .zero)
        
        switch type {
        case .number:
            self.keyboardType = .numberPad
        default :
            self.keyboardType = .default
        }
        
        textAlignment = align
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.gmarketSans(size: .title3, weight: .medium),
                .foregroundColor: UIColor.designSystem(.gray63626B) ?? .systemGray
            ]
        )
        
        configureDefaultStyle()
    }

    convenience init() {
        self.init(frame: .zero)
        self.font = .gmarketSans(size: .title3, weight: .bold)
        self.tintColor = .clear
    }

    func configureAttributedStringOfYearMonthText(year: Int, month: Int) {
        configureAttributedStringOfDatePicker(year: year, month: month)
    }

    private func configureAttributedStringOfDatePicker(year: Int, month: Int) {
        let yearString = NSMutableAttributedString(
            string: "\(year)년",
            attributes: [
                .foregroundColor: UIColor.white
            ]
        )
        let monthString = NSMutableAttributedString(
            string: " \(month)월 >",
            attributes: [
                .foregroundColor: UIColor.designSystem(.mainBlue) ?? .systemBlue
            ]
        )
        yearString.append(monthString)

        self.attributedText = yearString
    }
    
    private func configureDefaultStyle() {
        textColor = .white
        tintColor = .white
        font = .gmarketSans(size: .title2, weight: .medium)
        autocapitalizationType = .none
        autocorrectionType = .no
        clearsOnBeginEditing = false
    }
}
