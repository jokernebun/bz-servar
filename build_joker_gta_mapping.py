import os
import xml.etree.ElementTree as ET

BASE = r"d:\server pr.0.0.1\txData\Qbox_876599.base"
JOKER_DATA = os.path.join(BASE, r"resources\joker\data")
GTA_BASE = r"d:\gta variations"


def collect_vehicles(root_dir):
    items = []
    for root, _dirs, files in os.walk(root_dir):
        for name in files:
            if name.lower() != "vehicles.meta":
                continue
            path = os.path.join(root, name)
            try:
                tree = ET.parse(path)
                r = tree.getroot()
            except Exception:
                continue
            for item in r.findall(".//Item"):
                m = item.find("modelName")
                g = item.find("gameName")
                make = item.find("vehicleMakeName")
                if m is None:
                    continue
                model = (m.text or "").strip()
                game = (g.text or "").strip() if g is not None else ""
                brand = (make.text or "").strip() if make is not None else ""
                if model:
                    items.append({"model": model, "gameName": game, "brand": brand})
    return items


def normalize_name(s: str) -> str:
    return "".join(ch.lower() for ch in s if ch.isalnum() or ch.isspace()).strip()


def words(s: str) -> set:
    return set(normalize_name(s).split())


def find_best_gta(joker_item: dict, gta_list: list) -> tuple:
    """Gaseste cel mai bun model GTA pentru un joker (gameName). Returneaza (gta_item, score)."""
    jname = joker_item.get("normGame") or ""
    jmodel = (joker_item.get("model") or "").strip()
    if not jname:
        return None, 0
    jw = words(joker_item.get("gameName") or "")
    best_g = None
    best_score = 0
    for g in gta_list:
        gname = g.get("normGame") or ""
        gmodel = (g.get("model") or "").strip()
        if not gname:
            continue
        score = 0
        if gname == jname:
            score = 100
        elif gname in jname:
            score = max(score, 50 + len(gname) // 2)
        elif jname in gname:
            score = max(score, 40)
        if gmodel and normalize_name(gmodel) in jname:
            score = max(score, 45)
        gw = words(g.get("gameName") or "")
        overlap = len(gw & jw)
        if overlap > 0:
            score = max(score, 10 + overlap * 5)
        if score > best_score:
            best_score = score
            best_g = g
    return best_g, best_score


def main() -> None:
    print("Collecting GTA vehicles...")
    gta = collect_vehicles(GTA_BASE)
    print("GTA vehicles:", len(gta))

    print("Collecting joker vehicles...")
    joker = collect_vehicles(JOKER_DATA)
    print("joker vehicles:", len(joker))

    for v in gta:
        v["normGame"] = normalize_name(v["gameName"])
    for v in joker:
        v["normGame"] = normalize_name(v["gameName"])

    mappings = []
    for j in joker:
        g, score = find_best_gta(j, gta)
        if g and score >= 10:
            mappings.append((j, g))

    mappings.sort(key=lambda x: x[0]["model"].lower())

    out_path = os.path.join(
        BASE, r"resources\apex_tuning\joker_gta_mapping.md"
    )
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w", encoding="utf-8", newline="") as f:
        f.write("# Joker \u2194 GTA vehicle matches (auto-detected)\n\n")
        f.write(
            "| Joker model | Joker gameName | GTA model | GTA gameName | GTA brand |\n"
        )
        f.write(
            "|------------|----------------|-----------|--------------|-----------|\n"
        )
        for j, g in mappings:
            f.write(
                f"| `{j['model']}` | {j['gameName'] or '-'} | "
                f"`{g['model']}` | {g['gameName'] or '-'} | {g['brand'] or '-'} |\n"
            )

    print("Wrote", out_path, "with", len(mappings), "matches")

    # Actualizare spawn/client.lua cu toate perechile
    spawn_client = os.path.join(BASE, r"resources\spawn\client.lua")
    lua_lines = [
        "local pairsList = {",
    ]
    for j, g in mappings:
        lua_lines.append(
            "    { joker = %s, gta = %s }," % (repr(j["model"]), repr(g["model"]))
    )
    lua_lines.append("}")
    lua_lines.append("")
    lua_lines.append("local currentIndex = 1")
    lua_lines.append("")
    lua_lines.append("local function notify(msg)")
    lua_lines.append('    BeginTextCommandThefeedPost("STRING")')
    lua_lines.append("    AddTextComponentSubstringPlayerName(msg)")
    lua_lines.append("    EndTextCommandThefeedPostTicker(false, false)")
    lua_lines.append("end")
    lua_lines.append("")
    lua_lines.append("local function spawnVehicle(model, offset)")
    lua_lines.append("    local ped = PlayerPedId()")
    lua_lines.append("    local coords = GetEntityCoords(ped)")
    lua_lines.append("    local heading = GetEntityHeading(ped)")
    lua_lines.append("")
    lua_lines.append("    local hash = GetHashKey(model)")
    lua_lines.append("    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then")
    lua_lines.append('        notify(("[compare] Model invalid: %s"):format(model))')
    lua_lines.append("        return nil")
    lua_lines.append("    end")
    lua_lines.append("")
    lua_lines.append("    RequestModel(hash)")
    lua_lines.append("    local timeout = GetGameTimer() + 5000")
    lua_lines.append("    while not HasModelLoaded(hash) do")
    lua_lines.append("        if GetGameTimer() > timeout then")
    lua_lines.append('            notify(("[compare] Nu pot incarca modelul: %s"):format(model))')
    lua_lines.append("            return nil")
    lua_lines.append("        end")
    lua_lines.append("        Wait(0)")
    lua_lines.append("    end")
    lua_lines.append("")
    lua_lines.append("    local x = coords.x + offset.x")
    lua_lines.append("    local y = coords.y + offset.y")
    lua_lines.append("    local z = coords.z + offset.z")
    lua_lines.append("")
    lua_lines.append("    local veh = CreateVehicle(hash, x, y, z, heading, true, false)")
    lua_lines.append("    SetVehicleOnGroundProperly(veh)")
    lua_lines.append("    SetEntityAsMissionEntity(veh, true, true)")
    lua_lines.append("    SetVehicleNumberPlateText(veh, string.upper(model):sub(1, 8))")
    lua_lines.append("")
    lua_lines.append("    SetModelAsNoLongerNeeded(hash)")
    lua_lines.append("    return veh")
    lua_lines.append("end")
    lua_lines.append("")
    lua_lines.append("local function spawnCurrentPair()")
    lua_lines.append("    if #pairsList == 0 then")
    lua_lines.append('        notify("[compare] Lista de perechi este goala.")')
    lua_lines.append("        return")
    lua_lines.append("    end")
    lua_lines.append("")
    lua_lines.append("    if currentIndex > #pairsList then")
    lua_lines.append("        currentIndex = 1")
    lua_lines.append("    end")
    lua_lines.append("")
    lua_lines.append("    local pair = pairsList[currentIndex]")
    lua_lines.append("    currentIndex = currentIndex + 1")
    lua_lines.append("")
    lua_lines.append('    notify(("[compare] Spawn %s (joker) + %s (GTA)"):format(pair.joker, pair.gta))')
    lua_lines.append("")
    lua_lines.append("    spawnVehicle(pair.joker, vector3(2.5, 0.0, 0.0))")
    lua_lines.append("    spawnVehicle(pair.gta,   vector3(-2.5, 0.0, 0.0))")
    lua_lines.append("end")
    lua_lines.append("")
    lua_lines.append("-- /e – fara argumente, doar merge la urmatoarea pereche")
    lua_lines.append("RegisterCommand('e', function()")
    lua_lines.append("    spawnCurrentPair()")
    lua_lines.append("end, false)")
    lua_lines.append("")

    with open(spawn_client, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lua_lines))
    print("Wrote", spawn_client, "with", len(mappings), "pairs")


if __name__ == "__main__":
    main()

