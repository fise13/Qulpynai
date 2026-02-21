//
//  LocationSelectorView.swift
//  Qulpynai
//
//  Location selector — multi-location menu
//

import SwiftUI

struct LocationSelectorView: View {
    let locations: [Location]
    @Binding var selectedLocation: Location?
    let colorScheme: ColorScheme

    var body: some View {
        if !locations.isEmpty {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text("Store")
                    .font(DSTypography.subheadline)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DSSpacing.sm) {
                        ForEach(locations) { location in
                            DSChip(
                                title: location.name,
                                isSelected: selectedLocation?.id == location.id
                            ) {
                                selectedLocation = location
                            }
                        }
                    }
                }
            }
        }
    }
}
