//
//  String+extension.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 18.02.2024.
//

extension Optional where Wrapped == String {
    var isNotEmpty: Bool {
        return self != ""
    }
}
