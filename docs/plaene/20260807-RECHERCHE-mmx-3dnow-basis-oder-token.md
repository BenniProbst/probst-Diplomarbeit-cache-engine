# RECHERCHE: MMX/3DNow! — eigene Basis oder bloßes Token?

**Datum:** 07.08.2026 · **Auftrag:** Owner-Frage zur Versions-Grammatik v2, Fall (4)
**Gegenstand:** `mmx`, `mmxext`, `3dnow`, `3dnowext` (+ `3dnowprefetch` gesondert)
**Betroffene Stelle:** `libs/cache_engine/include/cache_engine/measurement/flag_grammar_catalog.hpp`
Z. 48–62 (Kopf, offener Entscheid), Z. 159 (`x64`), Z. 246–271 (die fünf Einträge),
Z. 533 (`static_assert(flag_catalog_offene_entscheide() == 6)`).
Alle fünf Worktree-Kopien des Katalogs sind byte-identisch (md5 `ea1a2f93…`, 660 Zeilen).

---

## DIE ANTWORT IN DREI SÄTZEN

**Eigene Basis.** Nach dem Owner-Kriterium — *gemeinsamer Registersatz mit zusammenhängender
Verarbeitung* — gehören MMX, MMXExt, 3DNow! und 3DNowExt zusammen, denn sie arbeiten alle vier auf
**demselben Registersatz MM0–MM7**, der bei AMD wie bei Intel auf den x87-Stack überlagert ist, und
AMD selbst fasst sie in seinem Handbuch zu **einer** von fünf Instruktionsgruppen zusammen —
*„64-bit media Instructions"* —, die *„composed of the MMX and 3DNow!™ instruction subsets"* ist und
*„subsequently expanded by the MMX and 3DNow! extensions subsets"*: das ist wörtlich dieselbe
Konstruktion wie AVX-512 (ein Block mit `F` als Fundament und Subsets darauf), nur eine
Registergeneration früher.

Die zusammenhängende Verarbeitung ist belegt und nicht bloß plausibel: Daten in MM-Registern lassen
sich ohne jeden Moduswechsel zwischen MMX- und 3DNow!-Befehlen weiterreichen, beide teilen sich das
x87-Tag-Wort, `EMMS` (MMX) und `FEMMS` (3DNow!) sind laut AMD *„identical"*, und 3DNow! besitzt
**keinen eigenen Lade- oder Speicherbefehl** — es kommt ohne die MMX-Befehle `MOVD`/`MOVQ` an seine
eigenen Daten weder heran noch aus ihnen heraus.

**Aber:** die Fundament-Beziehung ist, anders als bei AVX-512, in **CPUID nicht ausgesprochen** —
Intel sagt für `VL`/`BW`/`DQ` ausdrücklich „braucht `F`", AMD sagt für 3DNow! nirgends „braucht MMX";
das ist der eine Punkt, an dem die Analogie hinkt, und er steht unten unter *Was gegen meine Antwort
spricht* ausbuchstabiert.

**Zum Namen:** `x64` ist ein schlechter Name und führt in die Irre — er ist die Industrie-Bezeichnung
der **Architektur** x86-64, und in einem String, der mit `c` bereits „CPU" sagt, liest sich
`c.x64{…}` als „64-bit-CPU". Mein Vorschlag ist **`m64`** (AMDs eigener Gruppenname *„64-bit media"*,
zugleich der C-Typ `__m64` und die APM-Operandenschreibweise `mmx2/mem64`); die Begründung samt zwei
Alternativen steht unten.

---

## DAS OWNER-KRITERIUM, WIE ICH ES ANGEWANDT HABE

> „Gehört es zusammen → eigene Basis; gehört es separat → bloßes Token. Zum Beispiel ist AVX512 ein
> konzeptioneller Block, aber hat verschiedene zusammenhängende register-Erweiterungen für die
> Verarbeitung, wenn die Daten einmal dort sind."

Ich habe das in zwei prüfbare Fragen zerlegt und **beide** beantwortet, statt eine davon zu ersetzen:

1. **Ein Registersatz?** — Teilen sich die vier Token physisch dieselben Register, so wie `x512{f.vl.bw.dq}`
   sich ZMM teilt? → Ergebnis 1.
2. **Zusammenhängende Verarbeitung?** — Kann ein Befehl des einen Subsets weiterverarbeiten, was ein
   Befehl des anderen hinterlassen hat, *„wenn die Daten einmal dort sind"*? → Ergebnis 2.

Beides ist mit Ja beantwortet. Der Vollständigkeit halber habe ich die drei übrigen Fragen des
Auftrags (CPUID-Struktur, Fundament-Beziehung, Lebenszyklus) als **Gegenprobe** geführt: sie hätten
das Ergebnis kippen können und tun es an einer Stelle beinahe.

---

## ERGEBNIS 1 — DER REGISTERSATZ: **ein einziger, für alle vier**

**MMX (Intel-Ursprung).** Intel SDM Vol. 1, §9.2.2 *MMX Registers*, verbatim:

> „Although MMX registers are defined in the IA-32 architecture as separate registers, they are
> **aliased to the registers in the FPU data register stack (R0 through R7)**."

und §9.5 *Compatibility with x87 FPU Architecture*:

> „The MMX state is aliased to the x87 FPU state. **No new states or modes have been added** to IA-32
> architecture to support the MMX technology."

