// Codigo Tarea 7 - Sofía Maldonado García

//
// Instrucciones de Atributos
//

// NATURAL = outDegree (también se usó para los otros atributos)
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


// REVERSE = inDegree
CALL gds.graph.project(
  'myReverseGraph',
  ['Person', 'Droid', 'Movie'],
  {
    APPEARS_IN: {
      orientation: 'REVERSE'
    },
    SPEAKS_WITH: {
      orientation: 'REVERSE'
    }
  }
)

// UNDIRECTED = Degree
CALL gds.graph.project(
  'myUndirectedGraph',
  ['Person', 'Droid', 'Movie'],
  {
    APPEARS_IN: {
      orientation: 'UNDIRECTED'
    },
    SPEAKS_WITH: {
      orientation: 'UNDIRECTED'
    }
  }
)

// Degrees
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

// PageRank
CALL gds.pageRank.write(
        'myNaturalGraph',
        {
                writeProperty: 'PageRank',
                maxIterations: 20,
                dampingFactor: 0.85
        }

)
YIELD nodePropertiesWritten, ranIterations

// Closeness
call gds.closeness.write(
        'myNaturalGraph',
        {
                writeProperty: 'Closeness'
        }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinimumScore, centralityDistribution.mean AS MeanScore, nodePropertiesWritten;

// Betweenness
CALL gds.betweenness.write(
        'myNaturalGraph',
        {
                writeProperty: 'betweenness'
        }
)
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinimunScore, centralityDistribution.mean AS MeanScore, nodePropertiesWritten;

// Eigenvector
CALL gds.eigenvector.write('myNaturalGraph', {
  maxIterations: 20,
  writeProperty: 'Eigenvector'
})
YIELD nodePropertiesWritten, ranIterations

//
// Código Dashboard
//

// 1.
call db.schema.visualization

// 2.
MATCH (m:Movie)
RETURN m.name AS Movie, m.PageRank As PageRank
ORDER BY PageRank DESC;

// 3.
MATCH (n)
RETURN n.name AS Name, n.Eigenvector AS Eigenvector
ORDER BY Eigenvector DESC;

// 4.
MATCH (m)
RETURN avg(m.Closeness)

// 5.
MATCH (d:Droid)
RETURN d.name AS Name, d.betweenness AS Betweenness
ORDER BY Betweenness DESC;

// 6.
MATCH (d:Droid)
RETURN d.name AS Name, d.degree AS Degree, d.inDegree AS InDegree, d.outDegree AS OutDegree
ORDER BY Degree DESC;

// 8.
MATCH (p:Person {name:$neodash_person_name})
WITH p
MATCH (p)-[r:APPEARS_IN]->(m:Movie)
RETURN p.name AS Name, COLLECT(m.name) AS Movies, p.degree AS Degree, 
p.inDegree AS InDegree, p.outDegree AS OutDegree, p.PageRank AS PageRank,
p.Closeness AS Closeness, p.betweenness AS BC, p.Eigenvector AS Eigenvector; 