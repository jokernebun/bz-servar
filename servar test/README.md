# 🎮 BZ RolePlay Framework

Server FiveM complet, scris de la zero. Include framework, joburi, crafting, inventar, banca si mai mult.

---

## 📋 Cerinte

| Software | Link |
|---|---|
| **FXServer** (CitizenFX) | https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/ |
| **MySQL / MariaDB** | https://mariadb.org/download/ |
| **oxmysql** (resource) | https://github.com/overextended/oxmysql/releases |

---

## ⚙️ Instalare Pas cu Pas

### 1. Descarca FXServer
- Mergi la https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/
- Descarca **latest recommended** build
- Extrage in `D:\servar test\` (sau alt folder)
- Structura finala:
  ```
  D:\servar test\
  ├── FXServer.exe
  ├── citizen\
  ├── server.cfg
  ├── database.sql
  └── resources\
  ```

### 2. Instaleaza MySQL (MariaDB)
- Descarca si instaleaza MariaDB de la mariadb.org
- In timpul instalarii, seteaza o parola pentru root (ex: `parola123`)
- Deschide phpMyAdmin sau HeidiSQL
- Executa fisierul `database.sql`
- Aceasta va crea baza de date `bz_server` cu toate tabelele

### 3. Descarca oxmysql
- Mergi la: https://github.com/overextended/oxmysql/releases
- Descarca ultimul release (fisierul `.zip`)
- Extrage si pune in `resources\[core]\oxmysql\`

### 4. Configureaza server.cfg
Deschide `server.cfg` si schimba:
```cfg
sv_licenseKey "<SCHIMBA_CU_LICENTA_CFXRE>"
# Obtine licenta de la: https://keymaster.fivem.net/

set mysql_connection_string "mysql://root:PAROLA_TA@localhost/bz_server?charset=utf8mb4"
# Inlocuieste PAROLA_TA cu parola MySQL de la pasul 2
```

### 5. Adauga-te ca Admin
In `server.cfg`, gaseste linia:
```cfg
# add_principal identifier.license:<LICENTA_ADMIN> group.admin
```
Decommenteaza si inlocuieste `<LICENTA_ADMIN>` cu licenta ta Steam.

**Cum gasesti licenta?**
- Porneste serverul
- Conecteaza-te
- In consola serverului vei vedea: `[BZ Core] PlayerName s-a conectat`
- Licenta apare ca `license:XXXXX`

### 6. Porneste Serverul
```bash
# Windows
.\FXServer.exe +exec server.cfg

# Sau creeaza un .bat
@echo off
FXServer.exe +exec server.cfg
pause
```

---

## 📁 Structura Resurse

```
resources\
├── [core]\
│   ├── oxmysql\          ← TREBUIE DESCARCAT
│   └── bz_core\          ← Framework principal
├── [ui]\
│   ├── bz_notifications\ ← Notificari
│   ├── bz_menu\          ← Meniuri context
│   ├── bz_hud\           ← HUD
│   └── bz_multichar\     ← Selectie personaj
├── [inventory]\
│   └── bz_inventory\     ← Inventar (F2)
├── [crafting]\
│   └── bz_crafting\      ← Sistem crafting
├── [economy]\
│   └── bz_banking\       ← Banca + ATM
└── [jobs]\
    ├── bz_police\        ← Job Politie
    ├── bz_ambulance\     ← Job Ambulanta
    ├── bz_mechanic\      ← Job Mecanic
    └── bz_trucker\       ← Job Sofer TIR
