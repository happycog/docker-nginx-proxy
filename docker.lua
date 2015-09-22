local handle = io.popen("docker inspect -f '{{ .NetworkSettings.IPAddress }}' ".. ngx.var.host:gsub('.happycog.work', '') .." 2>&1")
local result = handle:read("*a")
handle:close()

if result:sub(0, 5) == 'Error' then
        handle = io.popen("docker inspect -f '{{ .NetworkSettings.IPAddress }}' ".. ngx.var.host:gsub('.happycog.work', '') .."_web_1 2>&1")
        result = handle:read("*a")
        handle:close()
end

if result:sub(0, 5) == 'Error' then
        ngx.status = 404
        ngx.header['Content-type'] = "text/html"
        ngx.say("domain not found")
        ngx.exit(ngx.HTTP_NOT_FOUND)
end

ngx.var.upstream = "http://".. result:gsub('%s+$', '') ..":".. ngx.var.server_port
