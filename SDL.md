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