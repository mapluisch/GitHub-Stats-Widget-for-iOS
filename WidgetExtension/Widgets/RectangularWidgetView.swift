//
//  RectangularWidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 27.02.24.
//

import SwiftUI

struct RectangularWidgetView: View {
    let entry: GitHubUserStatsEntry
    var colorScheme: ColorScheme

    var body: some View {
        let linkColor = colorScheme == .dark ? Color.white : Color.black
        HStack {
            if (entry.configuration.useProfilePicture as? Bool ?? true) {
                UserAvatarView(imageData: entry.avatarImageData, miniatureImage: true)
                    .frame(width: 48, height: 48)
                Divider()
            }
            
            VStack {
                Link(destination: URL(string: "githubstatswidget://user/\(entry.configuration.username ?? "mapluisch")")!) {
                    VStack() {
                        Spacer()
                        
                        HStack{
                            Spacer()
                        
                            Image(systemName: "person.2.fill")
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            CountTextView(prefix: "", currentCount: entry.followers, previousCount: entry.previousFollowers)
                            
                        }
                        Divider()
                        
                        HStack{
                            Spacer()
                        
                            Image(systemName: "star.circle.fill")
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            CountTextView(prefix: "", currentCount: entry.stars, previousCount: entry.previousStars)
                                .offset(x: 0, y: 1)
                            
                        }
                    
                        Spacer()
                    }
                }.foregroundColor(linkColor)
            }
        }
    }
}
