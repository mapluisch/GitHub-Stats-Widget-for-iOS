//
//  SettingsView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 19.02.24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    let circleSize: CGFloat = 30
    let fontSize: CGFloat = 12
    let iconSize: CGFloat = 12
    let circleColorThemeIndex: Int = 3
    
    @State var colorTheme: ColorTheme = ColorTheme.currentTheme
    @AppStorage("shouldRedirectToGitHub") private var shouldRedirectToGitHub: Bool = false

    var body: some View {
        let linkColor = colorScheme == .dark ? Color.white : Color.black
                
        NavigationView {
            List {
                Section(header: Text("")) {
                    NavigationLink(destination: ThemeSelectionView()) {
                        Label {
                            Text("Theme")
                        } icon: {
                            Image(systemName: "paintbrush.fill")
                                .font(.system(size: iconSize))
                                .foregroundColor(.white)
                                .background(
                                    Circle().fill(colorTheme.colors[circleColorThemeIndex]!)
                                        .frame(width: circleSize, height: circleSize)
                                )
                        }
                    }
                    Toggle("Redirect to GitHub", isOn: $shouldRedirectToGitHub)
                        .onChange(of: shouldRedirectToGitHub) { newValue in
                            UserDefaults.setShouldRedirectToGitHub(newValue)
                    }.toggleStyle(SwitchToggleStyle(tint: colorTheme.colors[circleColorThemeIndex]!))
                }
                
                Section(header: Text("About")) {
                    
                    Link(destination: URL(string: "https://apps.apple.com/app/6477889134?action=write-review")!) {
                        Label {
                            Text("Rate App").foregroundColor(linkColor)
                        } icon: {
                            Image(systemName: "star.fill")
                                .font(.system(size: iconSize))
                                .foregroundColor(.white)
                                .background(
                                    Circle().fill(colorTheme.colors[circleColorThemeIndex]!)
                                        .frame(width: circleSize, height: circleSize)
                                )
                        }
                    }
                    
                    let email = "hello@martinpluisch.com"
                    let subject = "GitHub Stats Widget Feedback"
                    let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    
                    Link(destination: URL(string: "mailto:\(email)?subject=\(encodedSubject)")!) {
                        Label {
                            Text("Contact").foregroundColor(linkColor)
                        } icon: {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: iconSize))
                                .foregroundColor(.white)
                                .background(
                                    Circle().fill(colorTheme.colors[circleColorThemeIndex]!)
                                        .frame(width: circleSize, height: circleSize)
                                )
                        }
                    }
                    
                    Link(destination: URL(string: "https://github.com/mapluisch/GitHub-Stats-Widget-for-iOS")!) {
                        Label {
                            Text("GitHub Repo").foregroundColor(linkColor)
                        } icon: {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: iconSize))
                                .foregroundColor(.white)
                                .background(
                                    Circle().fill(colorTheme.colors[circleColorThemeIndex]!)
                                        .frame(width: circleSize, height: circleSize)
                                )
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                self.colorTheme = ColorTheme.currentTheme
            }
        }
    }
}
