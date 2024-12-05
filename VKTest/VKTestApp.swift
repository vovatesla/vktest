import SwiftUI

@main
struct VKTestApp: App {
    let apiClient: APIClient = APIClient.shared

    var body: some Scene {
        WindowGroup {
            ContentView(apiClient: apiClient)
        }
    }
}
