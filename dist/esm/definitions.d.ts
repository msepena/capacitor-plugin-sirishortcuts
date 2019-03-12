declare global {
    interface PluginRegistry {
        SiriShortcuts?: SiriShortcutsPlugin;
    }
}
export interface SiriShortcutInput {
    persistentIdentifier: string;
    title: string;
    suggestedInvocationPhrase?: string;
    isEligibleForPrediction?: boolean;
    isEligibleForSearch?: boolean;
    userInfo?: UserInfo;
}
export interface UserInfo {
    [key: string]: string;
}
export interface SiriShortcutsResult {
    value: boolean;
}
export interface SiriPluginListenerHandle {
    remove: () => void;
}
export declare type SiriShortcutsCallback = (state: UserInfo) => void;
export interface SiriShortcutsPlugin {
    donate(options: SiriShortcutInput): Promise<void>;
    removeAll(): Promise<void>;
    remove(options: {
        identifiers: [string];
    }): Promise<void>;
    addListener(eventName: 'appLaunchBySirishortcuts', listenerFunc: SiriShortcutsCallback): SiriPluginListenerHandle;
}
