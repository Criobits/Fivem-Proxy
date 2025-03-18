# Fivem-Proxy
Handy script to install nginx as a proxy for your FiveM/RedM server.

## Requirements
- Debian linux distribution (Tested on debian 10/11/12) - minimal only (not a self installed variant)
- Root access
- A domain name
- A FiveM/RedM server

## Installation
1. Clone this repo
2. Make it executable: `chmod +x fivem-nginx-proxy-install.sh`
3. Run it: `./fivem-nginx-proxy-install.sh`

## Usage
1. Follow the instructions
2. Append the following into your sv.cfg
3. Enjoy your new proxy!

## Common issue on debian 12 and ubuntu 20.04
If your nginx errors out and gives an output stating that it could not rebind ports to 30120, instead of running `sudo systemctl restart nginx` run `sudo pkill -f nginx & wait $!` then `sudo systemctl start nginx`

## Credits
- [Nginx](https://nginx.org/)
- [Certbot](https://certbot.eff.org/)
- [Let's Encrypt](https://letsencrypt.org/)
- [FiveM](https://fivem.net/)
- [RedM](https://redm.gg/)
- [MathiAs2Pique](https://github.com/MathiAs2Pique) - Original author of the script
- [s1c-za](https://github.com/s1c-za) - Original author of the QoL edits

## Additional notes
- I personnaly recommend to use CloudFlare: DNS, Proxy and Edge Cache are really useful.
- Please do not use the built-in nginx cache, as it's a mess if you want to udpate your scripts, and it would cost you a lot more than CloudFlare.
- If you have your own SSL certificate, then just check web.conf to edit what needs to be edited.
- If you want to use a custom port, then just check web.conf to edit what needs to be edited.
- A **single** proxy is **not useful at all** as a DDoS protection, but it can be useful to hide your IP address.
