bridge = setmetatable({
    name = 'nuxt-bridge',
    resourceName = GetCurrentResourceName(),
    context = IsDuplicityVersion() and 'server' or 'client',
    config = {
        lang = 'en',
        interface = {
            style = 'default'
        }
    }
}, {
    __index = function(self, key)
        local directory = ('modules/%s'):format(key)
        local chunk = LoadResourceFile(self.name, ('%s/%s.lua'):format(directory, self.context))
        local shared = LoadResourceFile(self.name, ('%s/shared.lua'):format(directory))

        if shared then
            chunk = (chunk and ('%s\n%s'):format(shared, chunk)) or shared
        end

        if chunk then
            local module, error = load(chunk, ('@@nuxt-bridge/%s/%s.lua'):format(key, self.context))

            if module and not error then
                self[key] = module()

                return self[key]
            end
        end
    end
})

CreateThread(function()
    local localeFile = LoadResourceFile(bridge.resourceName, ('locales/%s.json'):format(bridge.config.lang))

    if localeFile then
        bridge.locale = json.decode(localeFile)
    else
        bridge.logger:error(('Locale %s does not exist.'):format(bridge.config.lang))
    end

    if bridge.context == 'client' then
        local interfaceData = {
            locale = bridge.locale
        }

        for key, value in pairs(bridge.config.interface) do
            interfaceData[key] = value
        end

        RegisterNuiCallback('getInterfaceData', function(_, callback)
            callback(interfaceData)
        end)
    end
end)