*(Quelle: Intel® 64 and IA-32 Architectures Software Developer's Manual, Volume 1, Dokument 253665,
selbst heruntergeladen von `cdrdv2-public.intel.com/782149/253665-sdm-vol-1.pdf` und im Volltext
gelesen — nicht aus einer Zusammenfassung.)*

**3DNow! (AMD).** AMD APM Vol. 1 (24592, Rev. 3.22, Dezember 2017), §1.1.3 *Instruction Set*, S. 4 —
und dies ist die Stelle, an der AMD die Frage direkt beantwortet, weil es **beide in einem Aufzählungspunkt
führt**:

> „**Multimedia Extension Instructions**—These include the MMX™ technology and AMD 3DNow!™ technology
> instructions. These instructions load, store, or operate on data located primarily in the **64-bit
> MMX registers which are mapped onto the 80-bit x87 floating-point registers**."

Dieselbe Quelle, Tabelle 1-2, Fußnote 4:

> „The **MMX0–MMX7 registers are mapped onto the FPR0–FPR7 physical registers**, as shown in
> Figure 1-1. The x87 stack registers, ST(0)–ST(7), are the logical mappings of the FPR0–FPR7 physical
> registers."

**MMXExt und 3DNowExt.** AMD APM Vol. 3 (24594, Rev. 3.28, September 2019), Anhang D, §D.1
*Instruction Set Overview*, Punkt 4 — die zentrale Belegstelle der ganzen Recherche:

> „**4. 64-bit media Instructions**
> These instructions are available at all privilege levels and perform vector operations on packed
> integer and floating-point values held in the 64-bit MMX™ registers. **The MMX register set overlays
> the FPR0–FPR7 physical registers. This group is composed of the MMX and 3DNow!™ instruction subsets
> and was subsequently expanded by the MMX and 3DNow! extensions subsets.**"

Damit ist die Frage für **alle vier** Token in **einem Satz** beantwortet, von AMD selbst. Es gibt
einen Registersatz, und die vier Token sind vier *subsets* darauf.

**Zum Vergleich, aus derselben Aufzählung, Punkt 5:**

> „**5. SSE instructions** — The SSE instructions operate on packed integer and floating-point values
> held in the **XMM / YMM registers**. SSE includes the original Streaming SIMD Extensions, all the
> subsequent named SSE subsets, and the AVX, XOP, and AES instructions."

