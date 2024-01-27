local logger = {}

function logger:inform(text)
    local formattedText = ('^5[INFORM]^7 %s'):format(text)

    print(formattedText)
end

function logger:success(text)
    local formattedText = ('^2[SUCCESS]^7 %s'):format(text)

    print(formattedText)
end

function logger:error(text)
    local formattedText = ('^1[ERROR]^7 %s'):format(text)

    print(formattedText)
end

return logger
