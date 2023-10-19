
local XDSDKHotfixer = Class("XDSDKHotfixer", HotfixBase)
local eutil = CS.Torappu.Lua.Util

local function _TryInjectSettings(self, options)
  self:TryInjectSettings(options)

  local feedback = CS.Torappu.SDK.InjectSettingFeedbacks()
  local list_disableCategories = CS.System.Collections.Generic.List(CS.Torappu.UI.Setting.SettingCategory)
  local lst = list_disableCategories()
  lst:Add(CS.Torappu.UI.Setting.SettingCategory.OTHERS)
  feedback.disableCategories = lst

  if options.feedback ~= nil then
    options.feedback(feedback)
  end
end

function XDSDKHotfixer:OnInit()
  xlua.private_accessible(CS.XDSDK.XDSDK)
  self:Fix_ex(CS.XDSDK.XDSDK, "TryInjectSettings",
    function(self, options)
      local ok, errorInfo = xpcall(_TryInjectSettings, debug.traceback, self, options)
      if not ok then
        eutil.LogError("[XDSDKHotfixer] TryInjectSettings fix" .. errorInfo)
      end
    end
  )
end

function XDSDKHotfixer:OnDispose()
end

return XDSDKHotfixer