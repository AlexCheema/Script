const axios = require("axios");

const NETWORK = "GOERLI";
const SUBGRAPH_URL = {
    "GOERLI": "https://api.thegraph.com/subgraphs/name/ianlapham/uniswap-v3-gorli",
    "MAINNET": "https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v3",
}[NETWORK];

const feeTierToTickSpacing = {
    100: 1,
    500: 10,
    3000: 60,
    10000: 200
};

async function getPoolState(pool, owner) {
    const query = `
    {
        pool(id: "${pool}") {
            tick
            feeTier
            sqrtPrice
        }
        positions(where: {
            pool: "${pool}",
            owner: "${owner}"
        }) {
            id
            owner
            tickLower {
                tickIdx
            }
            tickUpper {
                tickIdx
            }
            liquidity
        }
    }
    `;

    const result = await axios.post(SUBGRAPH_URL, { query });

    if (!result.data?.data?.positions || !result.data?.data?.pool) {
        throw new Error(`Bad pool state response: ${JSON.stringify(result.data)}`);
    }

    return {
        tickSpacing: feeTierToTickSpacing[result.data.data.pool.feeTier] ?? 1,
        tick: result.data.data.pool.tick,
        sqrtPrice: result.data.data.pool.sqrtPrice,
        positions: result.data?.data?.positions ?? [],
    }
}

module.exports.getPoolState = getPoolState;