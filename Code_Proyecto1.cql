// Código - Proyecto 1

// Insertar datos originales
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/characters.csv' AS row
CREATE (c:Chatacter)
SET c.name = row.character
SET c.species = row.species

