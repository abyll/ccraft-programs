--Autoplay DJ
lengths = {
["C418 - 13"]=178,
["C418 - cat"]=185,
["C418 - blocks"]=345,
["C418 - chirp"]=185,
["C418 - far"]=174,
["C418 - mall"]=197,
["C418 - mellohi"]=96,
["C418 - stal"]=150,
["C418 - strad"]=183,
["C418 - ward"]=251,
["C418 - 11"]=71,
["C418 - wait"]=238,
["Valve - Still Alive"]=185,
["Valve - Radio Loop"]=22,
["Valve - Want You Gone"]=150,
["???"]=179,
["Tim Wurkowski - Wanderer"]=255,
}

args = { ... }
if #args == 0 then
  print("Usage: autoplay <side>")
  return
end
side = args[1]

while true do
  if disk.isPresent(side) then
    if disk.hasAudio(side) then
      print("Playing ", disk.getAudioTitle(side))
      local length = lengths[disk.getAudioTitle(side)]
      if length == nil then -- not known, so replay after 5 mins.
        length = 300
      end
      disk.playAudio(side) -- first play, before it loops.
      local timer = os.startTimer(length)
      while true do
        local evt, arg = os.pullEvent()
        if evt == "disk_eject" then
          if arg == side then
            print("Disk ejected")
            break
          end
          elseif evt == "timer" then
          if arg == timer then
            disk.playAudio(side)
            timer = os.startTimer(length)
          end
        end
      end
    else
      print("Disk in ".. side .. " disk is not an audio disk")
    end
  else
    print("No disk in ".. side .. " disk")
    while true do -- Idle until a new disk is inserted to the music drive
      local evt, arg = os.pullEvent("disk")
      if arg == side then -- Ignore non music drives
        break
      end
    end
  end
end