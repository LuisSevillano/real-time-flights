WAITFOR=2
TIMESTAMP="$(date +"%d-%m-%Y-%H-%M-%S")"
TOKEN=32d57f45d9ddfbc3ffa3993160c84f192b262337
mkdir -p data
mkdir "data/$TIMESTAMP"

curl 'https://www.flightaware.com/ajax/vicinity_aircraft.rvt?&minLon=-180&maxLon=0&minLat=-90&maxLat=0&token=${TOKEN}' \
  -H 'accept: */*' \
  -H 'accept-language: es,en;q=0.9,fr;q=0.8,gl;q=0.7,it;q=0.6' \
  -H 'cache-control: no-cache' \
  -H 'cookie: _cfuvid=psRcH5ciceX_DiEc39JV62KLxPxVTyc0rt1VFo1QblE-1721376908421-0.0.1.1-604800000; OptanonAlertBoxClosed=2024-07-19T08:15:12.341Z; eupubconsent-v2=CQB_6PAQB_6PAAcABBENA7EgAAAAAAAAACiQAAAAAAAA.YAAAAAAAAAAA; __cf_bm=NZZYVjyvcOU8DI_kjbarCevLmN6.kyEEMbeSAxdLvY4-1721378151-1.0.1.1-.d5LyfQnKkxLs4XuCvXUsEWH9C5rm5Fd_6_NxgngKpXbtjHLY.g8x8AqSOLiDjmgo6R82YHOJjOdYQJWhFFEPg; OptanonConsent=isGpcEnabled=0&datestamp=Fri+Jul+19+2024+10%3A36%3A04+GMT%2B0200+(hora+de+verano+de+Europa+central)&version=202403.1.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=a22816d3-c752-4f9d-828b-b63680e0556c&interactionCount=1&isAnonUser=1&landingPath=NotLandingPage&groups=C0002%3A0%2CC0001%3A1%2CC0004%3A0%2CV2STACK42%3A0&geolocation=ES%3BCL&AwaitingReconsent=false' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://www.flightaware.com/live/' \
  -H 'sec-ch-ua: "Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' \
  > "data/${TIMESTAMP}/all_bottom_left.geojson"

echo "Sleeping for ${WAITFOR} seconds"
sleep $WAITFOR

curl 'https://www.flightaware.com/ajax/vicinity_aircraft.rvt?&minLon=-180&maxLon=0&minLat=90&maxLat=0&token=${TOKEN}' \
  -H 'accept: */*' \
  -H 'accept-language: es,en;q=0.9,fr;q=0.8,gl;q=0.7,it;q=0.6' \
  -H 'cache-control: no-cache' \
  -H 'cookie: _cfuvid=psRcH5ciceX_DiEc39JV62KLxPxVTyc0rt1VFo1QblE-1721376908421-0.0.1.1-604800000; OptanonAlertBoxClosed=2024-07-19T08:15:12.341Z; eupubconsent-v2=CQB_6PAQB_6PAAcABBENA7EgAAAAAAAAACiQAAAAAAAA.YAAAAAAAAAAA; __cf_bm=NZZYVjyvcOU8DI_kjbarCevLmN6.kyEEMbeSAxdLvY4-1721378151-1.0.1.1-.d5LyfQnKkxLs4XuCvXUsEWH9C5rm5Fd_6_NxgngKpXbtjHLY.g8x8AqSOLiDjmgo6R82YHOJjOdYQJWhFFEPg; OptanonConsent=isGpcEnabled=0&datestamp=Fri+Jul+19+2024+10%3A36%3A04+GMT%2B0200+(hora+de+verano+de+Europa+central)&version=202403.1.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=a22816d3-c752-4f9d-828b-b63680e0556c&interactionCount=1&isAnonUser=1&landingPath=NotLandingPage&groups=C0002%3A0%2CC0001%3A1%2CC0004%3A0%2CV2STACK42%3A0&geolocation=ES%3BCL&AwaitingReconsent=false' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://www.flightaware.com/live/' \
  -H 'sec-ch-ua: "Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' \
  > "data/${TIMESTAMP}/all_top_left.geojson"

