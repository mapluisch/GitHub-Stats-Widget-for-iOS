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
        let useProfilePicture = entry.configuration.useProfilePicture as? Bool ?? true
        let imageData = useProfilePicture ? entry.avatarImageData : UIImage(named: "github-light")?.pngData()
        let showDate = entry.configuration.showDate as? Bool ?? false
        let profileSize:CGFloat = showDate ? 40 : 48
        let iconSize:CGFloat = showDate ? 16 : 20
        let spacing:CGFloat = showDate ? 2 : 10
        
        return VStack(spacing: 0) {
            HStack {
                if useProfilePicture || imageData != nil {
                    UserAvatarView(imageData: imageData, miniatureImage: true)
                        .frame(width: profileSize, height: profileSize)
                    Divider().frame(height: profileSize)
                }
                
                VStack {
                    Link(destination: URL(string: "githubstatswidget://user/\(entry.configuration.username ?? "mapluisch")")!) {
                        VStack(spacing: spacing) {
                            Spacer()
                            
                            HStack{
                                Spacer()
                                
                                Image(systemName: "person.2.fill")
                                    .scaledToFit()
                                    .frame(width: iconSize, height: iconSize)
                                CountTextView(prefix: "", currentCount: entry.followers, previousCount: entry.previousFollowers)
                                
                            }
                            Divider()
                            
                            HStack{
                                Spacer()
                                
                                Image(systemName: "star.circle.fill")
                                    .scaledToFit()
                                    .frame(width: iconSize, height: iconSize)
                                CountTextView(prefix: "", currentCount: entry.stars, previousCount: entry.previousStars)
                                    .offset(x: 0, y: 1)
                                
                            }
                            
                            Spacer()
                        }
                    }.foregroundColor(linkColor)
                }
            }
            if showDate {
                DateInfoView()
            }
        }
    }
}
