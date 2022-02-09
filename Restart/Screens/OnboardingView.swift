//
//  OnboardingView.swift
//  Restart
//
//  Created by Давид Михайлов on 09.02.2022.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Property

    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Text("Onboarding")
                .font(.largeTitle)

            Button(action: {
                isOnboardingViewActive = false
            }) {
                Text("Start")
            }
        } //: VSTACK
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