Das ist der strukturelle Kern: die AMD64-ISA hat **fünf** Gruppen (General-Purpose, System, x87,
64-bit media, SSE). Unsere Basen `x128`, `x256`, `x512` liegen **alle drei in derselben Gruppe** (SSE)
und sind drei Sichten auf **dieselbe** Registerdatei (XMM ⊂ YMM ⊂ ZMM, Intel SDM Vol. 1 §15.5:
*„The lower 128 bits of a YMM register is aliased to the corresponding XMM register … The lower 256
bits of a ZMM register are aliased to the corresponding YMM register"*). Die MM-Register sind eine
**andere Datei in einer anderen Gruppe**. Sie sind kein vierter Breitengrad derselben Achse.

---

## ERGEBNIS 2 — DIE VERARBEITUNGS-BEZIEHUNG: **frei in beide Richtungen**

Der Owner fragt genau das Richtige: *„wenn die Daten einmal dort sind"*. Vier Belege:

**(a) Ein gemeinsamer Zustand, kein Moduswechsel.** APM Vol. 1, §5.2 *Compatibility*, S. 238:

> „**The MMX and 3DNow! instructions introduce no additional registers, status bits, or other processor
> state** to the legacy x86 architecture. Instead, they use the x87 floating-point registers that have
> long been a part of most x86 architectures. Because of this, 64-bit media procedures require no
> special operating-system support or exception handlers."

**(b) Ein gemeinsames Kapitel, weil ein gemeinsames Modell.** APM Vol. 1, Kapitel 5
*64-Bit Media Programming*, S. 237, erster Satz:

> „This chapter describes the 64-bit media programming model. This model includes **all instructions
> that access the MMX™ registers, including the MMX and 3DNow!™ instructions.**"

und §5.1 *Origins*, zur Herkunft von 3DNow!:

> „**3DNow!.** Added vector floating-point instructions, most of which take **vector operands in MMX
> registers** or memory locations."

**(c) Ein gemeinsames Aufräum-Protokoll.** APM Vol. 5 (26569, Rev. 3.15, Mai 2018), S. 17 (`EMMS`)
und S. 18 (`FEMMS`) — beide tragen wörtlich denselben Absatz:

> „Clears the MMX state by setting the state of the x87 stack registers to empty … Because the **MMX
> registers and tag word are shared with the x87 floating-point instructions**, software should execute
> an EMMS or FEMMS instruction to clear the MMX state …"

und, entscheidend:

> „**The functions of the FEMMS and EMMS instructions are identical.**" — wobei `EMMS` laut derselben
> Seite *„an MMX™ instruction"* ist und `FEMMS` *„a 3DNow! instruction"*.

Zwei Subsets, **ein** Zustandsbegriff („the MMX state"), zwei austauschbare Befehle dafür. Das ist
keine Nachbarschaft, das ist Identität des Zustands.

**(d) Die härteste Form: 3DNow! kann seine Daten ohne MMX weder holen noch abliefern.**
APM Vol. 3, Anhang D, Tabelle D-2 (*Instruction Subsets and CPUID Feature Flags*) führt für jeden
Befehl das nötige Feature-Flag getrennt nach 128-bit-Form und MM-Register-Form. Dort steht:

| Befehl | Beschreibung | Feature (MM-Register-Form) |
|---|---|---|
| `MOVD` | Move Doubleword or Quadword | **MMX** |
| `MOVQ` | Move Quadword | **MMX** |
| `MASKMOVQ` | Masked Move Quadword | SSE ‖ MmxExt |
| `PAVGB` | Packed Average Unsigned Bytes | SSE ‖ MmxExt |
| `PAVGUSB` | Packed Average Unsigned Bytes | 3DNow |

Das 3DNow!-Subset (`FEMMS`, `PAVGUSB`, `PF*`, `PI2F*`, `PMULHRW`, `PREFETCH`/`PREFETCHW`) enthält
**keinen einzigen Transferbefehl** zwischen MM-Register und GPR oder Speicher. Der einzige Weg in ein
MM-Register hinein und aus ihm heraus sind `MOVD`/`MOVQ` — und die sind MMX-gegatet. **3DNow! ohne
MMX ist ein Rechenwerk ohne Türen.** Das ist funktional exakt die Lage von `AVX512VL` ohne `AVX512F`.

---

## ERGEBNIS 3 — DIE CPUID-STRUKTUR: **vier getrennte Bits, drei davon AMD-exklusiv**

Alle vier Bits, verbatim aus APM Vol. 5, Kapitel 1, S. 2 — man beachte den **Rahmensatz**, der die
drei anderen als *Erweiterungen des MMX-Befehlssatzes* einordnet:

> „**Hardware support of the MMX instruction set and specific optional extensions** can be determined by
> testing specific bits of the value returned in EDX by the CPUID instruction. …
> • MMX Instructions, indicated by **EDX[23]** returned by CPUID function **0000_0001h and function
>   8000_0001h**.
> • AMD Extensions to MMX Instructions, indicated by **EDX[22]** of CPUID function **8000_0001h**.
> • AMD 3DNow! Instructions, indicated by **EDX[31]** of CPUID function **8000_0001h**.
> • AMD Extensions to 3DNow! Instructions, indicated by **EDX[30]** of CPUID function **8000_0001h**."

Identisch, unabhängig bestätigt in APM Vol. 1, §5.10 *Feature Detection*, und tabellarisch in
APM Vol. 3, Anhang D, Tabelle D-1 *Feature Flags for Instruction / Instruction Subset Support*:

| Feature Flag | Instruction or Subset | CPUID Function | Bit Position |
|---|---|---|---|
| `MMX` | MMX | **both** (Standard **und** Extended) | EDX[23] |
| `3DNow` | 3DNow! | extended | EDX[31] |
| `MmxExt` | MMX Extensions | extended | EDX[22] |
| `3DNowExt` | 3DNow! Extensions | extended | EDX[30] |
| `3DNowPrefetch` | PREFETCH / PREFETCHW | extended | **ECX[8]** |

**Intel vs. AMD, klar getrennt:**
- `MMX` ist das einzige Bit der Familie in Intels **Standard**-Blatt `0000_0001h`; Intel SDM Vol. 1
  §9.6.1 nennt es `CPUID.01H:EDX.MMX[bit 23]`. Es ist ein Intel-definiertes Bit, das AMD zusätzlich im
  eigenen Blatt spiegelt.
- `MmxExt`, `3DNow`, `3DNowExt` liegen ausschließlich im **AMD-Blatt** `8000_0001h`. **Intel
  dokumentiert 3DNow! überhaupt nicht** — im gesamten SDM Vol. 1 kommt der Begriff nicht vor. Das ist
  keine Lücke meiner Suche, sondern der Sachverhalt: 3DNow! ist eine AMD-Erweiterung, die Intel nie
  implementiert hat.
- `3DNowPrefetch` liegt als einziges in **ECX**, nicht in EDX — schon die Registerlage trennt es ab.

**Der Linux-Kernel führt genau diese fünf und nur diese fünf** (`arch/x86/include/asm/cpufeatures.h`,
aktueller Torvalds-Master):

```
#define X86_FEATURE_MMX            ( 0*32+23) /* "mmx" Multimedia Extensions */
#define X86_FEATURE_MMXEXT         ( 1*32+22) /* "mmxext" AMD MMX extensions */
#define X86_FEATURE_3DNOWEXT       ( 1*32+30) /* "3dnowext" AMD 3DNow extensions */
#define X86_FEATURE_3DNOW          ( 1*32+31) /* "3dnow" 3DNow */
#define X86_FEATURE_3DNOWPREFETCH  ( 6*32+ 8) /* "3dnowprefetch" 3DNow prefetch */
```

Word 0 = `CPUID.0000_0001h:EDX`, Word 1 = `CPUID.8000_0001h:EDX`, Word 6 = `CPUID.8000_0001h:ECX` —
die Bitpositionen decken sich Zug um Zug mit AMDs Tabelle D-1. **Die cpuinfo-Spalte des Katalogs
stimmt für alle fünf Einträge.**

---

## ERGEBNIS 4 — DIE FUNDAMENT-BEZIEHUNG: **ja funktional, nein per CPUID**

Der Owner zieht den AVX-512-Vergleich selbst. Ich habe ihn beidseitig geprüft.

**Wie AVX-512 es macht.** Intel SDM Vol. 1, Kapitel 15, Tabelle 15-2 *Feature flag Collection Required
of 256/128 Bit Vector Lengths for Each Instruction Group* — die Abhängigkeit ist **ausgesprochen**:

| Usage | Feature Flag Collection to Verify |
|---|---|
| AVX512F | AVX512F & AVX512VL |
| AVX512CD | **AVX512F** & AVX512CD & AVX512VL |
| AVX512DQ | **AVX512F** & AVX512DQ & AVX512VL |
| AVX512BW | **AVX512F** & AVX512BW & AVX512VL |

`F` steht in jeder Zeile. Das ist die Fundament-Beziehung, schriftlich.

**Wie MMX/3DNow! es macht.** Eine solche Zeile gibt es bei AMD **nicht**. Kein AMD-Dokument, das ich
gelesen habe, sagt „3DNow! requires MMX". Formal sind es vier voneinander unabhängige optionale
Subsets; APM Vol. 3, Anhang D, Einleitung sagt sogar ausdrücklich:

> „**support for each added instruction or instruction subset is optional** and must be confirmed by
> testing the corresponding feature flag."

**Die Beziehung existiert trotzdem — sie ist nur in die ISA-Komposition eingebaut statt
aufgeschrieben.** Zwei Belege:

*(a) Die ISA selbst* — Ergebnis 2(d): kein 3DNow!-Transferbefehl, `MOVD`/`MOVQ` sind MMX.

*(b) Die Werkzeugkette macht daraus eine harte Implikation.* Selbst gemessen, heute, gcc 15.3.0 auf
dieser Maschine (Ergebnis kopiert, nicht paraphrasiert):

```
$ gcc -m3dnow  -dM -E -x c /dev/null | grep -E '__MMX__|__3dNOW__'
#define __MMX__ 1
#define __3dNOW__ 1

$ gcc -m3dnowa -dM -E -x c /dev/null | grep -E '__MMX__|__3dNOW__|__3dNOW_A__'
#define __MMX__ 1
#define __3dNOW__ 1
#define __3dNOW_A__ 1

$ gcc -m3dnow -mno-mmx -dM -E -x c /dev/null | grep -E '__MMX__|__3dNOW__'
        (leer -- BEIDE aus)
```

und die Gegenprobe mit AVX-512, dieselbe Mechanik, dasselbe Ergebnis:

```
$ gcc -mavx512vl              -dM -E -x c /dev/null | grep -E '__AVX512(F|VL)__'
#define __AVX512F__ 1
#define __AVX512VL__ 1

$ gcc -mavx512vl -mno-avx512f -dM -E -x c /dev/null | grep -E '__AVX512(F|VL)__'
        (leer -- BEIDE aus)
```

**`3dnow` verhält sich zu `mmx` wie `avx512vl` zu `avx512f`: das Abschalten des Fundaments schaltet
das Subset mit ab.** Das ist die stärkste einzelne Beobachtung dieser Recherche, weil sie den
Owner-Vergleich nicht nur analog macht, sondern in derselben Werkzeugkette **mechanisch identisch**.

Und die Kette geht eine Stufe weiter: `-m3dnowa` ⇒ `-m3dnow` ⇒ `-mmmx`. Auch das entspricht
AVX-512, wo `VL` auf `F` aufsetzt.

---

## ERGEBNIS 5 — DER LEBENSZYKLUS: **die Familie zerfällt, aber nicht entlang der Registergrenze**

**Was AMD sagt.** APM Vol. 5, Revisionshistorie, Rev. 3.08:

> „Added misaligned access support to applicable instructions. **Deprecated 3DNow!™ instructions.**
> Added Appendix A, ‚Recommended Substitutions for 3DNow!™ Instructions,' on page 337."

Der Satz steht seither auf **22** Instruktionsseiten des Bandes, immer wörtlich gleich:

> „**AMD no longer recommends the use of 3DNow! instructions**, which have been superceded by their
> more efficient 128-bit media counterparts."

Anhang A, S. 337: *„Table A-1 lists the **deprecated 3DNow!™ instructions** and the recommended
substitutions."* Die Tabelle listet **25 Befehle** (gezählt), darunter ausdrücklich auch die
3DNowExt-Befehle `PF2IW`, `PFNACC`, `PFPNACC`, `PI2FW`, `PSWAPD`. Sie listet **`PREFETCH` und
`PREFETCHW` nicht** — die beiden überleben.

Derselbe Satz steht in APM Vol. 1, §5.2, S. 238 — mitten im MMX-Kapitel, aber **ausschließlich über
3DNow!**. **Für MMX gibt es keinen entsprechenden Satz in irgendeinem der drei Bände.** Die Deprecation
trifft eines der vier Subsets, nicht die Gruppe.

**Was die Hardware sagt.** Gemessen auf dieser Maschine (AMD Ryzen 9 9950X3D, Zen 5), `/proc/cpuinfo`,
32 logische Kerne, Zählung pro Flag über alle Kern-Blöcke:

| Flag | Vorkommen |
|---|---|
| `mmx` | **32** (auf jedem Kern) |
| `mmxext` | **32** |
| `3dnowprefetch` | **32** |
| `3dnow` | **0** |
| `3dnowext` | **0** |

Und `gcc -march=native -dM` liefert auf derselben Maschine `__MMX__` und `__PRFCHW__`, aber **kein**
`__3dNOW__`.

**Was daraus folgt — und was nicht.** Der Owner fragt: *„Wenn eines stirbt und das andere nicht — sind
sie dann eine Einheit?"* Die ehrliche Antwort: der Schnitt des Sterbens verläuft **quer** zur
Registergrenze, nicht entlang. Gestorben sind `3dnow` und `3dnowext`; am Leben sind `mmx` und
`mmxext` — und zwar **beide auf denselben MM-Registern**. Die Registerdatei ist nicht gestorben; ein
Subset darauf ist gestorben. Genau dasselbe ist innerhalb von AVX-512 passiert: `AVX512ER` und
`AVX512PF` (Knights Landing) sind tot, `AVX512F` lebt, **und niemand käme auf die Idee, deshalb den
`x512`-Block aufzulösen**. Der Katalog selbst führt `er` und `pf` bereits als Reserve-Einträge
(`FlagReserveGrund::NichtBaubar`, Z. 308–309) — die Basis blieb trotzdem.

Der Lebenszyklus widerlegt die Einheit also nicht. Er belegt aber, dass die Klammer dieser Basis
dauerhaft nur zur Hälfte füllbar sein wird. Das ist ein Preis, kein Gegenbeweis.

**Sekundärquelle zur Abkündigung**, nachrangig und als solche markiert: bit-tech (2010) berichtet die
Abkündigung nach zwölf Jahren und nennt *„a pair of instructions originally developed for 3DNow!:
PREFETCH and PREFETCHW"* als das einzig Fortbestehende. Die AMD-Originalmitteilung von August 2010 ist
nicht mehr online; ich stütze die Aussage deshalb primär auf die APM-Deprecation und auf die
CPUID-Messung oben, nicht auf die Presse.

---

## `3dnowprefetch` — die Einordnung als Skalar ist richtig, und jetzt besser belegt

Der Katalog trägt `3dnowprefetch` als `Skalar` mit dem Vermerk, das sei eine Setzung des Autors
(Z. 246–254). Die Setzung hält, und es gibt einen härteren Beleg als den dort genannten.
APM Vol. 3, `PREFETCHW`, S. 276:

> „Support for the PREFETCH and PREFETCHW instructions is indicated by CPUID
> **Fn8000_0001_ECX[3DNowPrefetch] OR Fn8000_0001_EDX[LM] OR Fn8000_0001_EDX[3DNow] = 1**."

Drei Dinge folgen daraus:

1. Die Verfügbarkeit ist **durch Long Mode impliziert**. Auf jeder x86-64-CPU sind `PREFETCH`/`PREFETCHW`
   vorhanden, unabhängig von 3DNow!. Das Token ist damit nicht 3DNow!-Rest, sondern
   x86-64-Grundausstattung.
2. Das Bit liegt in **ECX**, alle vier Familienbits in **EDX**. Schon die Registerlage trennt.
3. Der Befehl fasst **kein Register** an, weder MM noch XMM — er nimmt eine Speicheradresse.

**Empfehlung: `3dnowprefetch` bleibt auf Tiefe 0 und kommt in *keine* Klammer.** Wenn die Basis kommt,
muss der `static_assert` von 6 auf **5** offene Entscheide fallen (die vier Familieneinträge verlieren
ihr `eltern_alternativ` und bekommen die Basis als `eltern`; der Basis-Eintrag selbst verliert
`entscheid_offen`; `3dnowprefetch` verliert es ebenfalls, weil diese Recherche die Setzung belegt) —
faktisch also **auf 0**, wenn der Owner beide Punkte zugleich entscheidet.

---

## DER VORSCHLAG FÜR DIE SCHREIBWEISE

### `x64` ist ein schlechter Name. Drei Gründe.

1. **Es ist der Name der Architektur, nicht der Register.** „x64" ist die verbreitete Industrie-Bezeichnung
   für x86-64/AMD64 — Microsoft führt sie offiziell so. In einem String, der mit `c` bereits „CPU"
   sagt, liest `c.x64{mmx}` sich als *„CPU, 64-bit"*, nicht als *„MM-Registerdatei"*. Das ist keine
   Geschmacksfrage: das Preimage wird später von Menschen gelesen, und ein Name, der im selben Feld
   etwas anderes bedeutet als er meint, ist eine Falle.
2. **Die Zahl 64 ist in diesem Projekt bereits mit Bitbreite belegt.** Die Reserve-Tabelle desselben
   Katalogs vermerkt `-mapxf` als *„NUR -m64"* (Z. 301) — dort meint 64 die Adressbreite. Zwei
   Bedeutungen von „64" in einer Datei.
3. **Das `x`-Präfix behauptet eine Achse, die es nicht gibt.** `x128`/`x256`/`x512` sind drei Breiten
   **einer** Registerdatei (XMM ⊂ YMM ⊂ ZMM) in **einer** AMD-Instruktionsgruppe (SSE). Die MM-Register
   sind eine **andere** Datei in einer **anderen** Gruppe. `x64` in dieselbe Reihe zu stellen suggeriert
   „vierter, kleinster Breitengrad derselben Achse" — und genau das ist die Aussage, die diese
   Recherche widerlegt. Der Katalog weiß das schon: sein `FlagTokenKind::BasislosFamilie` heißt so,
   weil die Familie unter keiner Breiten-Basis steht.

### Empfehlung: **`m64`**

```
1.0.0.c.m64{mmx.mmxext}.3dnowprefetch
1.0.0.c.m64{mmx.mmxext.3dnow.3dnowext}          (Vollausbau-Beweis)
1.0.0.c.m64{mmx}.x128{sse.sse2.sse41}.popcnt    (gemischt)
```

Warum `m64`:

- Es ist **AMDs eigener Gruppenname**: *„64-bit media Instructions"* (APM Vol. 3, §D.1 Punkt 4).
  Der Katalog würde damit die Gruppenbezeichnung der Primärquelle tragen statt einer erfundenen.
- Es kollidiert mit nichts: „m64" ist kein Architekturname.
- Es ist im selben Vokabular schon da: der C-Typ heißt `__m64`, die APM-Operandenschreibweise
  `mmx2/mem64`, GCCs Header `mm3dnow.h` und `mmintrin.h`.
- Der **andere Anfangsbuchstabe ist ein Merkmal, kein Makel**: er signalisiert genau das, was hier
  wahr ist — andere Gruppe, nicht bloß andere Breite. Die Grammatik führt ohnehin heterogene Präfixe
  (`c`, `g`, `f`, `n`, `p`, `e`, `x128`…), ein weiterer bricht kein Muster.

### Alternativen, falls `m64` nicht gefällt

| Name | Beispiel | Für | Gegen |
|---|---|---|---|
| **`mm`** | `c.mm{mmx.3dnow}` | benennt die Registerdatei direkt (MM0–MM7), maximal eindeutig | verliert die Breitenangabe ganz; `mm{mmx}` stottert |
| **`x64mm`** | `c.x64mm{mmx}` | behält das Breitenmuster *und* disambiguiert | sperrig, fünf Zeichen für eine tote Familie |
| **`x64`** (heute) | `c.x64{mmx}` | Muster-treu, schon gebaut | liest sich als Architektur — s. o. |

### Struktur-Folge, die der Owner mitentscheiden sollte

Wenn die Basis kommt, ist `FlagTokenKind::BreitenBasis` für sie **die falsche Sorte** (heute Z. 159).
Die Recherche sagt: sie ist keine Breite auf der SSE-Achse. Sauber wäre ein eigener `kind`, etwa
`MedienBasis` — dann sagt das Typsystem selbst, was hier gefunden wurde, und `BasislosFamilie` für die
vier Kinder wird zu `MedienSubset`. Das ist eine Bau-Entscheidung, keine Hardware-Aussage; ich schlage
sie vor, treffe sie nicht.

---

## WAS GEGEN MEINE EIGENE ANTWORT SPRICHT

Ich führe das ernsthaft, nicht pro forma. Es gibt vier Einwände, und einer davon ist stark.

**1. (STARK) CPUID kennt keine Implikation — AVX-512 schon.**
Das ist der eine Punkt, an dem der Owner-Vergleich nicht trägt. Intel schreibt für AVX-512
buchstäblich hin, dass `VL`/`BW`/`DQ` ohne `F` nicht zu verwenden sind (Tabelle 15-2). AMD schreibt
für 3DNow! **nichts** dergleichen; im Gegenteil, Anhang D sagt ausdrücklich, jedes Subset sei
*„optional"* und einzeln zu prüfen. Ein Prozessor, der `EDX[31]` ohne `EDX[23]` meldet, wäre nach dem
Buchstaben der Spezifikation **nicht regelwidrig** — er wäre nur unbrauchbar, weil man seine Register
nicht laden kann. Wer die Basis-Entscheidung ausschließlich an einer *formalen* Fundament-Beziehung
festmacht, kommt zu „bloßes Token". Ich halte das für die schwächere Lesart, weil das Owner-Kriterium
nach *Registersatz und Verarbeitung* fragt und nicht nach CPUID-Implikationen — aber die Lesart
existiert und ist nicht albern.

**2. (MITTEL) Verschiedene Hersteller, verschiedene Handbücher, verschiedene Jahrzehnte.**
MMX ist Intel (1997), 3DNow! ist AMD (1998). Intel dokumentiert 3DNow! **nirgends**. Der einzige Ort,
an dem beide zusammen in einem Absatz stehen, ist das AMD-Handbuch — und AMD hat ein Interesse daran,
seine Erweiterung als Fortsetzung des Etablierten darzustellen. Wer nur das Intel-SDM liest, sieht
`x512`-artige Blockstruktur bei AVX-512 und bei MMX **gar nichts**, weil dort nur ein einzelnes
Feature steht. Gegenrede: das Silizium schert sich nicht um Handbuchgrenzen, und die MM-Register sind
physisch dieselben. Aber die Asymmetrie der Quellenlage ist real und ich nenne sie.

**3. (MITTEL) `mmxext` ist eigentlich mit SSE verwandt, nicht mit 3DNow!.**
APM Tabelle D-2 gattet `PAVGB`, `PAVGW`, `MASKMOVQ` u. a. auf **„SSE ‖ MmxExt"** — dieselben Befehle
kamen bei Intel mit SSE1 und bei AMD als „MMX-Erweiterungen". `MmxExt` korreliert also mit SSE, nicht
mit 3DNow!. Wer die Familie nach *Verwandtschaft der Einführung* schneidet statt nach Register, landet
bei einer anderen Gruppierung. Gegenrede: das Kriterium des Owners ist der Registersatz, und `PAVGB`
in der `mm`-Form rechnet auf MM-Registern — es gehört dorthin. Aber es zeigt, dass die Familie
**innen nicht monolithisch** ist, und wer eine saubere Blockstruktur wie bei AVX-512 erwartet, findet
hier eine unordentlichere.

**4. (SCHWACH) Halbtote Klammer.**
`m64{…}` kann auf keiner heute kaufbaren CPU mehr als `{mmx.mmxext}` enthalten. Eine Basis, deren
Wertebereich zur Hälfte historisch ist, wirkt überdimensioniert. Gegenrede oben in Ergebnis 5:
`x512` hat mit `er`/`pf` genau dasselbe Problem und behält seine Basis. Ich halte den Einwand für
entkräftet, notiere ihn aber, weil er als erstes kommt, wenn jemand die Notation zum ersten Mal sieht.

---

## WO ICH UNSICHER BIN

1. **Ich habe die aktuellste Revision von APM Vol. 5 nicht gelesen.** Gelesen habe ich Rev. 3.15
   (Mai 2018, Volltext) und Rev. 3.13 (Mai 2013, PDF). Die neueste ist laut Dritt-Meldung Rev. 3.16
   (November 2021); AMDs heutige Download-URL für 26569 liefert eine 404-HTML-Seite, und die
   erreichbaren Spiegel führen 3.13/3.15. Ich halte eine inhaltliche Änderung an §D.1 oder am
   Kapitel-1-Kopf für **unwahrscheinlich** (es sind Definitionssätze, keine Feature-Listen), habe es
   aber **nicht verifiziert**. Falls das Gewicht dieser Entscheidung es rechtfertigt, ist das der eine
   nachzuholende Handgriff.
2. **Ich habe das 3DNow!-Technologiehandbuch (21928) und „AMD Extensions to the 3DNow! and MMX
   Instruction Sets" nicht im Volltext lesen können.** Beide PDFs sind heruntergeladen, aber
   CID-font-kodiert; auf dieser Maschine fehlt `poppler-utils`, und mein eigener Extraktor scheitert
   an ihnen. Sie hätten die *historische* Absicht von 1998/2000 belegen können. Alle inhaltlichen
   Aussagen oben stammen deshalb aus den **aktuellen** APM-Bänden 1, 3 und 5 und aus dem Intel-SDM —
   was für eine Aussage über die geltende Architektur die bessere Quelle ist, für eine Aussage über
   die Entstehungsabsicht die schlechtere.
3. **Ob je eine CPU 3DNow! ohne MMX gemeldet hat, weiß ich nicht.** Ich halte es für ausgeschlossen
   (K6-2, Athlon, WinChip 2 hatten alle beides), habe es aber nicht Modell für Modell nachgewiesen.
   Für die Entscheidung ist es ohne Belang: die Frage ist, ob die Notation es *darstellen können muss*,
   und `m64{3dnow}` ohne `mmx` ist in der Klammerform genauso schreibbar wie `x512{vl}` ohne `f`.
4. **Ich habe nur diese eine Maschine gemessen** (Ryzen 9 9950X3D). Die Aussage „`mmx`/`mmxext` leben,
   `3dnow`/`3dnowext` sind tot" ist damit für **eine** Zen-5-CPU belegt und für die Intel-Hälfte des
   Messparks nur über die x86-64-Grundlinie (`gcc -march=x86-64` setzt `__MMX__`) erschlossen, nicht
   gemessen. Für `3dnow` auf Intel ist die Sache ohnehin eindeutig — Intel hat es nie gehabt.

---

## NEBENBEFUNDE FÜR DEN KATALOG (nicht gefragt, aber belegt)

Diese drei Punkte sind mir bei der Lektüre aufgefallen. Sie hängen **nicht** am Basis-Entscheid und
gelten unabhängig davon, wie er ausfällt.

**N-1 — `{"mmxext", …, "-m3dnowa", …}` (Z. 266) ist vermutlich falsch zugeordnet.**
Der Kommentar Z. 268–270 begründet das mit *„GCC schaltet mit ‚Enhanced 3DNow!' beides zugleich"*.
Gemessen stimmt das nicht:
- `gcc -m3dnowa -dM` setzt `__MMX__`, `__3dNOW__`, `__3dNOW_A__` — **kein** mmxext-Makro; ein solches
  Makro existiert in GCC gar nicht.
- `gcc -mmmxext` ⇒ `error: unrecognized command-line option '-mmmxext'; did you mean '-mmmx'?`
  Es gibt **keinen** GCC-Schalter für MmxExt.
- Die MmxExt-Intrinsics stehen in `xmmintrin.h` unter `#pragma GCC push_options` / `target("sse")`
  (Z. 65/66) bis `pop_options` (Z. 1368) — `_mm_avg_pu8` (= `PAVGB`) liegt auf Z. 1288, also
  **innerhalb des sse-Gates**. `mm3dnow.h` dagegen trägt `target("3dnow")` (Z. 34–185) und
  `target("3dnowa")` (Z. 189–230) und enthält die `PF*`-Intrinsics.
- AMDs Tabelle D-2 gattet `PAVGB` konsequent auf **„SSE ‖ MmxExt"**.

⇒ `-m3dnowa` ist der Schalter für **3DNowExt**, nicht für MmxExt. Ehrlich wäre für `mmxext` entweder
`gpp == ""` (kein eigener Schalter — der Katalog hat diese Bedeutung bereits dokumentiert, Z. 123)
oder `"-msse"`. *Historische Fairness:* AMDs Marketingname „Enhanced 3DNow!" (Athlon, 1999) bündelte
MmxExt **und** 3DNowExt, insofern ist die Zuordnung nicht aus der Luft gegriffen — CPUID und GCC
trennen sie aber, und der Katalog folgt CPUID.

**N-2 — „auf keiner erreichbaren Maschine wahr" (Z. 262) trifft für `mmx`/`mmxext` nicht zu.**
Beide stehen 32× in `/proc/cpuinfo` dieser Maschine. Falsch ist die Aussage nur für die Hälfte der
Familie; für `3dnow`/`3dnowext` stimmt sie (0 Vorkommen). **Konsequenz, die der Owner sehen sollte:**
`mmx` ist Teil der x86-64-Grundlinie — `gcc -march=x86-64 -dM` setzt `__MMX__`. Wenn `mmx` in den
Produktivkatalog kommt, ist es auf **jeder** gebauten Binary wahr und stünde damit in **jedem**
Preimage. Ob das gewollt ist (Vollständigkeit) oder nicht (Rauschen), ist eine Notations-Entscheidung
und keine Hardware-Frage — sie sollte aber zusammen mit dem Basis-Entscheid fallen, nicht danach.

**N-3 — `3dnowprefetch` ist besser belegt als der Katalog weiß.** Siehe eigener Abschnitt oben:
`ECX[3DNowPrefetch] OR EDX[LM] OR EDX[3DNow]`. Der Eintrag kann sein `entscheid_offen` verlieren.

---

## QUELLENVERZEICHNIS

**Primär — AMD (alle im Volltext gelesen, nicht über Zusammenfassungen):**
- AMD64 Architecture Programmer's Manual **Vol. 1: Application Programming**, 24592, **Rev. 3.22,
  Dezember 2017** — §1.1.3 (S. 4), Tab. 1-2 Fn. 4, Kap. 5 (S. 237 ff.), §5.1, §5.2 (S. 238), §5.10.
  <https://archive.org/details/advancedmicrodevices_24592_3.22>
- AMD64 APM **Vol. 3: General-Purpose and System Instructions**, 24594, **Rev. 3.28, September 2019**
  — `PREFETCHW` (S. 276), Anhang D §D.1/§D.2, Tab. D-1, Tab. D-2.
  <https://archive.org/details/advancedmicrodevices_24594_3.28>
- AMD64 APM **Vol. 5: 64-Bit Media and x87 Floating-Point Instructions**, 26569, **Rev. 3.15, Mai 2018**
  — Vorwort, Kap. 1 (S. 1–2), `EMMS` (S. 17), `FEMMS` (S. 18), Revisionshistorie Rev. 3.08,
  Anhang A + Tab. A-1 (S. 337 f.). <https://archive.org/details/advancedmicrodevices_26569_3.15>
  · Gegenkopie Rev. 3.13: <https://kib.kiev.ua/x86docs/AMD/AMD64/26569_APM_v5-r3.13.pdf>

**Primär — Intel:**
- Intel® 64 and IA-32 Architectures Software Developer's Manual, **Vol. 1**, Dok. 253665 — §9.2.2,
  §9.4.8, §9.5, §9.5.1, §9.6.1, §9.6.2, Kap. 15 (§15.2, Tab. 15-2, §15.5).
  <https://cdrdv2-public.intel.com/782149/253665-sdm-vol-1.pdf>

**Primär — Quelltext und Messung (auf dieser Maschine, 07.08.2026):**
- Linux `arch/x86/include/asm/cpufeatures.h` (Torvalds-Master).
  <https://raw.githubusercontent.com/torvalds/linux/master/arch/x86/include/asm/cpufeatures.h>
- gcc 15.3.0, `/opt/gcc-15.3/lib/gcc/x86_64-pc-linux-gnu/15.3.0/include/{xmmintrin.h,mmintrin.h,mm3dnow.h}`
- `/proc/cpuinfo`, AMD Ryzen 9 9950X3D, 32 logische Kerne
- Präprozessor-Messungen `-dM -E` mit `-m3dnow`, `-m3dnowa`, `-mmmx`, `-m3dnow -mno-mmx`,
  `-mavx512vl`, `-mavx512vl -mno-avx512f`, `-march=x86-64`, `-march=native`, `-mmmxext`

**Sekundär (als solche markiert, tragen keine Kernaussage):**
- bit-tech, „AMD retires 3DNow!" (2010) — <https://www.bit-tech.net/news/tech/cpus/amd-retires-3dnow/1/>
- InstLatX64 zur Revisionslage der APM-Bände (Vol. 5 = Rev. 3.16, November 2021)

**Nicht gelesen, obwohl heruntergeladen** (CID-Fonts, `poppler-utils` fehlt auf dieser Maschine):
AMD *3DNow!™ Technology Manual* (21928, von amd.com) · AMD *Extensions to the 3DNow!™ and MMX™
Instruction Sets* (von `refspecs.linuxfoundation.org/AMD-extensions.pdf`; Publikationsnummer nicht
verifiziert) · AMD *CPUID Specification* (25481). Keine Aussage oben stützt sich auf sie.

<!-- Selbstcheck: Alle verbatim-Zitate stammen aus im Volltext geoeffneten Quellen; alle Messwerte
     wurden auf dieser Maschine erzeugt und sind mit Kommandozeile wiedergegeben; die Gegenrede-
     Abschnitte nennen den einen Punkt (CPUID-Implikation), an dem die Quellen dem Ergebnis
     widersprechen, statt ihn zu glaetten. -->
