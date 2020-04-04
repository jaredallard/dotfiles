#!/usr/bin/env python3
 
import i3
import random

outputs = i3.get_outputs()
workspaces = i3.get_workspaces()

# figure out what is on, and what is currently on your screen.
workspace = list(filter(lambda s: s['focused']==True, workspaces))
output = list(filter(lambda s: s['active']==True, outputs))

# figure out the other workspaces name
other_workspaces = list(filter(lambda s: s['name']!=workspace[0]['output'], output))

# pick a random workspace to put it onto, that's not the current one. (TODO: store / track the last ones we moved it onto)
num_of_workspaces = len(other_workspaces)
random_workspace = random.randint(0, num_of_workspaces-1)

# send current to the no-active one
i3.command('move', 'workspace to output '+other_workspaces[random_workspace]['name'])
