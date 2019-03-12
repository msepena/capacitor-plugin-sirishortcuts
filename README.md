# Capacitor Siri shortcuts

This plugin adds support for donating and removing Siri Shortcuts. 

## Getting Started

npm i @msepena/capacitor-plugin-sirishortcuts

### Prerequisites

The plugin only works in XCode 10, and on the iOS 12 platform.

### Installing

npm i @msepena/capacitor-plugin-sirishortcuts --save


```

import { Component } from '@angular/core';
import { Platform } from '@ionic/angular';
import { Plugins } from '@capacitor/core';
import { SiriShortcutsPlugin } from "@msepena/capacitor-plugin-sirishortcuts";

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html'
})

export class AppComponent {
  constructor(
    private platform: Platform
  ) {
    this.initializeApp();
  }

  initializeApp() {
    this.platform.ready().then(() => {
      const { StatusBar, SplashScreen, Toast, SiriShortcuts } = Plugins;
      SplashScreen.hide();
    
      SiriShortcuts.addListener('appLaunchBySirishortcuts', (resp) => {
        Toast.show({text: resp['deeplink']});
      });
    });
  }
}

 donate() {
    const data = {
      persistentIdentifier: 'open-my-app',
      title: 'Careteam',
      suggestedInvocationPhrase: 'Add to Careteam',
      isEligibleForSearch: true,
      userInfo: {deeplink: "care-team"},
      isEligibleForPrediction: true,
    }
    const { Toast, SiriShortcuts } = Plugins;

    SiriShortcuts.donate(data).then(resp => {
      Toast.show( {text: "successfully submitted"});
    }, error => {
      Toast.show( {text: error['message']});
    });


  }
```


## Built With

https://capacitor.ionicframework.com/docs/plugins/js

## Contributing



## Versioning



## Authors



## License
MIT


## Acknowledgments
