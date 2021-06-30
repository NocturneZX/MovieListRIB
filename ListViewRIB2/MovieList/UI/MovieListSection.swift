//
//  MovieListSection.swift
//  ListViewRIB2
//
//  Created by Julio Reyes on 6/28/21.
//

import Foundation
import RxDataSources

struct MovieListSection {
  let header: String
  var items: [Movie]
}

extension MovieListSection: SectionModelType {
  init(original: MovieListSection, items: [Movie]) {
    self = original
    self.items = items
  }
}
