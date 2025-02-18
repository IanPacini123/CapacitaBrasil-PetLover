//
//  CustomTabview.swift
//  Petlover
//
//  Created by Ian Pacini on 12/02/25.
//

import SwiftUI

struct CustomTabview<Content: View>: View {
    @State private var currentItem: UUID = UUID()
    private let content: [TabItem<Content>]

    init(@TabItemBuilder content: () -> [TabItem<Content>]) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Spacer()
            ForEach(content) { item in
                if item.id == currentItem {
                    item
                }
            }
            Spacer()
            HStack {
                Spacer()
                ForEach(content) { item in
                    Button {
                        self.currentItem = item.id
                    } label: {
                        item.label
                            .foregroundStyle(currentItem == item.id ? Color.accentColor : Color.secondary70Darkblue)
                    }
                    Spacer()
                }
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            self.currentItem = content.first?.id ?? UUID()
        }
    }
}

struct TabItem<Content: View>: View, Identifiable {
    let id = UUID()
    let content: Content
    let label: AnyView

    init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> some View) {
        self.content = content()
        self.label = AnyView(label())
    }

    var body: some View {
        content
    }
}

@resultBuilder
struct TabItemBuilder {
    static func buildBlock<content: View>(_ components: TabItem<content>...) -> [TabItem<content>] {
        return components
    }
}

#Preview {
    CustomTabview {
        TabItem {
            Text("Content 1")
        } label: {
            Image("IconHouse")
                .renderingMode(.template)
        }
        
        TabItem {
            Text("Content 2")
        } label: {
            Image("IconPaw")
                .renderingMode(.template)
        }
        
        TabItem {
            Text("Content 3")
        } label: {
            Image("IconGear")
                .renderingMode(.template)
        }
    }
}
