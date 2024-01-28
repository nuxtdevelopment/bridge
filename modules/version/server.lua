local version = {}

function version:check()
    local resource = bridge.resourceName
    local currentVersion = GetResourceMetadata(resource, 'version', 0)

	if currentVersion then
        Wait(500)

		currentVersion = currentVersion:match('%d+%.%d+%.%d+')

        local status, response = bridge.utils:request(('https://api.github.com/repos/nuxtdeveloment/%s/releases/latest'):format(resource), 'GET')

        if status ~= 200 then return end

        response = json.decode(response)
        if response.prerelease then return end

        local latestVersion = response.tag_name:match('%d+%.%d+%.%d+')
        if not latestVersion or latestVersion == currentVersion then return end

        local cv = { string.strsplit('.', currentVersion) }
        local lv = { string.strsplit('.', latestVersion) }

        for i = 1, #cv do
            local current, minimum = tonumber(cv[i]), tonumber(lv[i])

            if current ~= minimum then
                if current < minimum then
                    return bridge.logger:inform(('^3An update is available for %s (current version: %s)\r\n%s^7'):format(resource, currentVersion, response.html_url))
                else
                    break
                end
            end
        end
	end
end

return version
