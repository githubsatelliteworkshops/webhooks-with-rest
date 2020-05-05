#!/usr/bin/env pwsh

$APP_CONTAINER = docker run --rm -it -d -p 3000 --name changelogger --mount type=bind,source="$(pwd)"/changelogger,target=/data/apps/changelogger changelogger:latest

$proxy_running = docker ps -q -f name=proxy
if(!$proxy_running)
{
  docker run -it -d -p 4040 --name proxy --link changelogger:http wernight/ngrok ngrok http http:3000
}

Start-Sleep -Seconds 3

$proxy_url = (docker port proxy 4040).Replace("0.0.0.0", "http://127.0.0.1")
$res = Invoke-WebRequest -Uri "$proxy_url/api/tunnels" -Headers @{"Content-Type" = "application/json"; "Accept" = "application/json"} -UseBasicParsing
$data = $res.Content | ConvertFrom-Json
$public_url = $data.tunnels[1].public_url

Get-Content -Path .\logo.txt -Encoding utf8

echo ""

echo "+-----------------------------------------------+"
Write-Host "| Your public url is: $public_url |" -ForegroundColor Green
echo "+-----------------------------------------------+"
echo ""
echo "This is the output of your web app."
echo "==================================="
echo ""
docker attach $APP_CONTAINER