```

---

## 🎮 Comenzi In-Game

### Generale
| Tasta | Actiune |
|---|---|
| `F2` | Deschide Inventarul |
| `F6` | Meniu Job |
| `E` | Interactie (banci, crafting, etc.) |

### Admin (necesita permisiuni)
| Comanda | Descriere |
|---|---|
| `/noclip` | Activeaza zborul |
| `/god` | God mode |
| `/tp [x] [y] [z]` | Teleporteaza |
| `/bring [id]` | Aduce un jucator |
| `/setjob [id] [job] [grade]` | Seteaza jobul |
| `/setmoney [id] [cash/bank] [suma]` | Seteaza banii |
| `/giveitem [id] [item] [cantitate]` | Da un item |
| `/kick [id] [motiv]` | Kick |
| `/ban [id] [motiv]` | Ban permanent |
| `/players` | Lista jucatori online |

---

## 🏢 Joburi Disponibile

### 🚔 Politie (`police`)
- Intrare/iesire serviciu din meniu F6
- Armurerie cu arme, catuse, trusa medicala
- Garaj cu vehicule de serviciu
- MDT pentru cautare persoane
- Catuse (comanda `/cuff`)
- Stash personal

### 🏥 Ambulanta (`ambulance`)
- Revive jucatori morti
- Echipament medical din meniu
- Ambulanta de serviciu
- Platit per interventie (+500 lei)

### 🔧 Mecanic (`mechanic`)
- Repara vehicule din apropiere
- Repara anvelope
- Umple rezervoare
- Masa de crafting cu retete speciale

### 🚛 Sofer TIR (`trucker`)
- 4 rute de livrare cu pay diferit
- Sistem pickup → delivery cu blip GPS
- Camion aleator la intrarea in serviciu
- Plata in cont bancar

---

## ⚒️ Mese de Crafting

| Masa | Locatie | Job Necesar |
|---|---|---|
| Masa Generala | Centru LS (224, -967) | Oricine |
| Atelier Mecanic | (-352, -133) | Mecanic |
| Atelier Electronic | (117, -1080) | Oricine |
| Laborator Droguri | (1385, 3614) | ❌ Ilegal |
| Atelier Arme | (813, -2157) | ❌ Ilegal |

**Cum functioneaza:**
1. Mergi la locatia mesei
2. Apasa `E` cand esti aproape
3. Selecteaza reteta
4. Daca ai ingredientele, apasa "Fabrica"
5. Asteapta progresul (poti anula cu `X`)

---

## 🏦 Banking

- **ATM-uri** raspandite in oras (blipuri pe harta)
- **Banci** cu functii complete (depune/retrage/transfer)
- Istoricul ultimelor 20 tranzactii
- Transfer direct catre alt jucator (ID)

---

## 🆕 Adaugare Job Nou

1. Adauga jobul in `resources\[core]\bz_core\shared\jobs.lua`
2. Creeaza un folder `resources\[jobs]\bz_NUMEJOB\`
3. Adauga `ensure bz_NUMEJOB` in `server.cfg`

Exemplu configuratie job:
```lua
BZ.Jobs['chef'] = {
    label   = 'Bucatar',
    defaultDuty = false,
    grades  = {
        [0] = { label = 'Ucenic',   salary = 1200 },
        [1] = { label = 'Bucatar',  salary = 1800 },
        [2] = { label = 'Chef',     salary = 2500, isBoss = true },
    },
}
```

---

## 🆕 Adaugare Item Nou

In `resources\[core]\bz_core\shared\items.lua`:
```lua
BZ.Items['nou_item'] = {
    name        = 'nou_item',
    label       = 'Item Nou',
    weight      = 500,
    usable      = true,
    stackable   = true,
    description = 'Descriere item.',
}
```

---

## 🆕 Adaugare Reteta Crafting

In `resources\[crafting]\bz_crafting\shared\recipes.lua`, adauga la masa dorita:
```lua
{
    result      = 'nou_item',
    resultCount = 1,
    label       = 'Item Nou',
    icon        = '📦',
    description = 'Fabrica un item nou',
    time        = 5000,  -- ms
    ingredients = {
        { item='iron_bar', count=2 },
        { item='plastic',  count=1 },
    },
},
```

---

## ❓ Probleme Frecvente

**Serverul nu porneste:**
- Verifica ca `sv_licenseKey` este corect
- Verifica ca MySQL ruleaza si parola este corecta
- Verifica ca `oxmysql` este in resurse

**Jucatorul nu se spawneaza:**
- Asigura-te ca `bz_multichar` este pornit
- Verifica consola pentru erori

**Inventarul nu functioneaza:**
- Verifica ca `bz_inventory` si `bz_core` sunt pornite
- Verifica conexiunea MySQL

---

## 📞 Configuratii Rapide

### Schimba banii de start:
`server.cfg`: `set bz:startCash 5000` si `set bz:startBank 10000`

### Activeaza whitelist:
`server.cfg`: `set bz:enableWhitelist true`

### Limita personaje per cont:
`server.cfg`: `set bz:maxCharacters 3`

---

*BZ Framework v1.0.0 | Custom Build*
