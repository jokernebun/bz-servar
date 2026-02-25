# Cum extragi fișierele GTA pentru potrivirea mașinilor joker

## 1. Ce ai nevoie

- **OpenIV** (mod pentru GTA V) – dacă nu îl ai: https://openiv.com/
- Calea ta GTA: `D:\GTA5\Grand Theft Auto V Legacy`

---

## 2. Unde sunt fișierele în GTA V

- **carcols.meta** (kit-uri, luminii): în arhive precum  
  `update\update.rpf\common\data\carcols.meta`  
  sau în DLC-uri, ex. `x64e.rpf\common\data\carcols.meta` etc.
- **carvariations.meta** (culori, kits per model):  
  `update\update.rpf\common\data\carvariations.meta`  
  (sau în același tip de path în DLC-uri)

În OpenIV deschizi aceste `.rpf`, mergi la fișierul respectiv, dai click dreapta → **Export**.

---

## 3. Ce să exporți pentru fiecare mașină GTA

Pentru fiecare model GTA pe care vrei să îl folosești ca bază (ex. `tailgater2`, `buffalo2`):

### A) carcols.meta

- Exportă **întreg** fișierul `carcols.meta` din acel DLC/update (un singur fișier conține toate kit-urile).
- Sau, dacă știi să editezi XML: copiază doar blocul `<Kits>` care conține `<kitName>...tailgater2...` (sau numele kit-ului pentru acel model).

### B) carvariations.meta

- Exportă **întreg** fișierul `carvariations.meta`,  
  **sau**
- Din el, copiază doar blocul `<Item>...</Item>` care conține  
  `<modelName>tailgater2</modelName>` (și tot ce e în el: `<colors>`, `<kits>`, etc.).

---

## 4. Unde să pui fișierele în proiect

Creează în resource-ul tău un folder, de exemplu:

```
d:\server pr.0.0.1\txData\Qbox_876599.base\resources\gta_export\
```

Acolo pune fișierele exportate, cu nume clare după **modelul GTA**:

- `carcols.meta`  → poți pune un singur fișier dacă ai exportat tot (ex. `carcols_update.meta`),  
  **sau** un fișier per model: `carcols_tailgater2.meta`, `carcols_buffalo2.meta`, etc.
- `carvariations.meta` → la fel: unul singur `carvariations_update.meta`  
  **sau** per model: `carvariations_tailgater2.meta`, `carvariations_buffalo2.meta`, etc.

Dacă pui **un fișier mare** (tot carcols / tot carvariations), spune-mi și eu pot căuta în el după model.

---

## 5. Lista de potriviri (joker ↔ GTA)

Când extragi, e bine să știi perechile. Exemplu:

| Folder joker (model) | Nume în qbx_core (orientativ) | Model GTA sugerat (exemplu) |
|----------------------|-------------------------------|-----------------------------|
| 18rs7                | Obey Tailgater Performance    | tailgater2                  |
| 16charger            | Bravado Buffalo SRT           | buffalo2 / buffalo3         |
| civic2020            | (vezi vehicles.lua)           | blista2 / blista             |
| 2019chiron           | Truffade Nero Sport          | nero / nero2                |

Poți alege tu perechile. Când ai extras fișierele și le-ai pus în `gta_export`, scrie aici:
- ce modele GTA ai extras (ex. tailgater2, buffalo2),
- și pentru ce mașini joker le folosim (ex. 18rs7, 16charger).

Atunci pot modifica `carcols.meta` și `carvariations.meta` din joker ca să se potrivească cu GTA și, unde lipsește, să creez `carcols.meta`.

---

## Rezumat

1. Deschizi GTA în OpenIV și exporți `carcols.meta` și/sau `carvariations.meta` (din update sau DLC).
2. Le pui în `resources\gta_export\` (sau alt folder pe care îl alegi în proiect).
3. Îmi spui ce modele GTA ai (ex. tailgater2, buffalo2) și ce mașini joker să le potrivim.
4. Apoi pot aplica potrivirile în joker (și crea `carcols.meta` unde lipsește).
