AddEventHandler('onClientMapStart', function()
  exports.spawnmanager:setAutoSpawn(true)
  exports.spawnmanager:forceRespawn()
end)

Citizen.CreateThread( function() 
    while not exports.spawnmanager and not exports.spawnmanager.spawnPlayer and not exports.spawnManager.setAutoSpawn do
        Citizen.Wait( 0 )
    end

    -- exports.spawnmanager:spawnPlayer()
    Citizen.Wait( 2500 )
    exports.spawnmanager:setAutoSpawn( false )

    Citizen.CreateThread( function() 
        while true do
            local p = PlayerPedId()
    
            if IsEntityDead( p ) then
                SetPlayerInvincible( PlayerId(), true )
                SetEntityHealth( p, 1 )

                BeginTextCommandDisplayHelp( "STRING" )
                AddTextComponentSubstringPlayerName( "You are dead! To revive yourself, press ~INPUT_18E84EC4~. To respawn, press ~INPUT_13469830~." )
                EndTextCommandDisplayHelp( 0, false, false, -1 )
            end
    
            Citizen.Wait( 0 )
        end
    end )
end )

-- ~INPUT_1380BFED~
RegisterKeyMapping( "+revive", "(Actions) Revive", "keyboard", "e" )
RegisterCommand( "-revive", function() end )
RegisterCommand( "+revive", function()
    local p = PlayerPedId()
    local c = GetEntityCoords( p )

    if not IsEntityDead( p ) then return end

    NetworkResurrectLocalPlayer( c, true, true, false )
    SetPlayerInvincible( PlayerId(), false )
    ClearPedBloodDamage( p )
end )

-- ~INPUT_8544B5A7~
RegisterKeyMapping( "+respawn", "(Actions) Respawn", "keyboard", "r" )
RegisterCommand( "-respawn", function() end )
RegisterCommand( "+respawn", function() 
    if not IsEntityDead( PlayerPedId() ) then return end
    exports.spawnmanager:spawnPlayer()
end )

do
    local ragdolling = false

    RegisterKeyMapping( '+ragdoll', '(Actions) Ragdoll', 'keyboard', 'u' )
    RegisterCommand( '+ragdoll', function()
        local p = PlayerPedId()

        ragdolling = true

        while ragdolling do
            SetPedToRagdoll( p, 1000, 1000, 0, 0, 0, 0 )

            Citizen.Wait( 0 )
        end
    end )

    RegisterCommand( '-ragdoll', function()
        ragdolling = false
    end )
end
