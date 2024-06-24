Config = {}

Config.PromptKey = 0xCEFD9220

--[[ ------------------------------------------------
   Locations
]]---------------------------------------------------

Config.Locations = { 

    {
        PromptFooterLabel = "Clothing Store", 
      
        EnterCoords = {x = -296.012, y = 800.5844, z = 118.28, h = 197.02},   -- Position of enter prompt and enter spawn
        ExitCoords  = {x = -296.287, y = 801.9831, z = 118.26, h = 12.45}, -- Position of exit prompt and exit spawn
       
        TeleportActionDistance = 1.2,

        Jobs = false,    -- Jobs to enter {"job1","job2"} , or false for no job.

    },

    {
        PromptFooterLabel = "Valentine Church",
      
        EnterCoords = {x = -231.671, y = 796.5175, z = 123.62, h = 126.43},   -- Position of enter prompt and enter spawn
        ExitCoords  = {x = -231.183, y = 800.2444, z = 125.03, h = 33.55}, -- Position of exit prompt and exit spawn
       
        TeleportActionDistance = 1.3,

        Jobs = false,    -- Jobs to enter {"job1","job2"} , or false for no job.
    },

}
