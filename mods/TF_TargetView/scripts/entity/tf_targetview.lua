-- if not onClient() then return; end

local tf_window = nil
local tf_list = nil
local tf_target_mapping = {}

-- Don't remove or alter the following comment, it tells the game the namespace this script lives in. If you remove it, the script will break.
-- namespace TargetView

TargetView = {}

function TargetView.updateTargets()
    tf_target_mapping = {}
    tf_list:clear()

    local items = {}
    items.gates = {
        count = 1,
        names = {}
    }
    items.ships = {
        count = 1,
        names = {}
    }
    items.stations = {
        count = 1,
        names = {}
    }

    for index, entity in pairs({Sector():getEntities()}) do
        if entity.type == EntityType.None then
            if entity.title and string.find(entity.title, "Gate") then
                local key = string.format("%3d: ",items.gates.count) .. entity.title
                items.gates.names[items.gates.count] = key
                tf_target_mapping[key] = entity
                items.gates.count = items.gates.count + 1
            end
        elseif entity.type == EntityType.Station then
            local title_args = entity:getTitleArguments()
            if entity.title and title_args then
                local key = string.format("%3d: ", items.stations.count) .. (entity.title % title_args)
                items.stations.names[items.stations.count] = key
                tf_target_mapping[key] = entity
                items.stations.count = items.stations.count + 1
            end
        elseif entity.type == EntityType.Ship then
            if entity.title and (entity.index ~= Player().craftIndex) then
                local str = string.gsub(entity.title, "/. ship title ./", entity.name)
                local title_args = entity:getTitleArguments()
                if title_args then
                    str = str % title_args
                end
                local key = string.format("%3d: ", items.ships.count) .. str
                items.ships.names[items.ships.count] = key
                tf_target_mapping[key] = entity
                items.ships.count = items.ships.count + 1
            end
        end
    end

    tf_list:addEntry("[ Gates ]")
    tf_target_mapping["[ Gates ]"] = nil
    for _, key in pairs(items.gates.names) do
        tf_list:addEntry(key)
    end
    tf_list:addEntry("[ Stations ]")
    tf_target_mapping["[ Stations ]"] = nil
    for _, key in pairs(items.stations.names) do
        tf_list:addEntry(key)
    end
    tf_list:addEntry("[ Ships ]")
    tf_target_mapping["[ Ships ]"] = nil
    for _, key in pairs(items.ships.names) do
        tf_list:addEntry(key)
    end
end

function TargetView.getIcon()
    return "data/textures/icons/computer.png"
end

function TargetView.interactionPossible(playerIndex, option)
    return true, ""
end

function TargetView.initialize()
    print("DBG -> [TargetView:initialize]: Entered")
end

function TargetView.initUI()
    print("DBG -> [TargetView:initUI]: Entered")

    local menu = ScriptUI()
    local resolution = getResolution()
    local window_size = vec2(resolution.y * (2 / 3) * 0.5, resolution.y * 0.5)

    tf_window = menu:createWindow(Rect(resolution * 0.5 - window_size * 0.5, resolution * 0.5 + window_size * 0.5))
    menu:registerWindow(tf_window, "Target View"%_t)

    tf_window.caption = "Target View"%_t
    tf_window.showCloseButton = 1
    tf_window.moveable = 1
    tf_window.closeableWithEscape = 1

    tf_list = tf_window:createListBox(Rect(vec2(0,0), tf_window.rect.size))
    tf_list.onSelectFunction = "onSelectionPressed"
    -- tf_list.font = FontType.Normal
end

function TargetView.onSelectionPressed()
    print("DBG -> [TargetView:onSelectioNpressed]: Entered")
    local player = Player()
    local entry = tf_list:getSelectedEntry()
    player.selectedObject = tf_target_mapping[entry]
end

function TargetView.onShowWindow()
    print("DBG -> [TargetView:onShowWindow]: Entered")
    TargetView.updateTargets()
end
