local DOCKER_HOST = os.getenv("DOCKER_HOST")

local handle = io.popen("docker -H ".. DOCKER_HOST .." ps --filter \"label=host.".. ngx.var.host .."=enabled\"  | awk '{if(NR>1)print}' | awk '{print $(NF)}' 2>&1")
local containerName = handle:read("*a"):gsub("\n", "")
handle:close()

if containerName then
  ngx.var.upstream = "http://".. containerName ..":".. ngx.var.server_port
else
  ngx.status = 404
  ngx.header['Content-type'] = "text/html"
  ngx.say("domain not found")
  ngx.exit(ngx.HTTP_NOT_FOUND)
end
