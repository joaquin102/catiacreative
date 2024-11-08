//
//  Extensions.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/25/24.
//

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