echo "Sleeping for ${WAITFOR} seconds"
sleep $WAITFOR

curl 'https://www.flightaware.com/ajax/vicinity_aircraft.rvt?&minLon=0&maxLon=180&minLat=0&maxLat=90&token=${TOKEN}' \
  -H 'accept: */*' \
  -H 'accept-language: es,en;q=0.9,fr;q=0.8,gl;q=0.7,it;q=0.6' \
  -H 'cache-control: no-cache' \
  -H 'cookie: _cfuvid=psRcH5ciceX_DiEc39JV62KLxPxVTyc0rt1VFo1QblE-1721376908421-0.0.1.1-604800000; OptanonAlertBoxClosed=2024-07-19T08:15:12.341Z; eupubconsent-v2=CQB_6PAQB_6PAAcABBENA7EgAAAAAAAAACiQAAAAAAAA.YAAAAAAAAAAA; __cf_bm=NZZYVjyvcOU8DI_kjbarCevLmN6.kyEEMbeSAxdLvY4-1721378151-1.0.1.1-.d5LyfQnKkxLs4XuCvXUsEWH9C5rm5Fd_6_NxgngKpXbtjHLY.g8x8AqSOLiDjmgo6R82YHOJjOdYQJWhFFEPg; OptanonConsent=isGpcEnabled=0&datestamp=Fri+Jul+19+2024+10%3A36%3A04+GMT%2B0200+(hora+de+verano+de+Europa+central)&version=202403.1.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=a22816d3-c752-4f9d-828b-b63680e0556c&interactionCount=1&isAnonUser=1&landingPath=NotLandingPage&groups=C0002%3A0%2CC0001%3A1%2CC0004%3A0%2CV2STACK42%3A0&geolocation=ES%3BCL&AwaitingReconsent=false' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://www.flightaware.com/live/' \
  -H 'sec-ch-ua: "Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' \
  > "data/${TIMESTAMP}/all_top_right.geojson"

echo "Sleeping for ${WAITFOR} seconds"
sleep $WAITFOR

curl 'https://www.flightaware.com/ajax/vicinity_aircraft.rvt?&minLon=0&maxLon=180&minLat=0&maxLat=-90&token=${TOKEN}' \
  -H 'accept: */*' \
  -H 'accept-language: es,en;q=0.9,fr;q=0.8,gl;q=0.7,it;q=0.6' \
  -H 'cache-control: no-cache' \
  -H 'cookie: _cfuvid=psRcH5ciceX_DiEc39JV62KLxPxVTyc0rt1VFo1QblE-1721376908421-0.0.1.1-604800000; OptanonAlertBoxClosed=2024-07-19T08:15:12.341Z; eupubconsent-v2=CQB_6PAQB_6PAAcABBENA7EgAAAAAAAAACiQAAAAAAAA.YAAAAAAAAAAA; __cf_bm=NZZYVjyvcOU8DI_kjbarCevLmN6.kyEEMbeSAxdLvY4-1721378151-1.0.1.1-.d5LyfQnKkxLs4XuCvXUsEWH9C5rm5Fd_6_NxgngKpXbtjHLY.g8x8AqSOLiDjmgo6R82YHOJjOdYQJWhFFEPg; OptanonConsent=isGpcEnabled=0&datestamp=Fri+Jul+19+2024+10%3A36%3A04+GMT%2B0200+(hora+de+verano+de+Europa+central)&version=202403.1.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=a22816d3-c752-4f9d-828b-b63680e0556c&interactionCount=1&isAnonUser=1&landingPath=NotLandingPage&groups=C0002%3A0%2CC0001%3A1%2CC0004%3A0%2CV2STACK42%3A0&geolocation=ES%3BCL&AwaitingReconsent=false' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://www.flightaware.com/live/' \
  -H 'sec-ch-ua: "Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' \
  > "data/${TIMESTAMP}/all_bottom_right.geojson"