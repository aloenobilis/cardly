# Software Development Log


DONE: dependencies <br/>
DONE: home page <br/>
TODO: banned countries configure <br/>
TODO: add card by form <br/>
TODO: add card from camera (form population) <br/>
TODO: form validation, REGEX's based on card type <br/>
TODO: card input formatter <br/>
TODO: tests


### inception
DONE: ```flutter create cardly```

### 1.0 - app design (simple)
DONE: created a simple app design and outline <br/>
DONE: updated readme.me  <br/>
DONE: created todos

### 1.1 - dependencies 
DONE: add dependencies <br/>
NOTE: will add another dependency later on for the credit card info from the camera <br/>
```yaml
responsive_grid: ^2.4.2                   # <-- bootstrap like columns and rows
rxdart: ^0.27.7                           # <-- streams (form)
sqflite: ^2.3.0                           # <-- database 
path: ^1.8.3                              # <-- database path
path_provider: ^2.0.15                    # <-- database path directory
```

### 1.2 - home screen outline (ui) 
DONE: created ``HomeScreen`` and layed out some very basic ui components such as the stats, buttons and card list. <br/>
DONE: added the drawer component and settings icon using a global key for the configuration setting of banned countries.


### 1.3 add card screen, bloc, validation
This adds the UI and streams functionality for adding a card. <br/>
DONE: validation.dart - validators for the streams <br/>
DONE: card bloc and provider for "global state" <br/>
DONE: add card screen and widgets (number, cvv and county fields) <br/>
DONE: uitls luhn is from https://github.com/tiagohm/checkdigit/blob/master/lib/src/luhn.dart

### 1.4 - database provider, set to state
DONE: created DbProvider with getCards and addCard methods <br/>
DONE: created BankCard model  <br/>
DONE: updated HomeScreen to set all cards from the database to state <br/>
DONE: updated AddCardScreen to infer the card type based on visa and mastercard regex <br/>
DONE: added visa and mastercard asset images <br/>
DONE: added dependency ```intl``` for data formatting 
```yaml
intl: ^0.18.1                             # <-- date formatting
```

### 1.5 - banned countries 
DONE: banned countries model (.countries List<String> -> TEXT :> jsonEncode|jsonDecode) <br/>
DONE: banned countries bloc and provider (method: add, get) <br/>
DONE: banned countries screen for adding and viewing banned countries 

### 1.6 - add card banned country check 
DONE: in DbProvider.addCard, prior to adding the card, the country is checked in banned countries. 

### 1.7 - cards within session time 
DONE: created ```DbProvider.SESSION_LENGTH_HOURS = 8``` which ensures that only cards from the
previous 8 hours will be shown. 
DONE: getCards error handling in HomeScreen 


### 1.8 - card capture
DONE: on card capture the card number and issuer are passed as screen paramaters which then poopulate state and the CardBloc.number stream. <br/>
DONE: created CardIssuers class (DRY) <br/>
DONE: upgraded minSdkVersion to 21 <br/>
DONE: added dependency credit card scanner 

```yaml
credit_card_scanner: ^1.0.5               # <-- card camera scan capture
```

STILL-TODO CARD CAPTURE IOS: <br/>
Once you run flutter build ios a Podfile and Podfile.lock will be created for you in the ios directory.
- The minimum target for iOS should be >= 12.0.0
- Comment out the use_frameworks! line from under Podfile of your Flutter project.  You can find this Podfile under your_flutter_project/ios/Podfile


<br/>
Styling And Error Messages
Tests