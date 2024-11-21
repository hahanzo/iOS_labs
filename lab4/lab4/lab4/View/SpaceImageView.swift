//
//  SpaceImageView.swift
//  lab4
//
//  Created by IPZ-31 on 21.11.2024.
//

import SwiftUI

struct CardFront : View {
    let width : CGFloat
    let height : CGFloat
    let explanation: String
    @Binding var degree : Double

    var body: some View {
        GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .frame(width: width, height: height)
                            .shadow(color: .gray, radius: 2, x: 0, y: 0)

                        VStack {
                            Spacer()
                            Text(explanation)
                                .padding(20)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Spacer()
                        }
                    }
                    .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
                }
                .frame(width: width, height: height)
            }
}

struct CardBack: View {
    let width: CGFloat
    let height: CGFloat
    let imageURL: String
    @Binding var degree: Double
    @State private var dragOffset = CGSize.zero
    @State private var imageSize = CGSize.zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.blue.opacity(0.7), lineWidth: 3)
                    .frame(width: width, height: height)

                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                            .cornerRadius(20)
                            .clipped()
                    } else if phase.error != nil {
                        Text("Failed to load image")
                    } else {
                        ProgressView()
                    }
                }
                .mask(RoundedRectangle(cornerRadius: 20))
            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: width, height: height)
    }
}

struct SpaceImageView: View {
    // MARK: - Variables
    @StateObject private var viewModel = SpaceImageViewModel()
    @State private var lastVisibleIndex: Int? = nil
    @State private var cardDegrees: [Int: (frontDegree: Double, backDegree: Double)] = [:]

    let durationAndDelay: CGFloat = 0.3

    // MARK: - Flip Card Function
    func flipCard(for index: Int) {
        var degrees = cardDegrees[index] ?? (frontDegree: -90.0, backDegree: 0.0)
        let isFlipped = degrees.frontDegree == 0.0

        if isFlipped {
            degrees.frontDegree = -90.0
            degrees.backDegree = 0.0
        } else {
            degrees.frontDegree = 0.0
            degrees.backDegree = 90.0
        }

        withAnimation(.linear(duration: durationAndDelay)) {
            cardDegrees[index] = degrees
        }
    }

    // MARK: - View Body
    var body: some View {
        GeometryReader{ geometry in
                ScrollView(.vertical) {
                    LazyVStack(spacing:0) {
                        ForEach(viewModel.spaceImages.indices, id: \.self) { index in
                            let spaceImage = viewModel.spaceImages[index]
                            
                            VStack {
                                ZStack {
                                    CardFront(
                                        width: geometry.size.width,
                                        height: geometry.size.height,
                                        explanation: spaceImage.explanation,
                                        degree: Binding(
                                            get: { cardDegrees[index]?.frontDegree ?? -90.0 },
                                            set: { _ in }
                                        )
                                    )
                                    
                                    CardBack(
                                        width: geometry.size.width,
                                        height: geometry.size.height
,
                                        imageURL: spaceImage.url,
                                        degree: Binding(
                                            get: { cardDegrees[index]?.backDegree ?? 0.0 },
                                            set: { _ in }
                                        )
                                    )
                                }
                                .onTapGesture {
                                    flipCard(for: index)
                                }
                                .onAppear {
                                    if index == viewModel.spaceImages.count - 3 {
                                        viewModel.fetchSpaceImageData()
                                    }
                                }
                                .id(index)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .scrollTargetLayout()
                }
                .onAppear {
                    viewModel.fetchSpaceImageData()
                }
                .onChange(of: lastVisibleIndex) { newIndex in
                    if let lastIndex = newIndex, lastIndex == viewModel.spaceImages.count - 3 {
                        viewModel.fetchSpaceImageData()
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
        }
    }
