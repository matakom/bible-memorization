Databázový scénář pro mobilní aplikaci, která pomáhá uživatelům zapamatovat si biblické verše zpaměti.

# Hlavní entity a jejich atributy

### Uživatel

Unikátní ID, Jméno, Příjmení, e-mail, Denní řada, Jazyk prostředí, Theme aplikace, Datum registrace, Poslední přihlášení

### Uložený verš

Unikátní ID, ID uživatele, Kniha, Kapitola, Verš, Překlad Bible, Datum dalšího procvičení, Datum posledního procvičení, Obtížnost verše

### Procvičení

Unikátní ID, ID uživatele, ID verše, Čas strávený procvičováním, Timestamp, Úspěšnost, Typ cvičení

### Přátelství

Unikátní ID, Stav, ID uživatele, ID přítele, Datum vytvoření

# Hlavní vztahy mezi entitami

Uložený verš je přiřazený pouze jednomu uživateli.

Procvičení je přiřazeno jednomu uživateli a zároveň jednomu uloženému verši.

Přátelství existuje mezi dvěma různými uživately.

# Příklad struktury tabulky

| Tabulka | Atributy | Vztahy |
| --- | --- | --- |
| Uživatel | ID, jmeno, prijmeni, e-mail, denni_rada, jazyk, tema, datum_registrace, datum_posledni_prihlaseni |  |
| Uložený verš | ID, id_uzivatele, kniha, kapitola, vers, preklad, datum_dalsiho_procviceni, datum_posledniho_procviceni, obtiznost_verse | id_uzivatele → uživatel |
| Procvičení | ID, id_uzivatele, id_verse, cas, timestamp, uspesnost, typ_cviceni | id_uzivatele → uživatel, id_verse → verš |
| Přátelství | ID, stav, id_uzivatele, id_pritele, datum_vytvoreni | id_uzivatele → uživatel, id_pritele → uživatel |

# Pravidla integrity dat

- Primární klíče (ID) pro jednoznačnou identifikaci entit.
- Cizí klíče pro vazby mezi entitami, referenční integrita (např. id_uzivatele musí odpovídat existujícímu uživateli).
- Ověření domén (např. kniha, kapitola a vers musi byt kladne cislo v urcitem rozmezi).
- Unikátní omezení (např. email dvou uživatelů se nesmí shodovat).
- Kontrola povolených datových typů (např. datum, stav, kapitola).
- Zabezpečení dat proti neautorizované změně – přístupová práva

# Shrnutí

Základní entitou je uživatel. Tato entita uchovává základní informace o uživateli, včetně základního nastavení aplikace. Také obsahuje jeho denní řadu.

Druhou entitou je uložený verš. Tato entita obsahuje informace umožňující dohledat text konkrétního verše. (kniha, kapitola, vers, preklad) Tato entita je přiřazena právě k jednomu uživateli. Dále obsahuje datum dalšího procvičení, posledního procvičení a obtížnost daného verše.

Třetí entitou je procvičení. Tato entita je přiřazena právě jednomu uživateli a právě jednomu uloženému verši. Dále obsahuje timestamp, čas strávený na procvičení, typ cvičení a úspěšnost.

Poslední entitou je přátelství. Tato entita má přiřazené dva uživatele. Jeden z nich (id_uzivatel) odeslal žádost o přátelství a druhý (id_pritele) žádost obdržel. Tato entita obsahuje i stav žádosti a datum vytvoření přátelství.
