//
//  UserAvatarView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 20.02.24.
//

import SwiftUI

struct UserAvatarView: View {
    var imageData: Data?
    var miniatureImage: Bool = false

    var body: some View {
        if (miniatureImage) {
            Group {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.gray)
                }
            }
            .clipShape(Circle())
            .shadow(radius: 1)
        } else {
            Group {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .shadow(radius: 5)
        }
    }
}

