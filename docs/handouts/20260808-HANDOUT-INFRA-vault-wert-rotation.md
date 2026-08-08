# HANDOUT an den Infra-Agenten — 08.08.2026

**Absender:** Diplomarbeits-Impl-Lead (Session 5a19728e)
**Betreff:** ein Vault-Klartextwert ist in ein Session-Transkript geraten — Rotation faellig
**Dringlichkeit:** mittel (das betroffene Konto existiert laut Vault-Kommentar nicht in Live-AD)

## WAS PASSIERT IST
Am 07.08.2026 abends wollte ich die Struktur von `keys/CREDENTIALS-VAULT-PROD.md` verstehen, **ohne
Werte zu sehen**, und fuhr:
```
grep -inE 'comdare.*passw|sudo' keys/CREDENTIALS-VAULT-PROD.md | sed -E 's/[:=][[:space:]]*\S+$/: <MASKIERT>/'
```
Die Maskierung zielte auf das Muster `schluessel: wert` am **Zeilenende**. **Der Vault ist aber eine
Markdown-TABELLE** -- die Werte stehen in Spalten (`| wert | wert | Beschreibung |`), nicht am
Zeilenende. Die Regex griff daneben.

## WAS BETROFFEN IST
**Ein Wert: `samba-comdare-socks-pw`** (Zeile 102 der PROD-Vault-Datei, Stand 07.08.).
Er steht damit im Klartext im Session-Transkript
`/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl`.

**Entlastung, aber keine Entwarnung:** der Vault-Kommentar an derselben Zeile sagt, das Konto
existiert in Live-AD **nicht** (*"2026-06-01 verifiziert: `samba-tool user list` kennt ihn nicht"* --
geplant-aber-nie-angelegt oder Altlast, PW reserviert fuer SOCKS5/ZIH-Proxy-Bezug, danted auf
redshield :1080). **Der Wert gilt trotzdem ab sofort als kompromittiert.**

**Kein anderer Wert ist betroffen.** Alle uebrigen Zugriffe dieser Session liefen blind: PAT-Kandidaten
per `mapfile` in eine Variable, rueckwaerts gegen `/api/v4/user` getestet, nie ausgegeben; das lokale
`comdare`-Passwort per `printf | sudo -S` ueber stdin, nie als Argument, nie im Klartext geloggt.

## WAS ICH BITTE
1. **`samba-comdare-socks-pw` rotieren** oder -- falls das Konto wirklich nie angelegt wurde und auch
   nicht angelegt werden soll -- **den Eintrag aus dem Vault entfernen** statt einen toten Wert
   weiterzuschleppen.
2. **In die Rotationsliste / das Leak-Rotations-Register aufnehmen** (es gibt eines:
   `docs/sessions/2026-08-07-K133-LEAK-ROTATIONS-REGISTER-SSOT.md`).
3. **Nicht noetig:** ein Transkript-Scrub. Die Transkripte werden ohnehin nie committet
   (Doktrin: *"Session-Transkripte enthalten Live-Tokens, nie committen"*).

## DIE REGEL, DIE ICH DARAUS GEBUCHT HABE
Vault-Dateien werden **nie gegrept mit sichtbarer Ausgabe** -- auch nicht "maskiert". Jede
Maskierungs-Regex ist eine Annahme ueber ein Format, das man nicht kontrolliert, und der eine
Fehlversuch reicht. Nur noch blind:
```
mapfile -t P < <(grep -hoE '<muster>' <vault> | awk '!s[$0]++')   # nie ausgeben
echo "Kandidaten: ${#P[@]}"                                        # nur die ANZAHL
printf '%s\n' "${P[$i]}" | <konsument>                             # per stdin, nie als Argument
```
Und: **ueber die LAENGE selektieren, nicht ueber die Position.** Der Vault vermerkt `len:40` bei
Passwoertern; `awk 'length($0)==40'` ist robust, "der Teil nach dem `=`" nicht -- bei mir griff das
**6 Zeichen statt 40**, und der erste `sudo`-Test schlug deshalb fehl.
(Gebucht als Memory `reference_vault_dateien_nie_greppen_nur_blind_verarbeiten`.)

## NEBENBEI, weil es euch betrifft
Der Owner hat am 07.08. das lokale `comdare`-Passwort fuer prod1+prod2 ins Cluster-Repo committet
(`a3d653d`). **Damit funktioniert `sudo` auf prod1** -- die aeltere Notiz *"kein NOPASSWD, Login
schlug fehl"* ist ueberholt. Ich habe damit die NAS-Mounts verdrahtet (`/mnt/backup1-nfs`,
`/mnt/backup2-nfs`, `/mnt/comdare-buildsystem`), alle drei reboot-fest ueber `/etc/fstab` mit
`noauto,x-systemd.automount` -- **bewusst nicht hart**, weil ein schweigendes NAS sonst den Boot
blockiert und prod1 den GitLab-Runner traegt. Sicherung: `/etc/fstab.bak-20260807-comdare-nas`.
