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
    @AppStorage("notifyOnStatsChange") private var notifyOnStatsChange: Bool = false
    @State private var lockscreenWidgetUsername: String = ""

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
                    if #available(iOS 16.0, *) {
                        HStack {
                            Text("Lockscreen  Username")
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                            Spacer()
                            Spacer()
                            Spacer()
                            TextField("", text: $lockscreenWidgetUsername)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(minWidth: 100, idealWidth: 150, maxWidth: .infinity)
                                .onChange(of: lockscreenWidgetUsername) { newValue in
                                    UserDefaults.setLockscreenWidgetUsername(lockscreenUsername: newValue)
                            }
                        }
                    }
                    
                    Toggle("Redirect to GitHub", isOn: $shouldRedirectToGitHub)
                        .onChange(of: shouldRedirectToGitHub) { newValue in
                            UserDefaults.setShouldRedirectToGitHub(newValue)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: colorTheme.colors[circleColorThemeIndex]!))
                    
                    Toggle("Notify on stats change", isOn: $notifyOnStatsChange)
                        .onChange(of: notifyOnStatsChange) { newValue in
                            if newValue {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                                    if granted {
                                        DispatchQueue.main.async {
                                            UserDefaults.standard.set(true, forKey: "notifyOnStatsChange")
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.notifyOnStatsChange = false
                                            UserDefaults.standard.set(false, forKey: "notifyOnStatsChange")
                                        }
                                    }
                                }
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: colorTheme.colors[circleColorThemeIndex]!))
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
