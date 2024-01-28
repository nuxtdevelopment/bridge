local init = {}

function init:config()
    local bridgeConfigFile = LoadResourceFile(bridge.name, 'config.json')

    if bridgeConfigFile then
        bridge.config = json.decode(bridgeConfigFile)
        
        local resourceConfigFile = LoadResourceFile(bridge.resourceName, 'config.json')

        if resourceConfigFile then
            local resourceConfig = json.decode(resourceConfigFile)

            for key, value in pairs(resourceConfig) do
                bridge.config[key] = value
            end
        end
    else
        bridge.logger:error('Config not found.')
    end
end

function init:locale()
    local localeFile = LoadResourceFile(bridge.resourceName, ('locales/%s.json'):format(bridge.config.lang))

    if localeFile then
        bridge.locale = json.decode(localeFile)
    else
        bridge.logger:error(('Locale %s not found.'):format(bridge.config.lang))
    end
end

local frameworks = {
    esx = {
        resourceName = 'es_extended',
        init = function()
            -- todo: Update eventleri eklenecek.

            return exports['es_extended']:getSharedObject()
        end
    },
    qb = {
        resourceName = 'qb-core',
        init = function()
            -- todo: Update eventleri eklenecek.

            return exports['qb-core']:GetCoreObject()
        end
    }
}

function init:framework()
    local framework = nil

    for key, value in pairs(frameworks) do
        if GetResourceState(value.resourceName) == 'started' then
            framework = {
                name = key,
                object = value.init()
            }
        end
    end

    if framework then
        bridge.framework = framework
    else
        bridge.logger:error('Framework not found.')
    end
end

return init
