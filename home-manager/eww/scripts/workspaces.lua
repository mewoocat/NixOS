#!/usr/bin/env lua

function trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

aw = io.popen("hyprctl monitors | grep active | sed 's/()/(1)/g' | sort | awk 'NR>1{print $1}' RS='(' FS=')'")
active_workspace = aw:read("*a")
aw:close()

ew = io.popen("hyprctl workspaces | grep ID | sed 's/()/(1)/g' | sort | awk 'NR>1{print $1}' RS='(' FS=')'")
existing_workspaces = ew:read("*a")
ew:close()

WORKSPACE_WINDOWS = io.popen("hyprctl workspaces -j | jq 'map({key: .id | tostring, value: .windows}) | from_entries'")
ww = WORKSPACE_WINDOWS:read("*a")
WORKSPACE_WINDOWS:close()

all_workspace = io.popen(" seq 1 10 | jq --argjson windows ".. ww .." --slurp -Mc 'map(tostring) | map({id: ., windows: ($windows[.]//0)})'")
all = all_workspace:read("*a")
all_workspace:close()

box = "(box :orientation \"h\" :spacing 1 :space-evenly \"true\" "

for i = 1, #existing_workspaces do
    local c = existing_workspaces:sub(i,i)
    if tonumber(c) == tonumber(active_workspace) then
        local btn = "(button :class \"ws-but current\" :onclick \"hyprctl dispatch workspace "..c.." \" \"\")"
        box = box .. btn
    elseif c ~= "\n" then
        local btn = "(button :class \"ws-but empty\" :onclick \"hyprctl dispatch workspace "..c.."\" \"\")"
        box = box .. btn
    end
end

box = box .. ")"

print(box)
