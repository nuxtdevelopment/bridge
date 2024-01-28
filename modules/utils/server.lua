local utils = {}

function utils:request(url, method, data, headers)
    local promise = promise:new()

    PerformHttpRequest(url, function(...)
        promise:resolve({ ... })
    end, method, data, headers)

    return table.unpack(Citizen.Await(promise))
end

return utils
