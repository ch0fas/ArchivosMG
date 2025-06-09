WITH "https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/social-nodes.csv" AS uri
LOAD CSV WITH HEADERS FROM uri AS row
MERGE (:User {id: row.id})

WITH "https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/social-relationships.csv" AS uri
LOAD CSV WITH HEADERS FROM uri AS row
MATCH (source:User {id: row.src})
MATCH (destination:User {id: row.dst})
MERGE (source)-[:FOLLOWS]->(destination)
