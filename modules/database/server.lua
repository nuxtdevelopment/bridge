local database = {}

function database:createCollectionIfNotExist(name)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(GetCurrentResourceName(), filePath)

    if not collectionFile then
        SaveResourceFile(GetCurrentResourceName(), filePath, '[]')
        
        return true
    end

    return false
end

function database:insertTableToCollection(name, table)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(GetCurrentResourceName(), filePath)

    if collectionFile then
        local collectionData = json.decode(collectionFile)

        collectionData[#collectionData+1] = table

        SaveResourceFile(GetCurrentResourceName(), filePath, json.encode(collectionData))

        return true
    end

    return false
end

function database:deleteTableToCollection(name, query)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(GetCurrentResourceName(), filePath)

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

            SaveResourceFile(GetCurrentResourceName(), filePath, json.encode(queryData))

            return true
        end
    end

    return false
end

function database:updateTableToCollection(name, query, update)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(GetCurrentResourceName(), filePath)

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

            SaveResourceFile(GetCurrentResourceName(), filePath, json.encode(collectionData))
            
            return true
        end
    end

    return false
end

function database:getTableToCollection(name, query)
    local filePath = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(GetCurrentResourceName(), filePath)

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

    return false
end

return database
