# B14-NB3 -- Praeparate der Biss-Beweise

Diese Dateien sind ABSICHTLICH defekte Kopien der golden-XML bzw. kleine Kunst-Schemata. Sie
belegen die sechs Codex-Befunde am Objekt (Laeufe literal in `../gates/nb3-biss-beweise.txt`).

**Endung `.probe`, nicht `.xml`** -- damit kein jetziger oder kuenftiger Repo-weiter XML-Lauf
(Validierung, Zaehlung, Hash-Manifest) ueber sie stolpert. `b4.xml.probe` ist z.B. mit Absicht
nicht wohlgeformt. Zum Nachspielen die Endung abschneiden.

Basis aller `b*`/`gb*`-Praepate: die ECHTE `Code/test_data_xml/experiment_golden_kern.xml`
(validiert) plus GENAU EIN eingebauter Defekt -- deshalb kann ein rotes NEU nicht daran liegen,
dass die Datei ohnehin unvollstaendig waere.

| Datei | Befund |
|---|---|
| `b_nackt` / `gb_nackt` | KONTROLLE: Defekt unversteckt -- ALT und NEU beide rot |
| `b1a` / `gb1a` | 1a: `<![CDATA[` im TEXT eines gueltigen Kommentars |
| `b1b` / `gb1b` | 1b: `<!--` und `-->` verteilt auf zwei Processing-Instructions |
| `b2` / `gb2` | 2: Element von einer Entity in den Baum gestellt |
| `b3` | 3: Element-Name mit Nicht-ASCII-Startzeichen |
| `b4` | 4: Fehlverschachtelung + dupliziertes Attribut, Wurzel textuell geschlossen |
| `r5a_schema` + `r5a_instance` | 5a: gueltige XSD (Single-Quotes, `name=` an zweiter Stelle) -- ALT faelschlich ROT |
| `r5b_wrong_context` | 5b: Attribut im falschen Element-Kontext |
| `nb2_leer`, `b_nb2_cdata_trick`, `b_nb2_gt` | die NB2-Bisse, die nicht brechen duerfen |
| `b_cdata_text_ok` | Gegenprobe: CDATA-TEXT ist kein Markup -- beide gruen |
