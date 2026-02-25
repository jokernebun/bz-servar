# Carvariations și modificări mașini

## Apex Tuning nu are nevoie de propriul fișier carvariations

Scriptul **apex_tuning** nu folosește niciun `carvariations.meta` propriu. Citește direct din joc, cu:
- `GetNumVehicleMods(veh, modType)` – câte opțiuni are mașina pentru fiecare tip (spoiler, motor, etc.)
- `SetVehicleMod(veh, modType, modIndex)` – aplică modificarea

Deci **nu trebuie să adaugi nimic în apex_tuning** pentru carvariations.

---

## Când trebuie să modifici ceva (mașini addon)

Dacă o **mașină addon** (din joker, dube, A19cars etc.) nu arată opțiuni la tuning sau nu se aplică modificările, atunci problema e la **acel vehicul**, nu la apex_tuning.

Trebuie editat **resource-ul vehiculului** (unde e modelul + meta-urile):

### 1. Fișiere importante

- **carvariations.meta** – numele modelului, culori, **kits** (seturi de moduri)
- **carcols.meta** (opțional) – paletă culori
- Unele resurse folosesc și **carmods** / **vehicles.meta** pentru kit-uri

### 2. Ce trebuie în carvariations.meta

În `<kits>` trebuie să existe cel puțin un modkit care oferă sloturi de modificare. Exemplu din proiectul tău (rx7):

```xml
<kits>
  <Item>672_rx7_modkit</Item>
  <Item>0_default_modkit</Item>
  <Item>dominator2_modkit</Item>
</kits>
```

- **0_default_modkit** – kit implicit (adesea fără multe opțiuni)
- **dominator2_modkit** – kit de la o mașină GTA (dominator2), care are multe sloturi; îl poți folosi ca „bază” pentru mașini addon
- **672_rx7_modkit** – kit specific modelului rx7 (definit undeva în resurse/joc)

Fără un kit care conține sloturi (spoiler, bumper, motor, jante etc.), `GetNumVehicleMods` va returna 0 și în meniul de tuning nu vor apărea opțiuni.

### 3. Cum faci o mașină addon „modificabilă”

1. Deschide **carvariations.meta** al vehiculului addon (ex: `joker/data/numelemasinii/carvariations.meta`).
2. Găsește blocul `<kits>` pentru `<modelName>numelemasinii</modelName>`.
3. Asigură-te că ai în `<kits>` cel puțin:
   - un kit care să aibă moduri (ex: **dominator2_modkit** pentru multe sloturi GTA), sau
   - un modkit specific vehiculului tău, definit în **carcols.meta** (CVehicleModelInfoVarGlobal → Kits).
4. **ID kit pentru addon**: în **carcols.meta**, la kit-ul tău (și la Lights dacă e același id), folosește **&lt;id value="1001" /&gt;** … **1024**. ID-uri sub 1001 (ex: 747) pot să nu fie recunoscute pentru vehicule addon; 1001–1024 sunt recomandate.
5. În **carvariations.meta**, `lightSettings value="..."` trebuie să fie același număr ca `id` din carcols (ex: 1001).
6. Salvează și restartează resource-ul vehiculului (sau serverul).

Dacă vehiculul nu are deloc **carvariations.meta** sau nu are **kits** cu sloturi, atunci în tuning va avea 0 opțiuni pentru acele sloturi – nu e o problemă de apex_tuning, ci de definiția vehiculului.

### 4. Rezumat

| Situație | Ce faci |
|----------|--------|
| Mașini GTA stock | Nimic – au deja toate modurile în joc. |
| Mașini addon fără opțiuni la tuning | Editezi **carvariations.meta** al acelui vehicul: adaugi/referințezi kit-uri cu moduri (ex. dominator2_modkit). |
| Apex Tuning | **Nu** adaugi carvariations în resource-ul apex_tuning. |
