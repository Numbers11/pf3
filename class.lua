function Class(name, ...)
  -- "cls" is the new class
  local cls, bases = {}, {...}

  -- copy base class contents into the new class
  for i, base in ipairs(bases) do
      for k, v in pairs(base) do
          cls[k] = v
      end
  end

  cls.class = name
  cls.__index = cls

  -- the class's __call metamethod
  setmetatable(cls, {
      __call = function(c, ...)
          local instance = setmetatable({}, c)
          -- run the init method if it's there
          local init = instance.init

          if init then
              init(instance, ...)
          end

          return instance
      end
  })
  -- return the new class table, that's ready to fill with methods

  return cls
end