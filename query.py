import os 

os.system("es2csv -q 'StationMAC: exists, ESSID exists, BSSID exists' -o wifilogs.csv")
os.system("""es2csv -q event_id:"8000" OR event_id"11000" OR event_id:"11001" OR event_id:"11010" OR event_id:"11005" OR event_id:"8001" -o eventssearch.csv""")os.system("""es2csv -q 'event_data.LocalMac: exists, event_id: exists, message:"SSID" -o winlogs.csv""")

