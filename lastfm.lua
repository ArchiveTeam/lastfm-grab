dofile("urlcode.lua")
dofile("table_show.lua")

local url_count = 0
local tries = 0
local item_type = os.getenv('item_type')
local item_value = os.getenv('item_value')

local downloaded = {}
local addedtolist = {}

read_file = function(file)
  if file then
    local f = assert(io.open(file))
    local data = f:read("*all")
    f:close()
    return data
  else
    return ""
  end
end

wget.callbacks.download_child_p = function(urlpos, parent, depth, start_url_parsed, iri, verdict, reason)
  local url = urlpos["url"]["url"]
  local html = urlpos["link_expect_html"]
  
  if downloaded[url] == true or addedtolist[url] == true then
    return false
  end
  
  if item_type == "forum" and (downloaded[url] ~= true or addedtolist[url] ~= true) then
    if string.match(url, "/"..item_value.."[0-9][0-9][0-9]") then
      if not string.match(url, "/"..item_value.."[0-9][0-9][0-9][0-9]") then
        addedtolist[url] = true
        return true
      else
        return false
      end
    elseif html == 0 then
      return true
    else
      return false
    end
  end
  
end


wget.callbacks.get_urls = function(file, url, is_css, iri)
  local urls = {}
  local html = nil
  
  local function check(url)
    if (downloaded[url] ~= true and addedtolist[url] ~= true) and not string.match(url, "/static/") then
      table.insert(urls, { url=url })
      addedtolist[url] = true
    end
  end
  
  if item_type == "forum" then
    if string.match(url, "/"..item_value) then
      html = read_file(file)
      for newurl in string.gmatch(html, '"(/[^"]+)"') do
        if (string.match(newurl, "/"..item_value.."[0-9][0-9][0-9]/") and not string.match(newurl, "/[0-9]+/_/[0-9]+/_/[0-9]+")) then
          local newurl1 = "http://www.last.fm"..newurl
          check(newurl1)
        elseif string.match(newurl, "/[0-9]+/_/[0-9]+/_/[0-9]+") then
          local newurl2 = string.match(url, "(/.+[0-9]+/_/[0-9]+)/_/")
          local newurl1 = "http://www.last.fm"..newurl2
          check(newurl1)
        end
      end
      if string.match(url, "[0-9]+/_/[0-9]+") then
        local newurl = string.match(url, "(https?://.+[0-9]+/_/[0-9]+)")
        check(newurl)
      end
      for newurl in string.gmatch(html, '"(https?://[^"]+)"') do
        if string.match(newurl, "%.jpg") or string.match(newurl, "%.png") or string.match(newurl, "%.js") then
          check(newurl)
        end
      end
    end
  end
  
  return urls
end
  

wget.callbacks.httploop_result = function(url, err, http_stat)
  -- NEW for 2014: Slightly more verbose messages because people keep
  -- complaining that it's not moving or not working
  local status_code = http_stat["statcode"]
  
  url_count = url_count + 1
  io.stdout:write(url_count .. "=" .. status_code .. " " .. url["url"] .. ".  \n")
  io.stdout:flush()
  
  if (status_code >= 200 and status_code <= 399) or status_code == 403 then
    if string.match(url.url, "https://") then
      local newurl = string.gsub(url.url, "https://", "http://")
      downloaded[newurl] = true
    else
      downloaded[url.url] = true
    end
  end
  
  if (status_code == 0 or status_code >= 500 or (status_code >= 400 and status_code ~= 404 and status_code ~= 403)) and not string.match(url, "last%.fm") then    
    io.stdout:write("Url skipped "..http_stat.statcode..". \n")
    io.stdout:flush()
    return wget.actions.EXIT
  elseif status_code >= 500 or
    (status_code >= 400 and status_code ~= 404 and status_code ~= 403) then
    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()

    os.execute("sleep 1")

    tries = tries + 1

    if tries >= 20 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      return wget.actions.ABORT
    else
      return wget.actions.CONTINUE
    end
  elseif status_code == 0 then
    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()

    os.execute("sleep 10")
    
    tries = tries + 1

    if tries >= 10 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      return wget.actions.ABORT
    else
      return wget.actions.CONTINUE
    end
  end

  tries = 0

  -- We're okay; sleep a bit (if we have to) and continue
  -- local sleep_time = 0.1 * (math.random(75, 1000) / 100.0)
  local sleep_time = 0

  --  if string.match(url["host"], "cdn") or string.match(url["host"], "media") then
  --    -- We should be able to go fast on images since that's what a web browser does
  --    sleep_time = 0
  --  end

  if sleep_time > 0.001 then
    os.execute("sleep " .. sleep_time)
  end

  return wget.actions.NOTHING
end
