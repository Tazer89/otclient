
-- public functions
function Game.createThingMenu(menuPosition, lookThing, useThing, creatureThing)
  local menu = createWidget('PopupMenu')
  
  if lookThing then
    menu:addOption('Look', function() Game.look(lookThing) end)
  end

  -- Open or Use, depending if thing is a container
  if useThing then
    if useThing:isContainer() then
      -- check for open in new window
      menu:addOption('Open', function() print('open') end)
    else
      if useThing:isMultiUse() then
        menu:addOption('Use with ...', function() print('use with...') end)
      else
        menu:addOption('Use', function() Game.use(useThing) end)
      end
    end
      
    if useThing:isRotateable() then
      menu:addOption('Rotate', function() Game.rotate(useThing) end)
    end
    
  end
  
  if lookThing and not lookThing:asCreature() and not lookThing:isNotMoveable() and lookThing:isPickupable() then
    menu:addSeparator()
    menu:addOption('Trade with ...', function() print('trade with') end)
  end
  
  -- check for move up
     
  if creatureThing then
    menu:addSeparator()
  
    if creatureThing:asLocalPlayer() then
      menu:addOption('Set Outfit', function() Game.openOutfitWindow() end)
    else
      local localPlayer = Game.getLocalPlayer()
      if localPlayer then
        if localPlayer:getAttackingCreature() ~= creatureThing then
          menu:addOption('Attack', function() Game.attack(creatureThing) end)
        else
          menu:addOption('Stop Attack', function() Game.cancelAttack() end)
        end
        
        if localPlayer:getFollowingCreature() ~= creatureThing then
          menu:addOption('Follow', function() Game.follow(creatureThing) end)
        else
          menu:addOption('Stop Follow', function() Game.cancelFollow() end)
        end
      end

      if creatureThing:asPlayer() then
        menu:addSeparator()
        menu:addOption('Message to ' .. creatureThing:getName(), function() print('message') end)
        menu:addOption('Add to VIP list', function() Game.addVip(creatureThing:getName()) end)
        menu:addOption('Ignore ' .. creatureThing:getName(), function() print('ignore') end)
        menu:addOption('Invite to Party', function() Game.inviteToParty(creatureThing:getId()) end)
      end
      
    end

    menu:addSeparator()
    menu:addOption('Copy Name', function() g_window.setClipboardText(creatureThing:getName()) end)
    
  end
  
  menu:display(menuPosition)
end