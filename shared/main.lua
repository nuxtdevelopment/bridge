bridge = {
    isServer = IsDuplicityVersion(),
    config = {
        lang = 'en',
        interface = {
            style = 'default'
        }
    }
}

-------------------------

bridge.logger = {}

function bridge.logger:inform(text)
    local formattedText = ('^5[INFORM]^7 %s'):format(text)

    print(formattedText)
end

function bridge.logger:success(text)
    local formattedText = ('^2[SUCCESS]^7 %s'):format(text)

    print(formattedText)
end

function bridge.logger:error(text)
    local formattedText = ('^1[ERROR]^7 %s'):format(text)

    print(formattedText)
end

-- todo: yorum satırları arasında kalan yeri buradan kaldırıp module olarak ekle.

exports('getObjects', function()
    return bridge
end)
