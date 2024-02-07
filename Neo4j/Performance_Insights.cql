/Cypher Query Language

//Task 0 - Find isolated nodes
// Finding isolated nodes and self-pointing relationships in the database.

MATCH (z1:zone) - [relation:CONNECTS] -> (z2:zone)
WHERE z1.id = z2.id
RETURN count(relation)

MATCH (z1:zone) - [relation:CONNECTS] -> (z2:zone)
WHERE z1.id = z2.id
RETURN z1,relation,z2
//LIMIT 10

MATCH (z:zone)
WHERE NOT (z) - [:CONNECTS] - (:zone)
RETURN z


//Task 1 - Community detection
// Using the Louvain algorithm for community detection to identify clusters of strongly connected zones.


CALL gds.graph.create(
    'USERNAME-communities_220195227',
    'zone',
    {
        CONNECTS: {
            orientation: 'UNDIRECTED'
                }
    },
    {
        relationshipProperties: 'trips'
    }
)


//stats

CALL gds.louvain.stats(
    'USERNAME-communities_220195227', {relationshipWeightProperty: 'trips'})
YIELD communityCount

//stream

CALL gds.louvain.stream(
    'USERNAME-communities_220195227', {relationshipWeightProperty: 'trips'})
YIELD nodeId, communityId
RETURN gds.util.asNode(nodeId).id AS zone_id, communityId as community_id
ORDER BY zone_id ASC

//Task 2 - Centrality analysis
// Using the Page Rank algorithm for centrality analysis to measure the hub-like features of each zone.

CALL gds.graph.create(
    'USERNAME-pagerank_220195227',
    'zone',
    'CONNECTS',
    {
        relationshipProperties: 'trips'
    }
)

//stats

CALL gds.pageRank.stats(
    'USERNAME-pagerank_220195227',
    {
        dampingFactor: 0.75,
        relationshipWeightProperty: 'trips'
    })
YIELD centralityDistribution
RETURN centralityDistribution.min as Min_CentralityScore, centralityDistribution.max AS Max_CentralityScore

// stream

CALL gds.pageRank.stream(
    'USERNAME-pagerank_220195227',
    {
        dampingFactor: 0.75,
        relationshipWeightProperty: 'trips'
    })
YIELD nodeId, score 
RETURN gds.util.asNode(nodeId).id AS zone_id, score
ORDER BY zone_id ASC


// Task 3 - Zone recommendation - Top 3 highest centrality zones per community
// Combining the results of tasks 2 and 3 by identifying the top three zones with the highest centrality score within each community cluster.


// 1. Including zones in the 'Manhattan' borough.

MATCH (z:zone)
WITH z
ORDER BY z.centrality  DESC
WITH z.community as community, COLLECT(z.id)[..3] as top_three
UNWIND top_three AS zone_id
RETURN zone_id, community as community_id


//2.Excluding zones in the 'Manhattan' borough.

MATCH (z:zone) - [:IN] -> (b:borough)
WHERE b.name <> "Manhattan"
WITH z
ORDER BY z.centrality DESC
WITH z.community as community, COLLECT(z.id)[..3] as top_three
UNWIND top_three AS zone_id
RETURN zone_id, community as community_id