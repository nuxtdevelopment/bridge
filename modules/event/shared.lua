local event = {}

function event:register(name, handler)
    RegisterNetEvent(name, function(callback, ...)
        local payload = { handler(...) }

        if callback then
            callback(table.unpack(payload))
        else
            if bridge.context == 'client' then
                TriggerServerEvent(name, table.unpack(payload))
            else
                TriggerClientEvent(name, source, table.unpack(payload))
            end
        end
    end)
end

function event:trigger(name, ...)
    local promise = promise:new()

    local function callback(...)
        promise:resolve({ ... })
    end

    TriggerEvent(name, callback, ...)

    return table.unpack(Citizen.Await(promise))
end

if bridge.context == 'client' then
    function event:triggerServer(name, ...)
        local promise = promise:new()

        RegisterNetEvent(name, function(...)
            promise:resolve({ ... })
        end)
    
        TriggerServerEvent(name, nil, ...)
    
        return table.unpack(Citizen.Await(promise))
    end
else
    function event:triggerClient(name, source, ...)
        local promise = promise:new()

        RegisterNetEvent(name, function(...)
            promise:resolve({ ... })
        end)
    
        TriggerClientEvent(name, source, nil, ...)
    
        return table.unpack(Citizen.Await(promise))
    end
end

return event
