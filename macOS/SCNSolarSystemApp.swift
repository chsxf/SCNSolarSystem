import Cocoa

@main
class SCNSolarSystemApp: NSObject, NSApplicationDelegate {

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    static private func setup() -> Void {
        let rect = NSRect(x: 100, y: 100, width: 640, height: 360)
        
        let view = SolarSystemView(frame: rect)
        
        let window = NSWindow(contentRect: rect, styleMask: [.titled, .closable, .resizable], backing: .buffered, defer: false)
        window.title = "SKTetris"
        window.contentView = view
        window.makeKeyAndOrderFront(nil)
        window.toggleFullScreen(nil)
        
        view.setupFirstResponder()
    }
    
    static private func setupMainMenu() -> Void {
        let applicationName = ProcessInfo.processInfo.processName
        let mainMenu = NSMenu()
        
        let menuItemOne = NSMenuItem()
        menuItemOne.submenu = NSMenu(title: "menuItemOne")
        menuItemOne.submenu?.items = [
            NSMenuItem(title: "Quit \(applicationName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        ]
        
        mainMenu.items = [menuItemOne]
        NSApp.mainMenu = mainMenu
    }
    
    static func main() -> Void {
        NSApp = NSApplication.shared
        
        let delegate = SCNSolarSystemApp()
        NSApp.delegate = delegate
        
        setup()
        setupMainMenu()
        
        NSApp.run()
    }

}
