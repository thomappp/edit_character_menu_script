local MainMenu = RageUI.CreateMenu("Personnages", "Modifier mon personnage");
local PlayerWait = 1000
local CanChange = true

local index = {}

for _, ped in pairs(Peds) do
    index[ped.category] = 1
end

local ChangePed = function(ped)

	local model = GetHashKey(ped)
	if IsModelInCdimage(model) and IsModelValid(model) then

		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)

		Citizen.CreateThread(function()
			CanChange = false
			Citizen.Wait(PlayerWait)
			CanChange = true
		end)
	end
end

function RageUI.PoolMenus:MainMenu()
    MainMenu:IsVisible(function(Items)

		for _, ped in pairs(Peds) do

			Items:AddList(ped.categoryLabel, ped.models, index[ped.category], ('Personnage %s/%s'):format(index[ped.category], #ped.models), { IsDisabled = not CanChange }, function(Index, onSelected, onListChange)
				if (onListChange) then
					index[ped.category] = Index;
				end
				if (onSelected) then
					ChangePed(ped.models[index[ped.category]])
				end
			end)
		end
	end, function()
	end)
end

Keys.Register("F10", "F10", "Menu personnage", function()
	RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
end)

RegisterCommand('setped', function(source, args)
	local model = args[1]
	if model then
		ChangePed(model)
	end
end)