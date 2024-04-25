local function call(self, index)
    local directory = ('modules/%s'):format(index)
    local chunk = LoadResourceFile(self.name, ('%s/%s.lua'):format(directory, self.context))
    local shared = LoadResourceFile(self.name, ('%s/shared.lua'):format(directory))

    if shared then
        chunk = (chunk and ('%s\n%s'):format(shared, chunk)) or shared
    end

    if chunk then
        local module, error = load(chunk, ('@@%s/%s/%s.lua'):format(self.name, index, self.context))

        if module and not error then
            self[index] = module()

            return self[index]
        end
    else
        self.logger:error('90631')
    end
end

local lib = setmetatable({
    name = 'nuxt-lib',
    resourceName = GetCurrentResourceName(),
    context = IsDuplicityVersion() and 'server' or 'client',
    frameworks = {
        esx = {
            resourceName = 'es_extended',
            init = function()
                print('esx inited.')

                return {}
            end
        },
        qb = {
            resourceName = 'qb-core',
            init = function()
                print('qb inited.')

                return {}
            end
        }
    }
}, {
    __index = call
})

CreateThread(function()
    -- init framework
    local framework

    for key, value in pairs(lib.frameworks) do
        local resourceState = GetResourceState(value.resourceName)

        if resourceState == 'started' then
            framework = value.init()

            framework.name = key

            break
        end
    end

    if lib.context == 'server' and lib.name == lib.resourceName then
        if framework then
            lib.framework = framework

            lib.logger:success(('%s framework found.'):format(lib.framework.name))
        else
            lib.logger:error('76503')
        end
    end
end)

_ENV.lib = lib
