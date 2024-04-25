local database = {}

---@param name string
function database:createCollectionIfNotExist(name)
    if name and type(name) == 'string' then
        local filePath = ('collections/%s.json'):format(name)
        local collectionFile = LoadResourceFile(lib.name, filePath)

        if collectionFile then
            lib.logger:error('73472')
        else
            local data = '[]'

            SaveResourceFile(lib.name, filePath, data, #data)
        end
    else
        lib.logger:error('76542')
    end
end

---@param name string
---@param table table
function database:insertTableToCollection(name, table)
    if name and type(name) == 'string' then
        if table and type(table) == 'table' then
            local filePath = ('collections/%s.json'):format(name)
            local collectionFile = LoadResourceFile(lib.name, filePath)

            if collectionFile then
                local collectionData = json.decode(collectionFile)

                collectionData[#collectionData+1] = table

                local data = json.encode(collectionData, { indent = true })

                SaveResourceFile(lib.name, filePath, data, #data)
            else
                lib.logger:error('12043')
            end
        else
            lib.logger:error('25762')
        end
    else
        lib.logger:error('12373')
    end
end

---@param name string
---@param query table
function database:deleteTableToCollection(name, query)
    if name and type(name) == 'string' then
        if query and type(query) == 'table' then
            local filePath = ('collections/%s.json'):format(name)
            local collectionFile = LoadResourceFile(lib.name, filePath)

            if collectionFile then
                local collectionData = json.decode(collectionFile)
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

                local data = json.encode(queryData, { indent = true })

                SaveResourceFile(lib.name, filePath, data, #data)
            else
                lib.logger:error('50478')
            end
        else
            lib.logger:error('23478')
        end
    else
        lib.logger:error('766555')
    end
end

---@param name string
---@param query table
---@param update table
function database:updateTableToCollection(name, query, update)
    if name and type(name) == 'string' then
        if query and type(query) == 'table' then
            if update and type(update) == 'table' then
                local filePath = ('collections/%s.json'):format(name)
                local collectionFile = LoadResourceFile(lib.name, filePath)

                if collectionFile then
                    local collectionData = json.decode(collectionFile)

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

                    local data = json.encode(collectionData, { indent = true })

                    SaveResourceFile(lib.name, filePath, data, #data)
                else
                    lib.logger:error('00033')
                end
            else
                lib.logger:error('23409')
            end
        else
            lib.logger:error('32936')
        end
    else
        lib.logger:error('33442')
    end
end

---@param name string
---@param query table
---@return table?
function database:getTableToCollection(name, query)
    if name and type(name) == 'string' then
        if query and type(query) == 'table' then
            local filePath = ('collections/%s.json'):format(name)
            local collectionFile = LoadResourceFile(lib.name, filePath)

            if collectionFile then
                local queryData = {}
                local collectionData = json.decode(collectionFile)

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

                return queryData
            else
                lib.logger:error('23409')
            end
        else
            lib.logger:error('99354')
        end
    else
        lib.logger:error('71031')
    end
end

return database
