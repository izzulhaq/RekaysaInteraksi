import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
<<<<<<< HEAD
=======

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
>>>>>>> 47f295d0c36afbd07332575b8efa84a73b524d73
}
