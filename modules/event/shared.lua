local event = {}

---@param name string
---@param handler function
function event:register(name, handler)
    if name and type(name) == 'string' then
        if handler and type(handler) == 'function' then
            local eventName = ('%s:event:%s'):format(lib.name, name)

            RegisterNetEvent(eventName, function(callback, ...)
                local payload = { handler(...) }

                if callback then
                    callback(table.unpack(payload))
                else
                    if lib.context == 'client' then
                        TriggerServerEvent(eventName, table.unpack(payload))
                    else
                        TriggerClientEvent(eventName, source, table.unpack(payload))
                    end
                end
            end)
        else
            lib.logger:error('30589')
        end
    else
        lib.logger:error('12978')
    end
end

---@param name string
---@param ... any
---@return any?
function event:trigger(name, ...)
    if name and type(name) == 'string' then
        local promise = promise:new()

        local function callback(...)
            promise:resolve({ ... })
        end

        local eventName = ('%s:event:%s'):format(lib.name, name)

        TriggerEvent(eventName, callback, ...)

        return table.unpack(Citizen.Await(promise))
    else
        lib.logger:error('09783')
    end
end

if lib.context == 'client' then
    ---@param name string
    ---@param ... any
    ---@return any?
    function event:triggerServer(name, ...)
        if name and type(name) == 'string' then
            local promise = promise:new()

            local eventName = ('%s:event:%s'):format(lib.name, name)

            RegisterNetEvent(eventName, function(...)
                promise:resolve({ ... })
            end)

            TriggerServerEvent(eventName, nil, ...)

            return table.unpack(Citizen.Await(promise))
        else
            lib.logger:error('37098')
        end

    end
else
    ---@param name string
    ---@param source number
    ---@param ... any
    ---@return any?
    function event:triggerClient(name, source, ...)
        if name and type(name) == 'string' then
            if source and type(source) == 'number' then
                local promise = promise:new()

                local eventName = ('%s:event:%s'):format(lib.name, name)

                RegisterNetEvent(eventName, function(...)
                    promise:resolve({ ... })
                end)

                TriggerClientEvent(eventName, source, nil, ...)

                return table.unpack(Citizen.Await(promise))
            else
                lib.logger:error('68683')
            end
        else
            lib.logger:error('75327')
        end
    end
end

return event
