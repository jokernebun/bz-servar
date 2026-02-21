BZ = BZ or {}
BZ.Jobs = {}

-- ============================================================
-- DEFINITII JOBURI
-- Adauga sau modifica joburi dupa nevoie
-- ============================================================

BZ.Jobs['unemployed'] = {
    label  = 'Somer',
    defaultDuty = true,
    grades = {
        [0] = { label = 'Somer', salary = 0 },
    },
}

BZ.Jobs['police'] = {
    label   = 'Politie Nationala',
    defaultDuty = false,
    blip    = { sprite = 60, color = 3, scale = 0.8 },
    grades  = {
        [0] = { label = 'Stagiar',          salary = 1500, bankSalary = 0  },
        [1] = { label = 'Agent',            salary = 2000, bankSalary = 0  },
        [2] = { label = 'Agent Principal',  salary = 2500, bankSalary = 0  },
        [3] = { label = 'Sergent',          salary = 3000, bankSalary = 0  },
        [4] = { label = 'Locotenent',       salary = 3500, bankSalary = 0  },
        [5] = { label = 'Capitan',          salary = 4000, bankSalary = 0, isBoss = true },
    },
}

BZ.Jobs['ambulance'] = {
    label   = 'SMURD / Ambulanta',
    defaultDuty = false,
    blip    = { sprite = 61, color = 1, scale = 0.8 },
    grades  = {
        [0] = { label = 'Paramedic',         salary = 1500, bankSalary = 0  },
        [1] = { label = 'Medic Urgente',     salary = 2000, bankSalary = 0  },
        [2] = { label = 'Medic Senior',      salary = 2500, bankSalary = 0  },
        [3] = { label = 'Doctor',            salary = 3000, bankSalary = 0  },
        [4] = { label = 'Doctor Sef',        salary = 3500, bankSalary = 0, isBoss = true },
    },
}

BZ.Jobs['mechanic'] = {
    label   = 'Mecanic Auto',
    defaultDuty = false,
    blip    = { sprite = 446, color = 5, scale = 0.8 },
    grades  = {
        [0] = { label = 'Ucenic',        salary = 1200, bankSalary = 0  },
        [1] = { label = 'Mecanic',       salary = 1800, bankSalary = 0  },
        [2] = { label = 'Mecanic Sef',   salary = 2200, bankSalary = 0  },
        [3] = { label = 'Manager',       salary = 2800, bankSalary = 0, isBoss = true },
    },
}

BZ.Jobs['trucker'] = {
    label   = 'Sofer TIR',
    defaultDuty = false,
    blip    = { sprite = 477, color = 47, scale = 0.8 },
    grades  = {
        [0] = { label = 'Sofer Nou',     salary = 1000, bankSalary = 0  },
        [1] = { label = 'Sofer',         salary = 1500, bankSalary = 0  },
        [2] = { label = 'Sofer Senior',  salary = 2000, bankSalary = 0  },
        [3] = { label = 'Dispatcher',    salary = 2500, bankSalary = 0, isBoss = true },
    },
}

-- ============================================================
-- DEFINITII GASTE
-- ============================================================
BZ.Gangs = {}

BZ.Gangs['none'] = {
    label  = 'Fara Gasca',
    grades = {
        [0] = { label = 'Fara Gasca' },
    },
}

BZ.Gangs['vagos'] = {
    label  = 'Vagos',
    grades = {
        [0] = { label = 'Prospect'  },
        [1] = { label = 'Membru'    },
        [2] = { label = 'Locotenent'},
        [3] = { label = 'Boss', isBoss = true },
    },
}

BZ.Gangs['ballas'] = {
    label  = 'Ballas',
    grades = {
        [0] = { label = 'Prospect'  },
        [1] = { label = 'Soldat'    },
        [2] = { label = 'Caporal'   },
        [3] = { label = 'General', isBoss = true },
    },
}

BZ.Gangs['marabunta'] = {
    label  = 'Marabunta Grande',
    grades = {
        [0] = { label = 'Novice'    },
        [1] = { label = 'Membru'    },
        [2] = { label = 'Sergent'   },
        [3] = { label = 'Jefe', isBoss = true },
    },
}
