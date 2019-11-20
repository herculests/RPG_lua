local FPV = {}

local FPV = {}
FPV.__index = FPV

function FPV:new()
  
  local fpv = {
    
    atributos = {

    }
    
  }
  setmetatable(fpv, FPV)
  return fpv
    
end