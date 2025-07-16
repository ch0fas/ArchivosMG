// Código Examen 2
// Sofía Maldonado García
// 16/07/2025

//1
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/productos_carpinteria.csv' AS row
CREATE (p:Producto)
SET p.id = row.IdProducto
SET p.nombre = row.Nombre

LOAD CSV FROM 'https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/compras_conjuntas.csv' AS row
MATCH (source:Producto {id:row[0]})
MATCH (target:Producto {id:row[1]})
MERGE (source)-[:COMPRA_CONJUNTA {weight:toInteger(row[2])}]->(target);

//2
call db.schema.visualization

//3
MATCH (p:Producto {nombre:'Tornillo de banco giratorio'})-[*1..2]-(m)
RETURN p,m;

//4
CALL gds.graph.project(
    'myUndirectedGraph', // Nombre del sub grafo
    'Producto', // Tipos de nodos
    {COMPRA_CONJUNTA:
    {orientation: 'UNDIRECTED',
     Properties: 'weight'
    }}
)

call gds.k1coloring.write('myUndirectedGraph', {writeProperty: 'k1color'})
YIELD nodeCount, colorCount, ranIterations, didConverge;

call gds.louvain.write('myUndirectedGraph',{writeProperty: 'louvain'})
YIELD communityCount, modularity, modularities

MATCH (p:Producto {nombre:'Nivel'}), (m)
WHERE p.louvain = m.louvain
RETURN p.nombre, p.louvain,  m.nombre, m.louvain 
LIMIT 3;

//5
CALL gds.graph.project(
    'myNaturalGraph', // Nombre del sub grafo
    'Producto', // Tipos de nodos
    {COMPRA_CONJUNTA:
    {orientation: 'NATURAL',
     Properties: 'weight'
    }}
)

CALL gds.pageRank.write(
        'myNaturalGraph',
        {
                writeProperty: 'PageRank',
                maxIterations: 20,
                dampingFactor: 0.85
        }

)
YIELD nodePropertiesWritten, ranIterations

MATCH (p:Producto {nombre:'Martillo'})-[r:COMPRA_CONJUNTA]->(n)
RETURN n.nombre AS Producto, r.weight AS ComprasConjuntas, n.PageRank AS PR
ORDER BY PR DESC, ComprasConjuntas DESC
LIMIT 3;

//6
MATCH (src:Producto {nombre:'Taladro'})

CALL gds.allShortestPaths.delta.write('myNaturalGraph',
{
    sourceNode: src,
    relationshipWeightProperty: 'weight',
    writeRelationshipType: 'PATH_Delta_Taladro',
    writeNodeIds: true,
    writeCosts: true
}
)
YIELD relationshipsWritten
RETURN relationshipsWritten;
// Visualización con Bloom

//7
MATCH (src:Producto {nombre:'Martillo de goma'}), (dst:Producto {nombre:'Llave inglesa'})

CALL gds.shortestPath.dijkstra.write('myNaturalGraph', {
    sourceNode: src,
    targetNode: dst,
    relationshipWeightProperty: 'weight',
    writeRelationshipType: 'Dijkstra_D_MartilloGoma_To_LlaveInglesa',
    writeNodeIds: true,
    writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten;

//8
MATCH  (p:Producto)
WHERE p.nombre IN ['Transportador']
WITH COLLECT(p) as sourceNodes

CALL gds.randomWalk.stream('myNaturalGraph',
{
    walkLength: 2,
    walksPerNode: 1,
    randomSeed: 42,
    concurrency: 1
}
)
YIELD nodeIds, path
RETURN  nodes(path);

//9
MATCH (p:Producto {nombre:$neodash_producto_nombre})-[r:COMPRA_CONJUNTA]->(n)
RETURN n.nombre AS Producto, r.weight AS ComprasConjuntas
ORDER BY ComprasConjuntas DESC
LIMIT 3;

//10
MATCH (p:Producto {nombre:$neodash_producto_nombre})-[r:COMPRA_CONJUNTA]->(n)
WHERE p.louvain = n.louvain
RETURN n.nombre AS Producto, n.louvain AS LV, r.weight AS ComprasConjuntas
ORDER BY ComprasConjuntas DESC
LIMIT 3;