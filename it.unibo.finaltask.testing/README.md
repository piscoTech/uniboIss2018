# Test

Il testing è limitato al core del problema, cioè il QActor `cleaner`. Il testing è effettuato isolando questo componente in un progetto dedicato contenuto in questa cartella con opportune modifiche per facilitare il testing. Si rimanda alla [documentazione](https://github.com/piscoTech/uniboIss2018/blob/master/Documentazione/Relazione.pdf), sezione 2.4 per le considerazioni effettuate.

## Setup iniziale
Dopo aver importato il progetto in questa cartella su Eclipse (il workspace principale del progetto vero e proprio va benissimo) aprire un terminale in questa cartella ed eseguire, avendo cura di usare le [stesse accortezze](https://github.com/piscoTech/uniboIss2018#setup-iniziale-macos) già citate per il progetto principale, il comando

```bash
gradle -b build_ctxFinalSysTesting.gradle eclipse
```

## Testing
A questo punto è possibile eseguire i test utilizzando JUnit selezionando tutte le classi (una sola) all'interno della cartella `test`. Nel caso si vogliano anche i report sulla copertura del codice o si preferisca usare Gradle, si può usare da terminale il comando

```bash
gradle -b build_ctxFinalSysTesting.gradle test
```

**Nota:** I test impiegano ~4 minuti a eseguire a causa del fatto che il robot viene fatto muovere con gli stessi tempi come se fosse in una stanza vera (o virtuale).

**Nota:** Non è necessario predisporre alcun ambiente prima di lanciare i test, i test provvederanno a tutto da soli.
