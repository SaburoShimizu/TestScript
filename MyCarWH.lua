require "lib.moonloader"
require "lib.sampfuncs"
SE = require 'lib.samp.events'
encoding = require "encoding"

encoding.default = 'CP1251'

script_version('1.1')

active = 1
actives = 0
dtd = nil
testupdate = 1
tag = '{FF0000}[MyCarWH]{FFFFFF} '

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampAddChatMessage('{FF0000}[MyCarWH] {FFFFFF}Загружено. Версия скрипта: {FF0000}' ..thisScript().version, - 1)
    sampRegisterChatCommand('getmycar', carsuka)
    sampRegisterChatCommand('delmycar', delcar)
    sampRegisterChatCommand('getmycarwh', carwh)
    sampRegisterChatCommand('testupdating', update)
    sampRegisterChatCommand('updatenah', updatenah)
    while true do
        wait(0)
        cars = getAllVehicles()
    end
end

function carsuka(sss)
    if sss ~= nil and sss ~= '' and sss ~= ' ' then
        sss = tonumber(sss)
        if active == 1 then
            for i = 1, #cars do
                local result, id = sampGetVehicleIdByCarHandle(cars[i])
                if id == sss then if actives == 0 then dtd = sampCreate3dText('Моё авто', 0xFFFF0000, 0, 0, 0, 99999, 0, - 1, sss) actives = 1
                    print(dtd)
                    local positionX, positionY, positionZ = getCarCoordinates(cars[i])
                    sampAddChatMessage(string.format(tag ..'Координаты машины: {FF0000}X: %d, Y: %d, Z: %d.', positionX, positionY, positionZ), - 1)
                else
                    sampAddChatMessage(tag ..'Метка уже была создана. Она была автоматически удаелна. Введите команду повторно', - 1) delcar() end
                end
            end
        end
	else
		sampAddChatMessage(tag ..'Ошибка! Вы не ввели ID автомобиля', -1)
    end
end

function carwh(sss)
    if sss ~= nil and sss ~= '' and sss ~= ' ' then
        sss = tonumber(sss)
        if active == 1 then
            for i = 1, #cars do
                local result, id = sampGetVehicleIdByCarHandle(cars[i])
                if id == sss then if actives == 0 then dtd = sampCreate3dText('Моё авто', 0xFFFF0000, 0, 0, 0, 99999, 1, - 1, sss) actives = 1
                    print(dtd)
                    local positionX, positionY, positionZ = getCarCoordinates(cars[i])
                    sampAddChatMessage(string.format(tag ..'Координаты машины: {FF0000}X: %d, Y: %d, Z: %d.', positionX, positionY, positionZ), - 1)
                else
                    sampAddChatMessage(tag ..'Метка уже была создана. Она была автоматически удаелна. Введите команду повторно', - 1) delcar() end
                end
            end
        end
	else
		sampAddChatMessage(tag ..'Ошибка! Вы не ввели ID автомобиля', -1)
    end
end

function delcar()
    sampDestroy3dText(dtd)
    actives = 0
end

function update()
    lua_thread.create(function()
        patch = getWorkingDirectory() .. '\\Ver.txt'
        if testupdate == 1 then downloadUrlToFile('https://github.com/SaburoShimizu/TestScript/raw/master/Version.txt', patch, _)
            print('скачало')
            wait(3000)
            file = io.open('moonloader\\Ver.txt', 'r')
            text = file:read('*a')
            if text:find('Ver = .+') then
                ver = text:match('Ver = (.+)')
                if ver > thisScript().version then sampAddChatMessage(tag ..'Обнаружено обновление. Для скачивания введите {FF0000}/updatenah', - 1) else sampAddChatMessage(tag ..'Обновлений не обнаружено', -1) end
            end
            file:close()
            os.remove(getWorkingDirectory() ..'\\Ver.txt')
        end
    end)
end

function updatenah()
    lua_thread.create(function()
        patch = getWorkingDirectory() .. '\\MyCarWH.lua'
        downloadUrlToFile('https://github.com/SaburoShimizu/TestScript/raw/master/MyCarWH.lua', patch, _)
        sampAddChatMessage(tag ..'Обновление началось. {FF0000}Скрипт перезагрузится автоматически', - 1)
        wait(3000)
        thisScript().reload()
    end)
end
