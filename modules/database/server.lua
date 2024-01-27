local database = {}

function database:createCollectionIfNotExist(name)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, filePath)

    if not collectionFile then
        SaveResourceFile(bridge.name, filePath, '[]')
        
        return true
    end
end

function database:insertTableToCollection(name, table)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, filePath)

    if collectionFile then
        local collectionData = json.decode(collectionFile)

        collectionData[#collectionData+1] = table

        SaveResourceFile(bridge.name, filePath, json.encode(collectionData, { indent = true }))

        return true
    end
end

function database:deleteTableToCollection(name, query)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, filePath)

    if collectionFile then
        local collectionData = json.decode(collectionFile)

        if query then
            local queryData = {}

            for key, value in pairs(collectionData) do
                local retval = true

                for k, v in pairs(query) do
                    if value[k] ~= v then
                        retval = false
                    end
                end

                if not retval then
                    queryData[#queryData+1] = value
                end
            end

            SaveResourceFile(bridge.name, filePath, json.encode(queryData, { indent = true }))

            return true
        end
    end
end

function database:updateTableToCollection(name, query, update)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, filePath)

    if collectionFile then
        local collectionData = json.decode(collectionFile)

        if query then
            for key, value in pairs(collectionData) do
                local retval = true

                for k, v in pairs(query) do
                    if value[k] ~= v then
                        retval = false
                    end
                end

                if retval then
                    for k, v in pairs(update) do
                        value[k] = v
                    end
                end
            end

            SaveResourceFile(bridge.name, filePath, json.encode(collectionData, { indent = true }))
            
            return true
        end
    end
end

function database:getTableToCollection(name, query)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, filePath)

    if collectionFile then
        local queryData = {}
        local collectionData = json.decode(collectionFile)

        if query then
            for key, value in pairs(collectionData) do
                local retval = true

                for k, v in pairs(query) do
                    if value[k] ~= v then
                        retval = false
                    end
                end

                if retval then
                    queryData[#queryData+1] = value
                end
            end
        else
            queryData = collectionData
        end

        return queryData
    end
end

return database
