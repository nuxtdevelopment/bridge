local cache = {}

function cache:set(name, value)
    if value ~= cache[name] then
        bridge.event:trigger(('%s:cache:set:%s'):format(bridge.resourceName, name), value, cache[name])

        cache[name] = value
    end
end

function cache:watch(name, handler)
    bridge.event:register(('%s:cache:set:%s'):format(bridge.resourceName, name), handler)
end

return cache
