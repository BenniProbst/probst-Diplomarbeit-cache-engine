---
name: reference_buildsystem_xml_grep_parsed_not_strict_xml
description: "cd-buildsystem buildsystem.xml-Manifeste werden von einem grep/awk-Parser gelesen (literaler Content), NICHT von einem strikten XML-Parser. `&`/`&&`/`<`/`>` in Element-Content (z.B. <bootstrap>cd src && ./make.bash</bootstrap>) NIEMALS zu &amp;/&lt; escapen — das bricht den Parser (führt `&amp;&amp;` literal aus). Die 'nicht-wohlgeformte' XML ist BEWUSST."
metadata:
  node_type: memory
  type: reference
  originSessionId: c6f15797-7fa1-4e66-874f-55631afe1d28
---

**Gotcha (Selbst-Catch 2026-07-04):** Beim T-03-Fix wollte ich `buildsystem.xml` strikt-XML-valide machen (python `xml.dom.minidom` scheiterte an `<bootstrap method="shell">cd src && ./make.bash</bootstrap>` Z.446, unescaptes `&&`). Ich escapte `&&`→`&amp;&amp;` — **falsch**: der Buildsystem-Manifest-Parser ist **grep/awk-basiert** (die POSIX-Parser-Arbeit an `xml_parser.sh`/`dependency_resolver.sh`), liest **literalen** Content und entschlüsselt KEINE XML-Entities. Der escapte Shell-Befehl würde `cd src &amp;&amp; ./make.bash` literal ausführen → Bruch. Sofort revertiert (`git checkout`).

**Regel:** In `buildsystem.xml` (v3.4.15-Manifeste) Element-Content **literal lassen** — kein `&`→`&amp;`, kein `<`→`&lt;`. Strikte XML-Wohlgeformtheit ist **kein Ziel** (der grep-Parser braucht sie nicht). Falls je ein Schema-Validierungsschritt (T-57) kommt, muss ER den grep-Dialekt tolerieren, nicht das Manifest strikt-XML gezwungen werden.

**Was BEI T-03 korrekt war:** Element-**Namen/Werte** angleichen (tote `cmakePackage>BEPBuildSystem` + nicht-existente `<module>`-Refs → reale `ComdareBuildSystem.cmake`/`BuildSystemMaster.cmake`/`BuildSystemCore.cmake`) — das ist Content-Korrektur, kein Entity-Escaping. Verwandt: [[reference_buildsystem_scripts_posix_no_grep_p]] (derselbe grep-basierte Parser-Kontext).
