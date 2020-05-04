#!/usr/bin/env pwsh

start (docker port proxy 4040).Replace("0.0.0.0", "http://127.0.0.1")
