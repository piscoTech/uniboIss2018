# Ingegneria dei Sistemi Software M

Repository del tema finale del corso di Ingegneria dei Sistemi Software M

## Setup iniziale (macOS)

Installa i due plug-in per QActor di Eclipse forniti dal prof, Gradle e Node.js, quindi installa MongoDB e Mosquitto via HomeBrew usando

```bash
brew install mosquitto
brew install mongodb
```

Crea un workspace Eclipse nella root di questa repository e importa i due progetti `it.unibo.finaltask` e `it.unibo.frontend`. Apri un terminale nella cartella `it.unibo.finaltask` ed esegui

```bash
gradle -b build_ctxFinalSysAnalysis.gradle eclipse
```

Potrebbero essere necessarie più esecuzioni di questo comando, nel caso apri la configurazione del _Build Path_ e assicurati che non ci siano cartelle duplicate. Apri la configurazione del _Build Path_ di `it.unibo.frontend` ed elimina tutte le cartelle dal tab _Source_. A questo punto Eclipse non dovrebbe segnalare alcun errore, solo qualche warning.

Per avviare facilmente i vari server creiamo degli alias inserendo queste righe nel file `~/.bash_profile`

```bahs
alias mosquitto='/usr/local/opt/mosquitto/sbin/mosquitto -c /usr/local/etc/mosquitto/mosquitto.conf'
alias mongodb='mongod --dbpath "/my/custom/path/to/mongodb"'
```

Per il secondo alias assicurati di aver creato la cartella nel percorso specificato.

Installa tutti i package richiesti da Node.js nelle cartelle `it.unibo.frontend/nodeCode/frontend`, `VirtualRobotJS/WebGLScene` e `VirtualRobotJS/server` usando, in ognuna di queste, il comando

```bash
npm install
```

### Xcode configuration
_Siccome Xcode è usato da una sola persona per costruire il file `ISS 2018 – Mock.app` la sua configurazione viene omessa, ma l'unica cosa da fare è scaricare i pacchetti usando CocoaPods._

## Avvio del sistema

1. Avvia (in qualsiasi ordine)
	- Mosquitto usando l'alias `mosquitto`
	- Il robot virtuale usando `startRobot.sh`
	- MongoDB usando l'alias `mongodb`
	- I mock per l'hardware avviando `ISS 2018 – Mock.app`
	- Il frontend server usando `startFrontEnd.sh`
2. Avvia l'applicazione QActor facendo partire la classe `it.unibo.ctxfinalSysAnalysis` in `src-gen` nel progetto `it.unibo.finaltask`

È ora possibile visualizzare il robot virtuale all'indirizzo http://localhost:8081 e il frontend server all'indirizzo http://localhost:3000. Ricaricando la pagina del robot virtuale viene ripristinata la configurazione iniziale della scena (file `VirtualRobotJS/WebGLScene/sceneConfig.js`), se l'applicazione non era in fase di pulizia automatica quando la scena è stata ricaricata questa si è automaticamente riconfigurata per poter ripartire all'invio di un nuovo comando *Start*.

## Commit

Fai attenzione che Eclipse non modifichi i file `.gitignore` eliminando la riga `.classpath`: i file `.classpath` _**NON**_ devono essere committati, questi contengono infatti la configurazione del _Build Path_ e vanno configurati inizialmente come specificato sopra. Se Eclipse propone questa modifica del `.gitignore` ripristina il file alla versione precedente.
