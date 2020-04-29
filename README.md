# Haskell script to download all Springer books released for free during the 2020 COVID-19 quarantine

```bash
stack build
stack exec -- download-books <TOPIC>
```

Example:
```bash
stack exec -- download-books math
```


