local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

func = Tunnel.getInterface("nav_teste")

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

local locais = {
	{ ['id'] = 1, ['x'] = 292.38, ['y'] = -609.61, ['z'] = 43.36 },
	--[[{ ['id'] = 2, ['x'] = 243.15, ['y'] = 224.75, ['z'] = 106.28 },
	{ ['id'] = 3, ['x'] = 246.53, ['y'] = 223.46, ['z'] = 106.28 },
	{ ['id'] = 4, ['x'] = 248.33, ['y'] = 222.87, ['z'] = 106.28 },
	{ ['id'] = 5, ['x'] = 251.79, ['y'] = 221.73, ['z'] = 106.28 },
	{ ['id'] = 6, ['x'] = 253.50, ['y'] = 221.07, ['z'] = 106.28 },]]
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k,v in pairs(locais) do
			local ped = PlayerPedId()
			local crds = GetEntityCoords(ped)
			local distance = GetDistanceBetweenCoords(crds,v.x,v.y,v.z,true)
			if distance <= 5 then
			DrawMarker(23,v.x,v.y,v.z-0.95,0,0,0,0,0,0,1.0,1.0,0.5,77,0,75,30,0,0,0,0)
				if distance <= 0.5 then
					drawTxt("Pressione [E] para acessar a central de investimentos",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						ToggleActionMenu()
					end
				end
			end
		end
	end
end)

local display = false

function ToggleActionMenu()

	SetDisplay(not display)
end

RegisterNetEvent('kraven:investNui')
AddEventHandler('kraven:investNui',function(source, id)
    print(print(func.checkPermission()))
    SetDisplay(not display)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    chat(data.error, {255,0,0})
    SetDisplay(false)
end)

RegisterNUICallback("sacar", function(data)
    func.sacarLucro()
    SetDisplay(false)
end)

RegisterNUICallback("comprar", function(data)
    TriggerServerEvent("Kraven:Investimentos2",data.text)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        saldo = func.checkSaldo()
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

function chat(str, color)
    TriggerEvent(
        'chat:addMessage',
        {
            color = color,
            multiline = true,
            args = {str}
        }
    )
end