// Apuntes Minería de Grafos - Cypher
// Verano 2025
// Sofía Maldonado García

// Limpia la pantalla
:clear

// Historial de comandos que se han corrido
:history

// Nodos
()
:Persona
:persona // TODAS son etiquetas distintas, en Cypher si importan las mayúsculas y minúsculas
:PERSONA
:personA

(:Persona) // Representación de un nodo con la etiqueta "Persona"

// Atributos
{}
nombre
NOMBRE // De nuevo, atributos distintos
Nombre

{nombre:'Juan'} // Representación de un atributo con un valor

// Relaciones
-- <-- -->


-[]- <-[]- -[]->
:AMIGO
:amigo
:Amigo

CREATE // Sirve para crear relaciones, nodos, etc

CREATE (:Persona);
CREATE (:Persona {nombre:"Juan"});
CREATE (:Persona {nombre:"Juan"})-[:AMIGO]->(:Persona{nombre:"Luis"})

MERGE (:Persona {nombre:"Juan"});

// Terminología SQL vs Cypher
// SELECT = RETURN
// FROM = MATCH
// WHERE = WHERE

RETURN 100*3

MATCH (n)
RETURN n AS Nodos;

MATCH (n:Persona)

MATCH (n)-[r:AMIGO]->(m)
RETURN n, r,m;

MERGE (:Producto {desc:"Lapiz"})-[:PARTE_DE]->(:Categoria {nombre:"Papeleria"})
MERGE (:Tienda {nombre:"Superpapelerias"})-[:TIENE]->(:Producto {desc:"Lapiz"})
MERGE (:Tienda {nombre:"Superpapelerias"})-[:TIENE]->(:Producto {desc:"Monitor"})

CREATE (:Producto {desc:"Monitor"})<-[:TIENE]-(:Tienda {nombre:"Superpapelerias"})-[:TIENE]->(:Producto {desc:"Lapiz"})-[:PARTE_DE]->(:Categoria {nombre:"Papeleria"})

// Para agregarle otro más
MATCH (t:Tienda {nombre:"Superpapelerias"})
CREATE (t)-[:TIENE]->(:Producto {desc:"Teclado"})


// BORRAR TODO
MATCH (n) DETACH DELETE (n);

MATCH (t:Tienda {nombre:"Superpapelerias"})
CREATE (t)<-[r:OWNER]-(p:Persona{nombre:"Luis"}) 


MATCH (t:Tienda {nombre:"Superpapelerias"})
RETURN t;

MATCH (t:Tienda {nombre:"Superpapelerias"})
MERGE (t)<-[r:OWNER]-(p:Persona{nombre:"Luis"}); 

MATCH (t:Tienda {nombre:"Superpapelerias"})
MATCH (p:Persona{nombre:"Luis"})
MERGE (t)<-[r:OWNER]-(p); 

// Muestra el schema
call db.schema.visualization

// Mostrar atributos de nodos
call db.schema.nodeTypeProperties

// Mostrar atributos de relaciones
call db.schema.relTypeProperties

// Contar todos los nodos tipo Person
MATCH (p:Person)
RETURN COUNT(DISTINCT p);

// Contar todos los nodos de un tipo
MATCH (p:Person)-[r:FOLLOWS]->(p:Person)
RETURN COUNT(DISTINCT r);

// AZul - Zoé (Muestra películas donde actúa Tom Hanks)
MATCH (p:Person {name:"Tom Hanks"})-[r:ACTED_IN]->(m:Movie)
RETURN p,r,m

// Ver si coinciden dos personas en una peli, en cualquier rol
MATCH (p:Person {name:"Tom Hanks"})-[r]->(m:Movie)<-[r2]-(p2:Person {name:"Keanu Reeves"})
RETURN p,m,p2;

// DEGREE TOTAL KEVIN BACON
MATCH (p:Person {name:"Kevin Bacon"})-[r]->()
MATCH (p:Person {name:"Kevin Bacon"})<-[2]-()
MATCH (p:Person {name:"Kevin Bacon"})-[r3]-()
RETURN p.name AS Persona,
        COUNT(DISTINCT r) as OutDegree,
        COUNT(DISTINCT r2) as InDegree,
        COUNT(DISTINCT r3) as Degree;

// Consulta para in, out, y Degree de un nodo
// Out
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)-[r]->(m)
RETURN p.name, COUNT(DISTINCT r) AS OutDegree; 

// IN
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)<-[r]-(m)
RETURN p.name, COUNT(DISTINCT r) AS InDegree; 

