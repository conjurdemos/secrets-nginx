-- just use a global table as a namespace so it's available in all handlers
shared_headers = {}

function shared_headers.init()
  -- check our shared memory to see if we've already loaded the variable id
  if ngx.shared.conjur:get("variable_id") then return end
  -- if not then read it from a file
  local fd, err = io.open("/vagrant/variable_id", "r")
  if not fd then error("error opening /vagrant/variable_id: " .. err) end
  local variable_id = fd:read('*l') -- reads a single line from the file
  fd:close()
  -- save it in shared memory so it's available to all nginx workers
  ngx.shared.conjur:set("variable_id", variable_id)
end

function shared_headers.rewrite()
  -- check to see if we have a fresh cached value for the variable
  local shared = ngx.shared.conjur
  local value = shared:get("variable_value")
  if not value then
    local variable_id = ngx.shared.conjur:get("variable_id")
    -- get the value by capturing the response from the conjur location
    -- by passing variable_id in the request context
    local response = ngx.location.capture('/conjur/core/variable',{
      ctx = {variable_id = variable_id}
    })
    if response.status >= 300 then error("unable to get variable value for " .. variable_id .. " status=" .. response.status) end
    value = response.body
    -- cache the value for 60 seconds
    shared:set("variable_value", value, 60)
  end
  -- store it in a request header to pass on to the backend service
  -- in real life you might want to base64 encode the value
  ngx.req.set_header("X-Conjur-Secret", value)
end

