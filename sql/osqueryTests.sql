SELECT address, mac, id.interface
FROM interface_details
AS id, interface_addresses
WHERE id.interface = ia.interface;

SELECT DISTINCT process.name, listening.port, process.pid
FROM processes AS process
JOIN listening_ports AS listening
ON process.pid = listening.pid
WHERE listening.address = '0.0.0.0'

SELECT address, mac, count(mac) AS mac_count FROM arp_cache GROUP BY mac HAVING count(mac) > 1;
