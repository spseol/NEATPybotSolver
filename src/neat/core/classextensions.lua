if not ClassExtensionsDefined then

function property(class, propertyName, getterName, setterName, o, propertyValue, defaultValue)
	if type(propertyName) ~= "string" then
		error("Property name should be <string> got " .. type(propertyName))
	elseif type(getterName) ~= "string" and getterName ~= nil then
		error("Getter name should be <string> got " .. type(getterName))
	elseif type(setterName) ~= "string" and getterName ~= nil then
		error("Setter name should be <string> got " .. type(setterName))
	end

	if o ~= nil then
		o[propertyName] = propertyValue or (defaultValue or nil)
	end

	if getterName ~= nil then
		class[getterName] = function(obj)
			return obj[propertyName]
		end
	end

	if setterName ~= nil then
		class[setterName] = function(obj, v)
			obj[propertyName] = v
		end
	end
end

ClassExtensionsDefined = true
end