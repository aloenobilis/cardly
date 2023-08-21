# cardly

### features
- add card via form or camera
- configure banned countries
- checks if card already exists
- checks if card is within banned countries
- only shows cards from "this" session
- validation: Luhn Check and others


### notes
NOTE: There is only an Android build as this was written on a linux machine. The Podfile will require updating for IOS for the card camera capture functionality, easy to do but requires a mac.<br/>
NOTE: The sessions length defaults to 8 hours but can be set by changing ```SESSION_LENGTH_HOURS```

### clone 
```
git clone https://github.com/arxerr/cardly.git
```

```
cd cardly
```

### run 
```
flutter run -d <device_id>
```

### test
```
flutter test
```

### design
```
                                               CARDLY APP
┌─────────────────────────┐                   ────────────
│ BANNDED COUNTRIES MODEL │
│ + banned List<str>      │
└──────────┬──────────────┘   ┌─────────────────────────────────────────────┐
           │                  │                                             │
           ▼                  │ ┌───────┐                                   │
   Configure list of ─────────┤►├┼┼┼┼┼┼┼│                                   │
   banned countries           │ │┼┼┼┼┼┼┼│                                   │
                              │ └───────┘                                   │
                              │                                             │
                              │ ┌─────────────────────────────────────────┐ │
                              │ │    24                         6         │ │
                              │ │  CARDS                    COUNTRIES     │ │
                              │ │                                         │ │
                              │ └─────────────────────────────────────────┘ │
                              │                                             │
                              │ ┌─────────────────────────────────────────┐ │
                              │ │    +                            +       │◄├───── Camera captures
    Card form input, ─────────┤►│ Input Card                Capture Card  │ │      card information
                              │ │                                         │ │
                              │ └─────────────────────────────────────────┘ │
                              │                                             │
                              │                                             │       ┌───────────────────┐
                              │                                             │       │                   │
     List view builder,──────►│  Cards From Today:                          │       │ CARD MODEL        │
                              │ ┌─────────────────────────────────────────┐ │       │ + card number     │
                              │ │ ******** 45 6123                  VISA  ◄─┼────── │ + card type       │
                              │ │ South Africa                            │ │       │ + cvv             │
                              │ └─────────────────────────────────────────┘ │       │ + created         │
                              │                                             │       │                   │
                              │ ┌─────────────────────────────────────────┐ │       └───────────────────┘
                              │ │ ******** 09 1234              MASTERCARD│ │
                              │ │ United Kingdom                          │ │
                              │ └─────────────────────────────────────────┘ │
                              │                                             │
                              │                                             │
                              └─────────────────────────────────────────────┘
```

## Software Development Log


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
DONE: utils luhn is from https://github.com/tiagohm/checkdigit/blob/master/lib/src/luhn.dart

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
previous 8 hours will be shown. <br/>
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


### 1.9 - styling 
DONE: added styling and padding where needed <br/>

### 1.10 - tests
DONE: added bloc validation tests (positives) <br/>
DONE: added bank card model test <br/>
DONE: added banned countries model test 