// Degree
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)-[r]-(m)
RETURN p.name AS Actorx, COUNT(DISTINCT r) AS Degree;

// Degree
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)-[r1]->(m) 
MATCH (p)<-[r2]-(m) 
MATCH (p)-[r3]-(m)
RETURN p.name AS Actorx, COUNT(DISTINCT r1) AS OutDegree, COUNT(DISTINCT r2) AS InDegree, COUNT(DISTINCT r3) AS Degree;

// Subconsulta

MATCH (p:Person)
CALL {
        WITH p
        MATCH (p)-[r]->(m)
        RETURN COUNT(DISTINCT r) AS OutDegree
}
CALL {
       WITH p
        MATCH (p)<-[r]-(m)
        RETURN COUNT(DISTINCT r) AS InDegree  
}
CALl {
        WITH p
        MATCH (p)-[r]-(m)
        RETURN COUNT(DISTINCT r) AS Degree
}
RETURN p.name, OutDegree,InDegree,Degree
ORDER BY Degree DESC LIMIT 5;

// Peliculas con mayor Degree
MATCH (p:Movie)
CALL {
        WITH p
        MATCH (p)-[r]->(m)
        RETURN COUNT(DISTINCT r) AS OutDegree
}
CALL {
       WITH p
        MATCH (p)<-[r]-(m)
        RETURN COUNT(DISTINCT r) AS InDegree  
}
CALl {
        WITH p
        MATCH (p)-[r]-(m)
        RETURN COUNT(DISTINCT r) AS Degree
}
RETURN p.title, OutDegree,InDegree,Degree
ORDER BY Degree DESC;

// Crear parametros
:help param

:param name => 'Kevin Bacon';
:param num => 2; 
RETURN $name, $num;

// Muestra las transacciones y los parametros creados
SHOW TRANSACTIONS YIELD *;

// Todos los nodos que Kevin Bacon puede alcanzar en 2 pasos
MATCH (p:Person{name:'Kevin Bacon'})-[*1..2]-(m)
RETURN COUNT(DISTINCT m);

// Todos los nodos que Kevin Bacon puede alcanzar en 2 pasos EXACTOS
MATCH (p:Person{name:'Kevin Bacon'})-[*2]-(m)
RETURN COUNT(DISTINCT m);

// BLOOM

/// DATASET Star Wars


// Cuantos nodos persona y cuantos nodos movie hay?
MATCH (p:Person)
RETURN p.name AS Nombre, p.born AS Fecha De Nacimiento
ORDER BY p.born;

// # de actores por película
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
RETURN m.title AS Peli, COUNT(p) as Personas DESC; 

// Top 5 películas con más actores
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
RETURN m.title AS Peli, COUNT(p) as Personas
ORDER BY Personas DESC
LIMIT 5;

// 
// ALGORITMOS DE CENTRALIDAD
//

// PAGERANK
// Paso 1. Crear SubGrafo
call gds.graph.project(
        'myGraph',
        'Villian',
        'COMPANION',
        {relationshipProperties:'Weight'}
)

// Paso 2. Calcular la memoria 
CALL gds.pageRank.write.estimate(
        'myGraph',
        {
                writeProperty: 'PageRank',
                maxIterations: 20,
                dampingFactor: 0.85
        }
);

// Paso 3. Ejecutar algoritmo
CALL gds.pageRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score AS PageRankScore
ORDER BY PageRankScore DESC;

// Paso 4. Añadir atributo de score de PageRank a los nodos/relaciones.  
CALL gds.pageRank.write(
        'MyGraph',
        {
                writeProperty: 'PageRank',
                maxIterations: 20,
                dampingFactor: 0.85
        }

)
YIELD nodePropertiesWritten, ranIterations

//
// Betweenness Centrality
//

// Paso 1. Crear SubGrafo
call gds.graph.project(
        'myGraph',
        'Villian',
        'COMPANION',
        {relationshipProperties:'Weight'}
)

// Paso 2. Calcular la memoria 
CALL gds.betweenness.write.estimate(
        'myGraph',
        {
                writeProperty: 'betweenness'
        }
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory;

// Paso 3. Aplicar algoritmo
CALL gds.betweenness.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score AS BetweennessScore
ORDER BY BetweennessScore DESC;

// Paso 4. Añadir atributo del algoritmo a los nodos
CALL gds.betweenness.write(
        'myGraph',
        {
                writeProperty: 'betweenness'
        }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinimunScore, centralityDistribution.mean AS MeanScore, nodePropertiesWritten;

// Centrality
// 1. Crear un sub grafo
// NATURAL = outDegree
CALL gds.graph.project(
    'myNaturalGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'NATURAL',
     Properties: 'Weight'
    }}
)

