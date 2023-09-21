import os

#cmd = "hyprctl workspaces -j | jq 'map({key: .id | tostring, value: .windows}) | from_entries'"

#workspaces = os.popen(cmd)

#cmd = f"seq 1 10 | jq --argjson windows {workspaces} --slurp -Mc 'map(tostring) | map({id: ., windows: ($windows[.]//0)})'"

cmd = "./get-workspaces_single"
workspaces = os.popen(cmd)

for i in workspaces:
    print(i)


print(type(workspaces))
