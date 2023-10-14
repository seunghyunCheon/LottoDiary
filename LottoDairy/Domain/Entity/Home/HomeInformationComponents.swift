//
//  HomeInformationComponents.swift
//  LottoDairy
//
//  Created by Sunny on 10/14/23.
//

import UIKit

struct HomeInformationComponents {

    let type: AmountType
    let title: String
    let image: UIImage

    init(type: AmountType) {
        self.type = type
        self.title = type.rawValue
        self.image = type.image
    }
}
