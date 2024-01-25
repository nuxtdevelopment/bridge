local bridge = setmetatable({
    isServer = IsDuplicityVersion(),
    resourceName = GetCurrentResourceName(),
    modules = {},
    config = {
        frameworks = {
            ['esx'] = {
                resource = 'es_extended'
            },
            ['qb'] = {
                resource = 'admin'
            }
        }
    }
}, {
    __index = function(table, key)
        local module = table:require(key)

        if module then
            return module
        end

        return false
    end
})

function bridge:require(name)
    if bridge.modules[name] then
        return bridge.modules[name]()
    end

    local modulePath = name:gsub('%.', '/')

    if modulePath then
        local moduleFile = LoadResourceFile(bridge.resourceName, ('modules/%s.lua'):format(modulePath))

        if moduleFile then
            local module = load(moduleFile)

            if module then
                bridge.modules[name] = module

                return module()
            end
        end
    end

    return false
end

CreateThread(function()
    -- todo: versiyon kontrolü yapılacak.

    for key, value in pairs(bridge.config.frameworks) do
        local resourceState = GetResourceState(value.resource)

        if resourceState == 'started' then
            bridge.framework = key
        end
    end
end)

exports('getObjects', function()
    return bridge
end)
