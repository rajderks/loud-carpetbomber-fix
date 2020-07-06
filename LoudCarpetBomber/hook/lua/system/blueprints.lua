do
    local weap1 = {
				-- Roughly 11k / <divider> total damage on T1 ACU, as tested per original design. Depends heavily on luck.
        Damage = 352/4,
				DamageRadius = 5.7,
        DoTPulses = 4,
        DoTTime = 4,
				
				FiringRandomness = 5,
        FiringTolerance = 30,
				
        MaxRadius = 75,

        MuzzleSalvoDelay = 0.7,
        MuzzleSalvoSize = 1,
        MuzzleVelocity = 15,
				ProjectileId = '/projectiles/TIFNapalmCarpetBomb02/TIFNapalmCarpetBomb02_proj.bp',

				-- Keeping firing salvos in racks without triggering a new OnFire event -- doesn't seem to work under certain conditions.
				-- RackSalvoFiresAfterCharge = true,
				-- Random the muzzle velocity to increase perceived randomness
				MuzzleVelocityRandom = 3,
    }

    function deepCopy(o, seen)
        seen = seen or {}
        if o == nil then
            return nil
        end
        if seen[o] then
            return seen[o]
        end

        local no
        if type(o) == 'table' then
            no = {}
            seen[o] = no

            for k, v in next, o, nil do
                no[deepCopy(k, seen)] = deepCopy(v, seen)
            end
            setmetatable(no, deepCopy(getmetatable(o), seen))
        else -- number, string, boolean, etc
            no = o
        end
        return no
    end

    function CreateBombWeapon(weaponBp, bone, salvoSize, offset)
				local newBombWeapon = deepCopy(weaponBp)
				for k, v in weap1 do
					newBombWeapon[k] = deepCopy(v);
				end
        newBombWeapon.RackBones = {
            {
                MuzzleBones = {
                    bone
                },
                RackBone = 'UES0401'
						},
						{
							MuzzleBones = {
									bone
							},
							RackBone = 'UES0401'
					}
        }
        if salvoSize ~= nil then
					newBombWeapon.MuzzleSalvoSize = salvoSize
        end
        if offset ~= nil then
					newBombWeapon.MuzzleSalvoDelay = weaponBp.MuzzleSalvoDelay * offset
        end
        return newBombWeapon
    end

    local OldModBlueprints = ModBlueprints
    function ModBlueprints(all_blueprints)

        OldModBlueprints(all_blueprints)
        if all_blueprints.Unit['lea0401'] ~= nil then
            local unitBp = all_blueprints.Unit['lea0401']
            local bombs = deepCopy(unitBp.Weapon[1])
            if bombs ~= nil then
                unitBp.Weapon[1] = CreateBombWeapon(bombs, 'Bomb00', 7, 0.8)
                unitBp.Weapon[4] = CreateBombWeapon(bombs, 'Bomb01', 2, 1.07)
                unitBp.Weapon[5] = CreateBombWeapon(bombs, 'Bomb02', 3, 1)
                unitBp.Weapon[6] = CreateBombWeapon(bombs, 'Bomb03', 5, 1.15)
                unitBp.Weapon[7] = CreateBombWeapon(bombs, 'Bomb04', 3, 1.07)
                unitBp.Weapon[8] = CreateBombWeapon(bombs, 'Bomb05', 2, 1)
								unitBp.Weapon[9] = CreateBombWeapon(bombs, 'Bomb07', 4, 0.95)
								unitBp.Weapon[9] = CreateBombWeapon(bombs, 'Bomb07', 4, 0.95)
            end
        end
    end
end

