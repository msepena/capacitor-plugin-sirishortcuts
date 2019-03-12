#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(SiriShortcutsPlugin, "SiriShortcuts",
    CAP_PLUGIN_METHOD(donate, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(removeAll, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(remove, CAPPluginReturnPromise);
)
