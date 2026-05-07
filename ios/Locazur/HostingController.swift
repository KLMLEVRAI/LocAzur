import UIKit
import SwiftUI

class HostingController: UIHostingController<ContentView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: ContentView())
    }
}
