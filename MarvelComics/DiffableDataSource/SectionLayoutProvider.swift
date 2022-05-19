//
//  SectionLayoutProvider.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit

public protocol SectionLayoutProvider {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?    
}
