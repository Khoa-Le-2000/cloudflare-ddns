# cloudflare-ddns

## Update information of Cloudflare
### Get Zone ID
```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```
### Get Record ID
```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

## Add cron job
### Add `crontab` job
```bash
crontab -e
```
### Add job
```bash
*/1 * * * * /path/to/cf-ddns.sh >> /var/log/cf-ddns.log 2>&1
```
- `>>` => append to log file
- `2>&1` => include error messages (stderr) too
