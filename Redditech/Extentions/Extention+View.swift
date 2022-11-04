//
//  Extention+Vew.swift
//  Redditech
//
//  Created by Pierre Jeannin on 03/11/2022.
//

import Foundation
import SwiftUI

struct ComponentPreview<Component: View>: View {
    var component: Component

    var body: some View {
        ForEach(ColorScheme.allCases) { scheme in
            ForEach(ContentSizeCategory.smallestAndLargest) { category in
                self.component
                    .previewLayout(.sizeThatFits)
                    .background(Color(UIColor.systemBackground))
                    .colorScheme(scheme)
                    .environment(\.sizeCategory, category)
                    .previewDisplayName(
                        "\(scheme.previewName) + \(category.previewName)"
                    )
            }
        }
    }
}

extension View {
    func previewAsComponent() -> some View {
        ComponentPreview(component: self)
    }
}
