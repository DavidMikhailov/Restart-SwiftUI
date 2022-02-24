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

    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTitle: String = "Share."

    // MARK: - Body
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)

            // MARK: - Header
            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 0) {
                    Text(textTitle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTitle)

                    Text("""
                    It's not how much we give but
                    how much love we put into giving.
                    """)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                } //: Header
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)

                // MARK: - Center
                ZStack {
                    CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                    // При dragging кольцо движется в противоположную сторону.
                        .offset(x: imageOffset.width * -1)
                        // Отрицательное число для блюр эффекта ничего не даст, нужно только положительное, поэтому используем abs().
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)

                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        // Прозрачность с использование проперти и тернарного оператора.
                        .opacity(isAnimating ? 1 : 0)
                    // Умножение в оффсете значит скорость анимации. Также в зависимости от оси мы можем выбрать движение имаджа.
                        .offset(x: imageOffset.width * 1.2, y: 0)
                    // Ротейшн эффект - это закругление имаджа при его перетягивании.
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .gesture(
                        //Движение перетаскивания, вызывающее действие при изменении последовательности событий перетаскивания.
                            DragGesture()
                                .onChanged { gesture in
                                    if abs(imageOffset.width) <= 150 {
                                        // Меняем оффсет.
                                        imageOffset = gesture.translation

                                        // Исчезают стрелочки, при жесте dragging.
                                        withAnimation(.linear(duration: 0.25)) {
                                            indicatorOpacity = .zero

                                            textTitle = "Give."
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    // В конце жеста меняет оффсет на ноль. То есть возвращает имадж на место.
                                    imageOffset = .zero

                                    withAnimation(.linear(duration: 0.25)) {
                                        indicatorOpacity = 1

                                        textTitle = "Share."
                                    }
                                }
                        )//: Gesture
                    // Анимация жеста перетягивания.
                        .animation(.easeOut(duration: 1), value: imageOffset)
                } //: Center
                // Наложение поверх всего симыолв с двумя стрелками.
                .overlay (
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimating ? 1 : 0)
                        // Показывает стрелки через 2 секунды, с эффектом, длящимся 1 сек.
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                        .opacity(indicatorOpacity)
                    , alignment: .bottom
                )

                Spacer()

                // MARK: - Footer
                ZStack {
                    // Parts of the custom button

                    // 1. Background (static)
                    Capsule()
                        .fill(Color.white.opacity(0.2))

                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)

                    // 2. Call-to-action (static)
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)

                    // 3. Capsule (dynamic)
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        Spacer()
                    }

                    // 4. Circle (Draggable)
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.2))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded({ _ in
                                    withAnimation(Animation.easeOut(duration: 0.5)) {
                                        if buttonOffset > buttonWidth / 2 {
                                            buttonOffset = buttonWidth - 80
                                            isOnboardingViewActive = false
                                        } else {
                                            buttonOffset = 0
                                        }
                                    }
                                })
                        )//: Gesture
                        Spacer()
                    }//: HSTACk

                }//: Footer
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1.0), value: isAnimating)
            }//: VSTACK
        } //: ZSTACK
        .onAppear {
            isAnimating = true
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
