local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

vRP.prepare("vRP/bolsaInitUser","INSERT IGNORE INTO vrp_kraven_investimento(user_id) VALUES(@user_id)")
vRP.prepare("vRP/adcionaValor","UPDATE vrp_kraven_investimento SET valor = @valor, tempo1 = @tempo1 WHERE user_id = @user_id")
vRP.prepare("vRP/attSaque","UPDATE vrp_kraven_investimento SET tempo2 = @tempo2 WHERE user_id = @user_id")
vRP.prepare("vRP/checarBolsa","SELECT valor, tempo1, tempo2 FROM vrp_kraven_investimento WHERE user_id = @user_id")

func = {}
Tunnel.bindInterface("nav_teste",func)

AddEventHandler("vRP:playerJoin",function(user_id,source,name)
    vRP.execute("vRP/bolsaInitUser",{ user_id = user_id })
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        local rows = vRP.query("vRP/checarBolsa",{ user_id = user_id })
        if #rows > 0 then
            tmp.valor = rows[1].valor
        end
    end
end)

function func.checkSaldo()
	local source = source
    local user_id = vRP.getUserId(source)
    local rows = vRP.query("vRP/checarBolsa",{ user_id = user_id })
	local saldo = rows[1].valor
	return saldo
end

function func.sacarLucro()
	local source = source
    local user_id = vRP.getUserId(source)
    local rows = vRP.query("vRP/checarBolsa",{ user_id = user_id })
    local saldo = rows[1].valor
    local tempo2 = rows[1].tempo2
    if user_id then
        if saldo > 0 then
            if parseInt(os.time()) >= parseInt(tempo2+20*60*60) then
                vRP.giveBankMoney(user_id,parseInt(saldo*0.05))
                TriggerClientEvent("Notify",source,"sucesso","Você efetuou um saque no valor de "..parseInt(saldo*0.05)..", o valor foi depositado em sua conta!" )
                vRP.execute("vRP/attSaque",{ user_id = user_id, tempo2 = parseInt(os.time()) })
            else
                TriggerClientEvent("Notify",source,"negado","Você não pode efetuar um saque agora, volte amanhã." )
            end
        else
            TriggerClientEvent("Notify",source,"negado","Você ainda não fez nenhum investimento." )
        end
    end
end

RegisterServerEvent('Kraven:Investimentos2')
AddEventHandler('Kraven:Investimentos2', function(valor)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local rows = vRP.query("vRP/checarBolsa",{ user_id = user_id })
        local saldo = rows[1].valor
        local tempo1 = rows[1].tempo1
        if parseInt(os.time()) >= parseInt(tempo1+30*24*60*60) then
            if parseInt(valor) > parseInt(0) then
                if vRP.tryFullPayment(user_id,parseInt(valor)) then
                    vRP.execute("vRP/adcionaValor",{ user_id = user_id, valor = parseInt(saldo+valor), tempo1 = parseInt(os.time()) })
                    TriggerClientEvent("Notify",source,"sucesso","Boa garoto, você acabou de investir "..parseInt(valor)..", aguarde um tempo para obter lucros, ou não." )
                else
                    TriggerClientEvent("Notify",source,"negado","Você não tem este dinhiero, vá trabalhar, vagabundo!")
                end
            else
                TriggerClientEvent("Notify",source,"negado","Valor precisa ser maior do que 0 para poder investir")
            end
        else
            TriggerClientEvent("Notify",source,"negado","Você só pode investir uma vez a cada 30 dias" )
        end
    end
end)