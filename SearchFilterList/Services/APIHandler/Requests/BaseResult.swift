//
//  BaseResult.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import Foundation

public struct BaseResult<T: Decodable> {
    var status: Bool
    var data: T?
    var message: String
}
