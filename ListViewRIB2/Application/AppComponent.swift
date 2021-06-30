//
//  AppComponent.swift
//  ListViewRIB2
//
//  Created by Julio Reyes on 6/28/21.
//

import Foundation
import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