// REVERSE = inDegree
CALL gds.graph.project(centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinimumScore, centralityDistribution.mean AS MeanScore, nodePropertiesWritten
    'myReverseGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'REVERSE',
     Properties: 'Weight'
    }}
)

// UNDIRECTED = Degree
CALL gds.graph.project(
    'myUndirectedGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'UNDIRECTED',
     Properties: 'Weight'
    }}
)

// 4. Añadir un nuevo atributo a los nodos/relaciones

// OutDegree
CALL gds.degree.write('myNaturalGraph', {writeProperty:'outDegree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

//InDegree
CALL gds.degree.write('myReverseGraph', {writeProperty:'inDegree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

//Degre
CALL gds.degree.write('myUndirectedGraph', {writeProperty:'degree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

// Consulta que regrese Name, PageRank, BC, In, Out, Degree
MATCH (v:Villian )
RETURN v.Name, v.PageRank, v.betweenness, v.inDegree, v.outDegree, v.degree
ORDER BY v.degree DESC

//
// Closeness Centrality
//

// 1.
CALL gds.graph.project(
    'myNaturalGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'NATURAL',
     Properties: 'Weight'
    }}
)

// 4. Añadir atributo closeness centrality
call gds.closeness.write(
        'myNaturalGraph',
        {
                writeProperty: 'Closeness'
        }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinimumScore, centralityDistribution.mean AS MeanScore, nodePropertiesWritten;

//
// Bridges
//

// 1. 
CALL gds.graph.project(
    'myNaturalGraph', // Nombre del sub grafo
    'Villian', // Tipos de nodos
    {COMPANION:
    {orientation: 'NATURAL',
     Properties: 'Weight'
    }}
)

// 4. 
// Sub Grafo para TODO el Dataset
CALL gds.graph.project(
  'myNaturalGraph',
  ['Person', 'Droid', 'Movie'],
  {
    APPEARS_IN: {
      orientation: 'NATURAL'
    },
    SPEAKS_WITH: {
      orientation: 'NATURAL'
    }
  }
)

//
// Actividad Dashboard, Códigos
//

// 1.
call db.schema.visualization

// 2.
MATCH (n)
RETURN labels(n) AS Nodes, count(n) AS NodeCount
ORDER BY NodeCount DESC;

// 3.
MATCH (s:SuperHero)-[r]-(s2:SuperHero)
RETURN s,r,s2;

// 5.
MATCH (s:SuperHero)
RETURN s.degree AS Degree, COUNT(s) AS NumHero
ORDER BY Degree DESC;

// 6.
MATCH (s:SuperHero)
RETURN s.PageRank AS PageRank, COUNT(s) AS NumHero
ORDER BY PageRank DESC;

// 7.
MATCH (s:SuperHero)
RETURN s.betweenness AS Betweenness, COUNT(s) AS NumHero
ORDER BY Betweenness DESC;

// 8.
MATCH (s:SuperHero {Name:$neodash_superhero_name})
RETURN s.Name AS Name, s.inDegree AS InDegree, s.outDegree1 AS OutDegree, s.degree AS Degree, s.PageRank AS PageRank, s.betweenness AS Betweenness;

// 
// ALGORITMOS DE COMUNIDAD
//


// 1. LOUVAIN
// Subgrafo no(!!) dirigido
call gds.graph.project(
        'myGraph',
        'Villian',
        {COMPANION: {orientation: 'UNDIRECTED'}}
)

// Implementación
call gds.louvain.write('myGraph',{writeProperty: 'louvain'})
YIELD communityCount, modularity, modularities

// Código que muestra cada comunidad, su # de miembros y los miembros en una lista
MATCH (v:Villian)
RETURN v.louvain AS Louvain, COUNT(DISTINCT v) AS NumberOfMembers, COLLECT(v.Name) AS Members;

// Para ver las comunidades entre las iteraciones
call gds.louvain.stream('myGraph', {includeIntermediateCommunities: true})
YIELD nodeId, communityId, intermediateCommunityIds
RETURN gds.util.asNode(nodeId).Name AS Name, communityId, intermediateCommunityIds
ORDER BY communityId ASC, intermediateCommunityIds ASC, Name ASC;

// 2. K-1 COLORING

// Subgrafo
call gds.graph.project(
        'myUndirectedGraph',
        'Villian',
        {COMPANION: {orientation: 'UNDIRECTED'}}
)

// Implementado
call gds.k1coloring.write('myUndirectedGraph', {writeProperty: 'k1color'})
YIELD nodeCount, colorCount, ranIterations, didConverge;

// Para ver colores, cuántos nodos tienen cada color, y los nodos
MATCH (v:Villian)
RETURN v.k1color AS Color, COUNT(DISTINCT v) AS MembersPerColor, COLLECT(v.Name) AS Names;

// Cambiar color 0 a otro color, para Bloom
MATCH (v:Villian)
SET v.k1color = k1color + 1

// 3. Label Propagation

// Subgrafo dirigido con pesos
call gds.graph.project(
        'myGraph',
        'Villian',
        {COMPANION: {orientation: 'NATURAL', properties:'Weight'}}
)

// Implementado
call gds.labelPropagation.write('myGraph', {writeProperty: 'labelPropagation'})
YIELD communityCount, ranIterations, didConverge

// Para ver las comunidades
MATCH (v:Villian)
RETURN v.labelPropagation AS LP, COUNT(v) AS NumberOfMembers, COLELCT (v.Name) AS Members
ORDER BY LP ASC;

// Añadimos una restricción iniciando con la semilla de Joker
MATCH (v:Villian {name:'Joker'})
SET v.comunidadInicial = v.labelPropagation;

// Subgrafo con la nueva semilla
call gds.graph.project(
        'myAlterGraph',
        'Villian',
        {COMPANION: {orientation:'UNDIRECTED'}},
        {nodeProperties:['comunidadInicial']}
)

// Añade el atributo con la semilla de Joker
call gds.labelPropagation.write('myAlterGraph', {
        seedProperty: 'comunidadInicial',
        writeProperty: 'labelPropagationSeed'
})
YIELD communityCount, ranIterations, didConverge;

// 4. WEAKLY CONNECTED COMPONENTS
call gds.graph.project(
        'myUndirectedGraph',
        'Villian',
        {COMPANION: {orientation: 'UNDIRECTED', properties:'Weight'}}
)

// Implementado
call gds.wcc.write('myUndirectedGraph', {writeProperty: 'wcc'})
YIELD componentCount, componentDistribution

// Villanos por comunidad
MATCH (v:Villian)
RETURN v.wcc AS WCC, COUNT(v) AS NumberOfMembers, COLELCT (v.Name) AS Members
ORDER BY WCC ASC;

// Para Bloom
MATCH (v:Villian)
SET v.wcc = v.wcc + 1

// 5. SCC
call gds.graph.project(
        'myNaturalGraph',
        'Villian',
        {COMPANION: {orientation: 'NATURAL', properties:'Weight'}}
)

// Implementado
call gds.scc.write('myNaturalGraph', {writeProperty: 'scc'})
YIELD componentCount, componentDistribution

// Villanos por comunidad
MATCH (v:Villian)
RETURN v.scc AS SCC, COUNT(v) AS NumberOfMembers, COLELCT (v.Name) AS Members
ORDER BY SCC ASC;

// Para Bloom
MATCH (v:Villian)
SET v.scc = v.scc + 1

// TRIANGLE COUNT
// Ocupa SubGrafo No Dirigido
CALL gds.triangleCount.write('myGraph', {
  writeProperty: 'triangles'
})
YIELD globalTriangleCount, nodeCount

// Villanos Por Comunidad
MATCH (v:Villian)
RETURN v.triangles AS Triangulo, COUNT(DISTINCT v.Name) AS Number, COLLECT(DISTINCT v.Name) AS Nombres
ORDER BY Number DESC;

//+1 Para Bloom
MATCH (v:Villian)
SET v.triangles = v.triangles + 1

// Mostrar integrantes de cada triángulo
CALL gds.triangles('myUndirectedGraph2')
YIELD nodeA, nodeB, nodeC
RETURN
    gds.util.asNode(nodeA).Name AS NodoA,
    gds.util.asNode(nodeB).Name AS NodoB,
    gds.util.asNode(nodeC).Name AS NodoC
ORDER BY NodoA,NodoB,NodoC ASC;

// LOCAL CLUSTERING COEFFICIENT
// Subgrafo no Dirigod
CALL gds.localClusteringCoefficient.write('myUndirectedGraph', {
  writeProperty: 'localClusteringCoefficient'
})
YIELD averageClusteringCoefficient, nodeCount


// RECOMENDACIONES
// Para crear Northwind
:play northwind-graph

//Con el dataset de la tienda, ver cuáles dos combinaciones aparecen en la mayor cantidad de órdenes
MATCH x = (p:Product)-[:ORDERS]-(o:Order)-[:ORDERS]-(op:Product)
WHERE p.productName = 'Chai'
    RETURN p.productName, op.productName, COUNT(o) AS TotalOrders
    ORDER BY TotalOrders DESC;

// Encontrar la categoría de los productos también
MATCH (c:Category) <-[:PART_OF]- (p:Product) <-[:ORDERS]- (o:Order) -[:ORDERS]-> (op:Product) -[:PART_OF]-> (c2:Category) 
WHERE p.productName = 'Chai' 
RETURN p.productName AS Product1,
c.categoryName AS Category_Product1, 
op.productName AS Product2, 
c2.categoryName AS Category_Product2,
COUNT(o.orderID) AS Count
ORDER BY Count DESC
LIMIT 3;

// Recomendar productos de la misma categoría
MATCH (c:Category) <-[:PART_OF]- (p:Product) <-[:ORDERS]- (o:Order) -[:ORDERS]-> (op:Product) -[:PART_OF]-> (c2:Category) 
WHERE p.productName = 'Chai' AND c.categoryName = c2.categoryName
RETURN p.productName AS Product1,
c.categoryName AS Category_Product1, 
op.productName AS Product2, 
c2.categoryName AS Category_Product2,
COUNT(o.orderID) AS Count
ORDER BY Count DESC
LIMIT 3;

// Recomendar productos del mismo proveedor 
MATCH (s:Supplier) -[:SUPPLIES]-> (p:Product) <-[:ORDERS]- (o:Order) -[:ORDERS]-> (op:Product) <-[:SUPPLIES]- (s2:Supplier) 
WHERE p.productName = 'Chai' AND s.companyName = s2.companyName
RETURN p.productName AS Product1,
s.companyName AS Supplier_Product1, 
op.productName AS Product2, 
s2.companyName AS Supplier_Product2,
COUNT(o.orderID) AS Count
ORDER BY Count DESC
LIMIT 3;

// Forma más eficiente de hacer lo mismo, evaluando por relación
MATCH (s:Supplier) -[:SUPPLIES]-> (p:Product) <-[:ORDERS]- (o:Order) -[:ORDERS]-> (op:Product) <-[:SUPPLIES]- (s2:Supplier) 
WHERE p.productName = 'Chai' AND (op) <-[:SUPPLIES]- (s)
RETURN p.productName AS Product1,
s.companyName AS Supplier_Product1, 
op.productName AS Product2, 
s2.companyName AS Supplier_Product2,
COUNT(o.orderID) AS Count
ORDER BY Count DESC
LIMIT 3;

// Hacer recomendaciones en base al nombre del proveedor 
MATCH (s:Supplier) -[:SUPPLIES]-> (p:Product) <-[:ORDERS]- (o:Order) -[:ORDERS]-> (op:Product) <-[:SUPPLIES]- (s2:Supplier) 
WHERE s.companyName = 'Pavlova' AND (op) <-[:SUPPLIES]- (s)
RETURN p.productName AS Product1,
s.companyName AS Supplier_Product1, 
op.productName AS Product2, 
s2.companyName AS Supplier_Product2,
COUNT(o.orderID) AS Count
ORDER BY Count DESC
LIMIT 3;

// Hacer recomendaciones en base a la cercanía entre clientes
MATCH (c:Customer) -[:PURCHASED]-> (o:Order) -[:ORDERS]-> (p:Product) <-[:ORDERS]- (o2:Order) -[:ORDERS]-> (p2:Product)     // Intricate relationship entre clientes, productos y órdenes
MATCH (o2) <-[:PURCHASED]- (c2:Customer)                // Relación con el 2do cliente
WHERE c.postalCode = '1010' AND                         // Condiciones. Código Postal = 1010
c.postalCode = c2.postalCode AND                        // Mismo Código Postal entre clientes
p.productName = "Sir Rodney's Scones" AND               // Nombre del producto de interés
RETURN c.postalCode AS Location1,
p.productName AS Product1,
c2.postalCode AS Location2,
p2.productName AS Product2,
COUNT(o.orderID) AS Count
ORDER BY Count DESC
LIMIT 3;

// Alterar el grafo para construir una relación entre los nodos producto
// Llamada 'BUY_TOGETHER' para evaluar los productos que se compran en conjunto usualmente
MATCH (p:Product) <-[:ORDERS]- (o:Order) -[:ORDERS]-> (p2:Product)
WITH p, p2, COUNT(o.orderID) AS qty
MERGE (p) -[:BUY_TOGETHER {quantity:qty}]-> (p2)-            // Añadirle un peso a la relación

//AÑADIR MODELOS CENTRALIDAD
// PAGERANK
// Subgrafo
call gds.graph.project(
        'myGraph',
        'Product',
        'BUY_TOGETHER',
        {relationshipProperties:'quantity'}
)

// Paso 4. Añadir atributo de score de PageRank a los nodos/relaciones.  
CALL gds.pageRank.write(
        'MyGraph',
        {
                writeProperty: 'PageRank',
                maxIterations: 20,
                dampingFactor: 0.85
        }

)
YIELD nodePropertiesWritten, ranIterations

// Las recomendaciones si has comprado Chai, consulta simple
MATCH (p:Product)-[r:BUY_TOGETHER]->(op:Product)
WHERE p.productName = 'Chai'
RETURN p.productName, op.productName, r.quantity AS qty
ORDER BY qty DESC
LIMIT 3;

//Consulta avanzada, considerando PageRank y ordenandolo en base al PageRank Y en base a la cantidad
MATCH (p:Product)-[r:BUY_TOGETHER]->(op:Product)
WHERE p.productName = 'Chai'
RETURN p.productName, op.productName, op.PageRank AS PR, r.quantity AS qty
ORDER BY qty DESC, PR DESC
LIMIT 3;

//Ver lista de subgrafos
call gds.graph.list()
YIELD graphName, nodeCount, relationshipCount, database, creationTime;

// PATH FINDING
// Todos los caminos desde Lex Luthor, undirected y directed

//Lex Luthor Undirected
MATCH (src:Villian {Name:'Lex Luthor'})

CALL gds.allShortestPaths.delta.write('myUndirectedGraph',
{
    sourceNode: src,
    relationshipWeightProperty: 'Weight',
    writeRelationshipType: 'PATH_Lex_Luthor_Undirected',
    writeNodeIds: true,
    writeCosts: true
}
)
YIELD relationshipsWritten
RETURN relationshipsWritten;

//LEx Luthor Natural
MATCH (src:Villian {Name:'Lex Luthor'})

CALL gds.allShortestPaths.delta.write('myNaturalGraph',
{
    sourceNode: src,
    relationshipWeightProperty: 'Weight',
    writeRelationshipType: 'PATH_Lex_Luthor',
    writeNodeIds: true,
    writeCosts: true
}
)
YIELD relationshipsWritten
RETURN relationshipsWritten;

//Consultar info sobre el camino entre dos nodos
MATCH (v:Villian {Name:'Lex Luthor'})-[r:PATH_Lex_Luthor_Undirected]->(w:Villian {Name:'Catwoman'})
RETURN v.Name AS Source, r.nodeIds, r.costs, r.totalCost AS CostoTotal, w.Name AS Destination;

//DJIKSTRA

MATCH (src:Villian {Name:'Ultron'}), (dst:Villian {Name:'Cheetah'})

CALL gds.shortestPath.dijkstra.write('myNaturalGraph', {
    sourceNode: src,
    targetNode: dst,
    relationshipWeightProperty: 'Weight',
    writeRelationshipType: 'Dijkstra_D_Ultron_To_Cheetah',
    writeNodeIds: true,
    writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten;

// Para ver los personajes en el medio
UNWIND [41,45,46,24,38] AS vid
MATCH (v:Villian)
WHERE id(v) = vid
RETURN v.Name, id(v);

//RANDOM WALK
CALL gds.randomWalk.stream('myNaturalGraph',
{
    walkLength: 2,
    walksPerNode: 1,
    randomSeed: 42,
    concurrency: 1
}
)
YIELD nodeIds, path
RETURN nodeIds, path;

//Para ver los nodos intermedios
MATCH  (v:Villian)
WHERE v.Name IN ['Lex Luthor']
WITH COLLECT(v) as sourceNodes

CALL gds.randomWalk.stream('myNaturalGraph',
{
    walkLength: 2,
    walksPerNode: 1,
    randomSeed: 42,
    concurrency: 1
}
)
YIELD nodeIds, path
RETURN nodeIds, [node IN nodes(path) | node.Name] AS Camino;